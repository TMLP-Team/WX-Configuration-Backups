#!/system/bin/sh
readonly EXIT_SUCCESS=0
readonly EXIT_FAILURE=1
readonly EOF=255
readonly scriptName="autoImport.sh"
readonly repositoryHomePage="https://github.com/TMLP-Team/WX-Configuration-Backups"
readonly repositoryContentLink="https://raw.githubusercontent.com/TMLP-Team/WX-Configuration-Backups/main"
readonly wechatPackageName="com.tencent.mm"
readonly wechatUI=".ui.LauncherUI"
readonly wxPackageName="com.fkzhang.wechatxposed"
readonly xPackageName="cn.android.x"
readonly wxRepairToolPackageName="wx.repair.tool"
readonly coreData="%E6%A0%B8%E5%BF%83%E6%96%87%E4%BB%B6"
readonly fkzWxData="FKZ_WX_DATA"
readonly coreData0FolderPath="/data/user/0/${wechatPackageName}/files"
readonly coreData999FolderPath="/data/user/999/${wechatPackageName}/files"
readonly fkzWxDataFolderPath="/data/data/${wechatPackageName}/databases"
readonly fkzWxDataFileName="FKZ_WX_DATA"
readonly fkzWxDataFilePath="${fkzWxDataFolderPath}/${fkzWxDataFileName}"
readonly timeToSleep=3
if [[ -n "${EXTERNAL_STORAGE}" ]];
then
	readonly downloadFolderPath="${EXTERNAL_STORAGE}/Download"
else
	readonly downloadFolderPath="/sdcard/Download"
fi

# Welcome (1--3) #
echo "Welcome to the \`\`${scriptName}\`\`. Please check the script before you execute it. "
echo "欢迎使用 \`\`${scriptName}\`\`，请审计该脚本后再执行该脚本。"
echo ""
echo "Please kindly submit core and FKZ_WX_DATA configuration files to ${repositoryHomePage} if you have. Thank you. "
echo "如您拥有核心文件或 FKZ_WX_DATA 数据的存档，请向 ${repositoryHomePage} 提交拉取请求（Pull Request，简称 PR）。感谢！"
echo ""
if [[ $(id -u) -eq 0 ]];
then
	mkdir -p "${downloadFolderPath}"
	if [[ $? -eq ${EXIT_SUCCESS} && -d "${downloadFolderPath}" ]];
	then
		echo "The local folder for download \"${downloadFolderPath}\" is ready. "
		echo "本地用于下载的文件夹 \"${downloadFolderPath}\" 已就绪。"
		echo ""
	else
		echo "This script will exit soon since it failed to handle the local folder for download \"${downloadFolderPath}\" (2). "
		echo "由于无法就绪本地用于下载的文件夹 \"${downloadFolderPath}\"，本脚本即将退出（2）。"
		echo ""
		exit 2
	fi
else
	echo "This script was not executed with root permissions. Please execute it as root. If your device is not rooted, please visit the above homepage or other repositories to find the appropriate configuration data for download and manually import (3). "
	echo "脚本没有被授予 root 权限，请使用 root 身份执行；如设备未 root，请自行访问上述主页或其它仓库寻找适配的配置数据进行下载并手动导入（3）。"
	echo ""
	exit 3
fi

# Versions (11--14) #
wechatVersionName="$(dumpsys package ${wechatPackageName} | grep versionName | cut -d '=' -f2)"
wechatVersionCode="$(dumpsys package ${wechatPackageName} | grep versionCode | cut -d '=' -f2 | cut -d ' ' -f1)"
wechatUserId="$(dumpsys package ${wechatPackageName} | grep userId | cut -d '=' -f2)"
if [[ -z "${wechatVersionName}" || -z "${wechatVersionCode}" ]];
then
	echo "This script will exit soon due to the unknown WeChat version (11). "
	echo "由于无法获取微信版本，本脚本即将退出（11）。"
	exit 11
fi
if [[ $(expr ${wechatVersionCode} % 20) -ne 0 ]];
then
	wechatVersionName="Play ${wechatVersionName}"
fi
wechatVersionPlain="${wechatVersionName} (${wechatVersionCode})"
wechatVersionData="${wechatVersionName}%20(${wechatVersionCode})"
wxVersionName="$(dumpsys package ${wxPackageName} | grep versionName | cut -d '=' -f2)"
xVersionName="$(dumpsys package ${xPackageName} | grep versionName | cut -d '=' -f2)"
wxRepairToolVersionName="$(dumpsys package ${wxRepairToolPackageName} | grep versionName | cut -d '=' -f2)"
wxRepairToolVersionCode="$(dumpsys package ${wxRepairToolPackageName} | grep versionCode | cut -d '=' -f2 | cut -d ' ' -f1)"
if [[ "${wxVersionName}" == 2.* ]];
then
	if [[ "${xVersionName}" == "3.0" ]];
	then
		echo "Detecting conflicts, please use either WechatXposed or X (12). "
		echo "检测到冲突，请仅使用微 X 模块或 X 模块中的一个（12）。"
		echo ""
		exit 12
	else
		wxXVersionCoreData="wx6_${wxVersionName}"
		wxXVersionFkzWxData="wx6_v${wxVersionName}"
	fi
elif [[ "${xVersionName}" == "3.0" ]];
then
	wxXVersionCoreData="x7_${xVersionName}"
	wxXVersionFkzWxData="x7_v${xVersionName}"
else
	echo "This script will exit soon due to the unknown Wechatxposed version (13). "
	echo "由于无法获取微 X 模块的版本，本脚本即将退出（13）。"
	exit 13
fi
if [[ -z "${wxRepairToolVersionName}" || ${wxRepairToolVersionCode} -lt 2 ]];
then
	echo "The WX Repair Tool is not installed or the version is lower than 2. Please install the up-to-date WX Repair Tool (14) before using this script. "
	echo "WX Repair Tool 未安装或版本低于 2，请安装最新版 WX Repair Tool 后再使用脚本（14）。"
	echo ""
	exit 14
fi
echo "The current versions of the WeChat and the WechatXposed are ${wechatVersionPlain}, ${wxVersionName}, and ${wxRepairToolVersionName}, respectively. "
echo "当前微信、微 X 模块和 WX Repair Tool 的版本分别为 ${wechatVersionPlain}、${wxVersionName} 和 ${wxRepairToolVersionName}。"
echo ""

# Core Data (2X) #
coreDataDownloadLink="${repositoryContentLink}/${coreData}/${wechatVersionData}/${wxXVersionCoreData}.zip"
coreDataDownloadFilePath="${downloadFolderPath}/${wxXVersionCoreData}.zip"
coreDataDownloadFolderPath="${downloadFolderPath}/${wxXVersionCoreData}"
echo "Attempting to the fetch adapted core data \"${coreDataDownloadLink}\" to \"${downloadFolderPath}\", please wait. "
echo "正在尝试将适配的核心文件数据 \"${coreDataDownloadLink}\" 下载到 \"${downloadFolderPath}\"，请耐心等待。"
echo ""
curl -s "${coreDataDownloadLink}" > "${coreDataDownloadFilePath}"
returnCode=$?
if [[ ${returnCode} -eq ${EXIT_SUCCESS} && -e "${coreDataDownloadFilePath}" ]];
then
	if [[ "$(cat "${coreDataDownloadFilePath}")" == "Bad Request" ]];
	then
		echo "Failed to download the fetch adapted core data \"${coreDataDownloadLink}\" to \"${downloadFolderPath}\" due to a bad request (21). "
		echo "由于请求错误，无法将适配的核心文件数据 \"${coreDataDownloadLink}\" 下载到 \"${downloadFolderPath}\"（21）。"
		echo ""
		exit 21
	else
		echo "Successfully downloaded the fetch adapted core data \"${coreDataDownloadLink}\" to \"${downloadFolderPath}\". "
		echo "成功将适配的核心文件数据 \"${coreDataDownloadLink}\" 下载到 \"${downloadFolderPath}\"。"
		echo ""
	fi
elif [[ ${returnCode} -eq ${EXIT_FAILURE} ]];
then
	echo "Failed to download the fetch adapted core data \"${coreDataDownloadLink}\" to \"${downloadFolderPath}\" due to writing failures (22). "
	echo "由于写入失败，无法将适配的核心文件数据 \"${coreDataDownloadLink}\" 下载到 \"${downloadFolderPath}\"（22）。"
	echo ""
	exit 22
else
	echo "Failed to download the fetch adapted core data \"${coreDataDownloadLink}\" to \"${downloadFolderPath}\" due to network errors or no adapted data found. "
	echo "无法将适配的核心文件数据 \"${coreDataDownloadLink}\" 下载到 \"${downloadFolderPath}\"，可能是网络原因，也可能是没有找到适配文件。"
	echo ""
	echo "For network reasons, please try to use a VPN if you are in mainland China, or check the repository home page manually; for the lack of adapted files, please try to use the WeChat 8.0.48 (home version) and the WechatXposed 2.44 (23). "
	echo "对于网络原因，如果您在中国大陆，请尝试科学上网，或手动打开存储库的主页进行检查；对于没有适配文件，请尝试使用 8.0.48 版本的国内版微信和 2.44 版本的微 X 模块（23）。"
	exit 23
fi
echo "Attempting to decompress the downloaded core data file \"${coreDataDownloadFilePath}\" to \"${coreDataDownloadFolderPath}\", please wait. "
echo "正在尝试将下载好的核心文件数据文件 \"${coreDataDownloadFilePath}\" 解压到 \"${coreDataDownloadFolderPath}\"，请耐心等待。"
echo ""
rm -rf "${coreDataDownloadFolderPath}" && unzip "${coreDataDownloadFilePath}" -d "${coreDataDownloadFolderPath}"
if [[ $? -eq ${EXIT_SUCCESS} && -d "${coreDataDownloadFolderPath}" ]];
then
	echo "Successfully decompressed the downloaded core data file \"${coreDataDownloadFilePath}\" to \"${coreDataDownloadFolderPath}\". "
	echo "成功将下载好的核心文件数据文件 \"${coreDataDownloadFilePath}\" 解压到 \"${coreDataDownloadFolderPath}\"。"
	echo ""
else
	echo "Failed to decompress the downloaded core data file \"${coreDataDownloadFilePath}\" to \"${coreDataDownloadFolderPath}\". "
	echo "无法将下载好的核心文件数据文件 \"${coreDataDownloadFilePath}\" 解压到 \"${coreDataDownloadFolderPath}\"。"
	echo ""
	echo "Please try to import the core data by the WX Repair Tool or by yourselve (24). "
	echo "请尝试使用 WX Repair Tool 或手动导入核心文件数据（24）。"
	echo ""
	exit 24
fi
coreData0FolderInternalPath="${coreData0FolderPath}/${wxXVersionCoreData}"
if [[ -d "${coreData0FolderPath}" ]];
then
	echo "The parent directory of the internal core data folder \"${coreData0FolderPath}\" exists, copying soon. The whole folder will be replaced if the original data exist. "
	echo "内部核心文件数据文件夹的父目录 \"${coreData0FolderPath}\" 存在，即将开始复制。如原有数据存在，这将直接替换整个文件夹。"
	echo ""
	rm -rf "${coreData0FolderInternalPath}" && cp -r "${coreDataDownloadFolderPath}" "${coreData0FolderInternalPath}"
	if [[ $? -eq ${EXIT_SUCCESS} && -d "${coreData0FolderInternalPath}" ]];
	then
		echo "Successfully copied the decompressed core data folder \"${coreDataDownloadFolderPath}\" to \"${coreData0FolderInternalPath}\". "
		echo "成功将解压后的核心文件数据文件夹 \"${coreDataDownloadFolderPath}\" 复制到 \"${coreData0FolderInternalPath}\"。"
		echo ""
	else
		echo "Failed to copy the decompressed core data folder \"${coreDataDownloadFolderPath}\" to \"${coreData0FolderInternalPath}\". "
		echo "无法将解压后的核心文件数据文件夹 \"${coreDataDownloadFolderPath}\" 复制到 \"${coreData0FolderInternalPath}\"。"
		echo ""
		echo "Please try to import the core data by the WX Repair Tool or by yourselve (25). "
		echo "请尝试使用 WX Repair Tool 或手动导入核心文件数据（25）。"
		echo ""
		exit 25
	fi
	if chmod 755 "${coreData0FolderInternalPath}" && find "${coreData0FolderInternalPath}" -type d -exec chmod 755 {} \; && find "${coreData0FolderInternalPath}" -type f -exec chmod 644 {} \;
	then
		echo "Successfully granted 755 permissions to the internal core data folder \"${coreData0FolderInternalPath}\". Successfully granted 755 and 644 permissions to its subfolders and subfiles, respectively. "
		echo "成功向内部核心文件数据文件夹 \"${coreData0FolderInternalPath}\" 授予 755 权限，并对其子文件夹和子文件分别授予 755 和 644 权限。"
		echo ""
	else
		echo "Failed to grant 755 permissions to the internal core data folder \"${coreData0FolderInternalPath}\" or 755 and 644 permissions to its subfolders and subfiles, respectively (26). "
		echo "无法向内部核心文件数据文件夹 \"${coreData0FolderInternalPath}\" 授予 755 权限，或无法对其子文件夹和子文件分别授予 755 和 644 权限（26）。"
		echo ""
		exit 26
	fi
	if [[ -z "$(find "${coreData0FolderInternalPath}" -exec chown ${wechatUserId} {} \; -exec chgrp ${wechatUserId} {} \; 2>&1)" ]];
	then
		echo "Successfully changed the owner and the user group of \"${coreData0FolderInternalPath}\" and the files inside it to ${wechatUserId}. "
		echo "成功将文件夹 \"${coreData0FolderInternalPath}\" 及其子文件的所有者和用户组更改为 ${wechatUserId}。"
		echo ""
	else
		echo "Failed to change the owner and the user group of \"${coreData0FolderInternalPath}\" and the files inside it to ${wechatUserId} (27). "
		echo "无法将文件夹 \"${coreData0FolderInternalPath}\" 及其子文件的所有者和用户组更改为 ${wechatUserId}（27）。"
		echo ""
		exit 27
	fi
else
	echo "The parent directory of the internal core data folder \"${coreData0FolderPath}\" does not exist, skipping. "
	echo "内部核心文件数据文件夹的父目录 \"${coreData0FolderPath}\" 不存在，跳过复制。"
	echo ""
fi
coreData999FolderInternalPath="${coreData999FolderPath}/${wxXVersionCoreData}"
if [[ -d "${coreData999FolderPath}" ]];
then
	echo "The parent directory of the multi-user system internal core data folder \"${coreData999FolderPath}\" exists, copying soon. The whole folder will be replaced if the original data exist. "
	echo "双开内部核心文件数据文件夹的父目录 \"${coreData999FolderPath}\" 存在，即将开始复制。如原有数据存在，这将直接替换整个文件夹。"
	echo ""
	rm -rf "${coreData999FolderInternalPath}" && cp -r "${coreDataDownloadFolderPath}" "${coreData999FolderInternalPath}"
	if [[ $? -eq ${EXIT_SUCCESS} && -d "${coreData999FolderInternalPath}" ]];
	then
		echo "Successfully copied the decompressed core data folder \"${coreDataDownloadFolderPath}\" to \"${coreData999FolderInternalPath}\". "
		echo "成功将解压后的核心文件数据文件夹 \"${coreDataDownloadFolderPath}\" 复制到 \"${coreData999FolderInternalPath}\"。"
		echo ""
	else
		echo "Failed to copy the decompressed core data folder \"${coreDataDownloadFolderPath}\" to \"${coreData999FolderInternalPath}\". "
		echo "无法将解压后的核心文件数据文件夹 \"${coreDataDownloadFolderPath}\" 复制到 \"${coreData999FolderInternalPath}\"。"
		echo ""
		echo "Please try to import the core data by the WX Repair Tool or by yourselve (28). "
		echo "请尝试使用 WX Repair Tool 或手动导入核心文件数据（28）。"
		echo ""
		exit 28
	fi
	if chmod 755 "${coreData999FolderInternalPath}" && find "${coreData999FolderInternalPath}" -type d -exec chmod 755 {} \; && find "${coreData999FolderInternalPath}" -type f -exec chmod 644 {} \;
	then
		echo "Successfully granted 755 permissions to the multi-user system internal core data folder \"${coreData999FolderInternalPath}\". Successfully granted 755 and 644 permissions to its subfolders and subfiles, respectively. "
		echo "成功向双开内部核心文件数据文件夹 \"${coreData999FolderInternalPath}\" 授予 755 权限，并对其子文件夹和子文件分别授予 755 和 644 权限。"
		echo ""
	else
		echo "Failed to grant 755 permissions to the multi-user system internal core data folder \"${coreData999FolderInternalPath}\" or 755 and 644 permissionse to its subfolders and subfiles, respectively (29). "
		echo "无法向双开内部核心文件数据文件夹 \"${coreData999FolderInternalPath}\" 授予 755 权限，或无法对其子文件夹和子文件分别授予 755 和 644 权限（29）。"
		echo ""
		exit 29
	fi
	if [[ -z "$(find "${coreData999FolderInternalPath}" -exec chown ${wechatUserId} {} \; -exec chgrp ${wechatUserId} {} \; 2>&1)" ]];
	then
		echo "Successfully changed the owner and the user group of \"${coreData999FolderInternalPath}\" and the files inside it to ${wechatUserId}. "
		echo "成功将文件夹 \"${coreData999FolderInternalPath}\" 及其子文件的所有者和用户组更改为 ${wechatUserId}。"
		echo ""
	else
		echo "Failed to change the owner and the user group of \"${coreData999FolderInternalPath}\" and the files inside it to ${wechatUserId} (30). "
		echo "无法将文件夹 \"${coreData999FolderInternalPath}\" 及其子文件的所有者和用户组更改为 ${wechatUserId}（30）。"
		echo ""
		exit 30
	fi
else
	echo "The parent directory of the multi-user system internal core data folder \"${coreData999FolderPath}\" does not exist, skipping. "
	echo "双开内部核心文件数据文件夹的父目录 \"${coreData999FolderPath}\" 不存在，跳过复制。"
	echo ""
fi

# FKZ_WX_DATA (31--36) #
fkzWxDataFolderInternalPath="${fkzWxDataFolderPath}"
if [[ -d "${fkzWxDataFolderPath}" ]];
then
	echo "The parent directory of the internal FKZ_WX_DATA folder \"${fkzWxDataFolderPath}\" exists. "
	echo "内部 FKZ_WX_DATA 文件夹的父目录 \"${fkzWxDataFolderPath}\" 存在。"
	echo ""
	if [[ -f "${fkzWxDataFilePath}" ]];
	then
		echo "The internal FKZ_WX_DATA file \"${fkzWxDataFilePath}\" exists, skipping. Please remove it if you want a new one from the repository. "
		echo "内部 FKZ_WX_DATA 文件 \"${fkzWxDataFilePath}\" 存在，跳过复制。如有需要，请删除它，以获取仓库中的 FKZ_WX_DATA 文件。"
		echo ""
	else
		fkzWxDataDownloadLink="${repositoryContentLink}/${fkzWxData}/${wechatVersionData}/${wxXVersionFkzWxData}.zip"
		fkzWxDataDownloadFilePath="${downloadFolderPath}/${wxXVersionFkzWxData}.zip"
		fkzWxDataDownloadFolderPath="${downloadFolderPath}/${wxXVersionFkzWxData}"
		echo "Attempting to the fetch adapted FKZ_WX_DATA \"${fkzWxDataDownloadLink}\" to \"${downloadFolderPath}\", please wait. "
		echo "正在尝试将适配的 FKZ_WX_DATA \"${fkzWxDataDownloadLink}\" 下载到 \"${downloadFolderPath}\"，请耐心等待。"
		echo ""
		curl -s "${fkzWxDataDownloadLink}" > "${fkzWxDataDownloadFilePath}"
		returnCode=$?
		if [[ ${returnCode} -eq ${EXIT_SUCCESS} && -e "${fkzWxDataDownloadFilePath}" ]];
		then
			if [[ "$(cat "${fkzWxDataDownloadFilePath}")" == "Bad Request" ]];
			then
				echo "Failed to download the fetch adapted FKZ_WX_DATA \"${fkzWxDataDownloadLink}\" to \"${downloadFolderPath}\" due to a bad request (31). "
				echo "由于请求错误，无法将适配的 FKZ_WX_DATA \"${fkzWxDataDownloadLink}\" 下载到 \"${downloadFolderPath}\"（31）。"
				echo ""
				exit 31
			else
				echo "Successfully downloaded the fetch adapted FKZ_WX_DATA \"${fkzWxDataDownloadLink}\" to \"${downloadFolderPath}\". "
				echo "成功将适配的 FKZ_WX_DATA \"${fkzWxDataDownloadLink}\" 下载到 \"${downloadFolderPath}\"。"
				echo ""
			fi
		elif [[ ${returnCode} -eq ${EXIT_FAILURE} ]];
		then
			echo "Failed to download the fetch adapted FKZ_WX_DATA \"${fkzWxDataDownloadLink}\" to \"${downloadFolderPath}\" due to writing failures (32). "
			echo "由于写入失败，无法将适配的 FKZ_WX_DATA \"${fkzWxDataDownloadLink}\" 下载到 \"${downloadFolderPath}\"（32）。"
			echo ""
			exit 32
		else
			echo "Failed to download the fetch adapted FKZ_WX_DATA \"${fkzWxDataDownloadLink}\" to \"${downloadFolderPath}\" due to network errors or no adapted data found. "
			echo "无法将适配的 FKZ_WX_DATA \"${fkzWxDataDownloadLink}\" 下载到 \"${downloadFolderPath}\"，可能是网络原因，也可能是没有找到适配文件。"
			echo ""
			echo "For network reasons, please try to use a VPN if you are in mainland China, or check the repository home page manually; for the lack of adapted files, please try to use the WeChat 8.0.48 (home version) and the WechatXposed 2.44 (33). "
			echo "对于网络原因，如果您在中国大陆，请尝试科学上网，或手动打开存储库的主页进行检查；对于没有适配文件，请尝试使用 8.0.48 版本的国内版微信和 2.44 版本的微 X 模块（33）。"
			exit 33
		fi
		echo "Attempting to decompress the downloaded FKZ_WX_DATA file \"${fkzWxDataDownloadFilePath}\" to \"${fkzWxDataDownloadFolderPath}\", please wait. "
		echo "正在尝试将下载好的 FKZ_WX_DATA 文件 \"${fkzWxDataDownloadFilePath}\" 解压到 \"${fkzWxDataDownloadFolderPath}\"，请耐心等待。"
		echo ""
		rm -rf "${fkzWxDataDownloadFolderPath}" && unzip "${fkzWxDataDownloadFilePath}" -d "${fkzWxDataDownloadFolderPath}"
		if [[ $? -eq ${EXIT_SUCCESS} && -d "${fkzWxDataDownloadFolderPath}" ]];
		then
			echo "Successfully decompressed the downloaded FKZ_WX_DATA file \"${fkzWxDataDownloadFilePath}\" to \"${fkzWxDataDownloadFolderPath}\". "
			echo "成功将下载好的 FKZ_WX_DATA 文件 \"${fkzWxDataDownloadFilePath}\" 解压到 \"${fkzWxDataDownloadFolderPath}\"。"
			echo ""
		else
			echo "Failed to decompress the downloaded FKZ_WX_DATA file \"${fkzWxDataDownloadFilePath}\" to \"${fkzWxDataDownloadFolderPath}\". "
			echo "无法将下载好的 FKZ_WX_DATA 文件 \"${fkzWxDataDownloadFilePath}\" 解压到 \"${fkzWxDataDownloadFolderPath}\"。"
			echo ""
			echo "Please try to import the FKZ_WX_DATA by the WX Repair Tool or by yourselve (34). "
			echo "请尝试使用 WX Repair Tool 或手动导入 FKZ_WX_DATA（34）。"
			echo ""
			exit 34
		fi
		flag=${EXIT_SUCCESS}
		for filePath in $(find "${fkzWxDataDownloadFolderPath}" -type f)
		do
			fileName="$(basename "${filePath}")"
			targetFilePath="${fkzWxDataFolderInternalPath}/${fileName}"
			cp "${filePath}" "${targetFilePath}" && chmod 660 "${targetFilePath}" && chown ${wechatUserId} "${targetFilePath}" && chgrp ${wechatUserId} "${targetFilePath}"
			if [[ $? -ne ${EXIT_SUCCESS} || ! -f "${targetFilePath}" ]];
			then
				flag=${EXIT_FAILURE}
			fi
		done
		if [[ ${flag} -eq ${EXIT_SUCCESS} ]];
		then
			echo "Successfully copied the decompressed FKZ_WX_DATA \"${fkzWxDataDownloadFolderPath}\" to \"${fkzWxDataFolderInternalPath}\", with permissions 660, owner ${wechatUserId}, and user group ${wechatUserId}. "
			echo "成功将解压后的 FKZ_WX_DATA 文件夹中的内容 \"${fkzWxDataDownloadFolderPath}\" 复制到 \"${fkzWxDataFolderInternalPath}\"，并将权限、所有者、用户组分别设置为 660、${wechatUserId} 和 ${wechatUserId}。"
			echo ""
		else
			echo "Failed to copy the decompressed FKZ_WX_DATA \"${fkzWxDataDownloadFolderPath}\" to \"${fkzWxDataFolderInternalPath}\", with permissions 660, owner ${wechatUserId}, and user group ${wechatUserId}. "
			echo "无法将解压后的 FKZ_WX_DATA 文件夹中的内容 \"${fkzWxDataDownloadFolderPath}\" 复制到 \"${fkzWxDataFolderInternalPath}\"，并将权限、所有者、用户组分别设置为 660、${wechatUserId} 和 ${wechatUserId}。"
			echo ""
			echo "Please try to import the FKZ_WX_DATA by the WX Repair Tool or by yourselve (35). "
			echo "请尝试使用 WX Repair Tool 或手动导入 FKZ_WX_DATA（35）。"
			echo ""
			exit 35
		fi
	fi
else
	echo "The parent directory of the internal FKZ_WX_DATA folder \"${fkzWxDataFolderPath}\" does not exist, skipping. "
	echo "内部 FKZ_WX_DATA 文件夹的父目录 \"${fkzWxDataFolderPath}\" 不存在，跳过复制。"
	echo ""
fi

# Restart #
echo "Restarting WeChat, please wait. "
echo "重启微信中，请稍候。"
echo ""
am force-stop ${wechatPackageName}
sleep ${timeToSleep}
am start -n ${wechatPackageName}/${wechatUI}

# Exit #
echo "Successfully executed \"${scriptName}\" (${EXIT_SUCCESS}). "
echo "成功执行脚本 \"${scriptName}\"（${EXIT_SUCCESS}）。"
echo ""
exit ${EXIT_SUCCESS}
