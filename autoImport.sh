#!/system/bin/sh
readonly EXIT_SUCCESS=0
readonly EXIT_FAILURE=0
readonly scriptName="autoImport.sh"
readonly repositoryHomePage="https://github.com/TMLP-Team/WX-Configuration-Backups"
readonly repositoryContentLink="https://raw.githubusercontent.com/TMLP-Team/WX-Configuration-Backups/main"
readonly coreData="%E6%A0%B8%E5%BF%83%E6%96%87%E4%BB%B6"
readonly fkzWxData="FKZ_WX_DATA"
readonly coreData0FolderPath="/data/user/0/com.tencent.mm/files"
readonly coreData999FolderPath="/data/user/999/com.tencent.mm/files"
readonly fkzWxDataFolderPath="/data/data/com.tencent.mm/databases"
if [[ -n "${EXTERNAL_STORAGE}" ]];
then
	readonly downloadFolderPath="${EXTERNAL_STORAGE}/Download"
else
	readonly downloadFolderPath="/sdcard/Download"
fi

# Welcome (0X) #
echo "Welcome to the \`\`${scriptName}\`\`. Please check the script before you execute it. "
echo "欢迎使用 \`\`${scriptName}\`\`，请审计该脚本后再执行该脚本。"
echo ""
echo "Please kindly submit core and FKZ_WX_DATA configuration files to ${repositoryHomePage} if you have. Thank you. "
echo "如您拥有核心文件或 FKZ_WX_DATA 数据的存档，请向 ${repositoryHomePage} 提交拉取请求（Pull Request，简称 PR）。感谢！"
echo ""
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

# Versions (1X) #
wechatVersionName="$(dumpsys package com.tencent.mm | grep versionName | cut -d '=' -f2)"
wechatVersionCode="$(dumpsys package com.tencent.mm | grep versionCode | cut -d '=' -f2 | cut -d ' ' -f1)"
if [[ -z "${wechatVersionName}" || -z "${wechatVersionCode}" ]];
then
	echo "This script will exit soon due to the unknown WeChat version (11). "
	echo "由于无法获取微信版本，本脚本即将退出（11）。"
	exit 11
fi
wechatVersionPlain="${wechatVersionName} (${wechatVersionCode})"
wechatVersionData="${wechatVersionName}%20(${wechatVersionCode})"
wxVersionName="$(dumpsys package com.fkzhang.wechatxposed | grep versionName | cut -d '=' -f2)"
xVersionName="$(dumpsys package cn.android.x | grep versionName | cut -d '=' -f2)"
if [[ "${wxVersionName}" == 2.* ]];
then
	wxXVersionCoreData="wx6_${wxVersionName}"
	wxXVersionFkzWxData="x7_${wxVersionName}"
elif [[ "${xVersionName}" == "3.0" ]];
then
	wxXVersionCoreData="x7_v${xVersionName}"
	wxXVersionFkzWxData="x7_v${xVersionName}"
else
	echo "This script will exit soon due to the unknown Wechatxposed version (12). "
	echo "由于无法获取微 X 模块的版本，本脚本即将退出（12）。"
	exit 12
fi
echo "The current versions of the WeChat and the Wechatxposed are ${wechatVersionPlain} and ${wxVersionName}, respectively. "
echo "当前微信和微 X 模块的版本分别为 ${wechatVersionPlain} 和 ${wxVersionName}。"
echo ""

# Core Data (2X) #
coreDataDownloadLink="${repositoryContentLink}/${coreData}/${wechatVersionData}/${wxXVersionCoreData}.zip"
coreDataDownloadFilePath="${downloadFolderPath}/${wxXVersionCoreData}.zip"
coreDataDownloadFolderPath="${downloadFolderPath}/${wxXVersionCoreData}"
echo "Attempting to the fetch adapted core data \"${coreDataDownloadLink}\" to \"${downloadFolderPath}\". "
echo "正在尝试将适配的核心文件数据 \"${coreDataDownloadLink}\" 下载到 \"${downloadFolderPath}\"。"
echo ""
curl -s "${coreDataDownloadLink}" > "${coreDataDownloadFilePath}"
exitCode=$?
if [[ ${exitCode} -eq ${EXIT_SUCCESS} && -e "${coreDataDownloadFilePath}" ]];
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
elif [[ ${exitCode} -eq ${EXIT_FAILURE} ]];
then
	echo "Failed to download the fetch adapted core data \"${coreDataDownloadLink}\" to \"${downloadFolderPath}\" due to writing failures (22). "
	echo "由于写入失败，无法将适配的核心文件数据 \"${coreDataDownloadLink}\" 下载到 \"${downloadFolderPath}\"（22）。"
	echo ""
	exit 22
else
	echo "Failed to download the fetch adapted core data \"${coreDataDownloadLink}\" to \"${downloadFolderPath}\" due to network errors or no adapted data found. "
	echo "无法将适配的核心文件数据 \"${coreDataDownloadLink}\" 下载到 \"${downloadFolderPath}\"，可能是网络原因，也可能是没有找到适配文件。"
	echo ""
	echo "Please try to use a VPN if you are in mainland China, or check the repository home page manually (23). "
	echo "如果您在中国大陆，请尝试科学上网，或手动打开存储库的主页进行检查（23）。"
	exit 23
fi
echo "Attempting to decompress the downloaded core data file \"${coreDataDownloadFilePath}\" to \"${coreDataDownloadFolderPath}\". "
echo "正在尝试将下载好的核心文件数据文件 \"${coreDataDownloadFilePath}\" 解压到 \"${coreDataDownloadFolderPath}\"。"
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
	echo "Please try to import the data by the WX Repair Tool or by yourselve (23). "
	echo "请尝试使用 WX Repair Tool 或手动导入核心文件数据（23）。"
	echo ""
	exit 23
fi
coreData0FolderInternalPath="${coreData0FolderPath}/${wxXVersionCoreData}"
if [[ -d "${coreData0FolderPath}" ]];
then
	echo "The parent directory of the internal core data folder \"${coreData0FolderPath}\" exists, copying soon. The whole folder will be replaced if the original data exist. "
	echo "内部核心文件数据文件夹的父目录 \"${coreData0FolderPath}\" 存在，即将开始复制。如原有数据存在，这将直接替换整个文件夹。"
	echo ""
	rm -rf "${coreData0FolderInternalPath}" && cp "${coreDataDownloadFolderPath}" "${coreData0FolderInternalPath}"
	if [[ $? -eq ${EXIT_SUCCESS} && -d "${coreData0FolderInternalPath}" ]];
	then
		echo "Successfully copied the decompressed core data folder \"${coreDataDownloadFolderPath}\" to \"${coreData0FolderInternalPath}\". "
		echo "成功将解压后的核心文件数据文件夹 \"${coreDataDownloadFolderPath}\" 复制到 \"${coreData0FolderInternalPath}\"。"
		echo ""
	else
		echo "Failed to copy the decompressed core data folder \"${coreDataDownloadFolderPath}\" to \"${coreData0FolderInternalPath}\". "
		echo "无法将解压后的核心文件数据文件夹 \"${coreDataDownloadFolderPath}\" 复制到 \"${coreData0FolderInternalPath}\"。"
		echo ""
		echo "Please try to import the data by the WX Repair Tool or by yourselve (24). "
		echo "请尝试使用 WX Repair Tool 或手动导入核心文件数据（24）。"
		echo ""
		exit 24
	fi
	if chmod 755 "${coreData0FolderInternalPath}" && chmod 644 "${coreData0FolderInternalPath}/*";
	then
		echo "Successfully granted 755 and 644 permissions to the internal core data folder \"${coreData0FolderInternalPath}\" and the files inside it, respectively. "
		echo "成功向内部核心文件数据文件夹 \"${coreData0FolderInternalPath}\" 及其中的文件分别授予 755 和 644 权限。"
		echo ""
	else
		echo "Failed to grant 755 and 644 permissions to the internal core data folder \"${coreData0FolderInternalPath}\" and the files inside it, respectively (25). "
		echo "无法向内部核心文件数据文件夹 \"${coreData0FolderInternalPath}\" 及其中的文件分别授予 755 和 644 权限（25）。"
		echo ""
		exit 25
	fi
else
	echo "The parent directory of the internal core data folder \"${coreData0FolderPath}\" does not exist, skipping. "
	echo "内部核心文件数据文件夹的父目录 \"${coreData0FolderPath}\" 不存在，跳过复制。"
	echo ""
fi

# FKZ_WX_DATA (3X) #
fkzWxDataDownloadLink="${repositoryContentLink}/${fkzWxData}/${wechatVersionData}/${wxXVersionFkzWxData}.zip"
fkzWxDataDownloadFilePath="${downloadFolderPath}/${wxXVersionFkzWxData}.zip"
fkzWxDataDownloadFolderPath="${downloadFolderPath}/${wxXVersionFkzWxData}"
echo "Attempting to the fetch adapted FKZ_WX_DATA \"${fkzWxDataDownloadLink}\" to \"${downloadFolderPath}\". "
echo "正在尝试将适配的核心文件数据 \"${fkzWxDataDownloadLink}\" 下载到 \"${downloadFolderPath}\"。"
echo ""
curl -s "${fkzWxDataDownloadLink}" > "${fkzWxDataDownloadFilePath}"
exitCode=$?
if [[ ${exitCode} -eq ${EXIT_SUCCESS} && -e "${fkzWxDataDownloadFilePath}" ]];
then
	if [[ "$(cat "${fkzWxDataDownloadFilePath}")" == "Bad Request" ]];
	then
		echo "Failed to download the fetch adapted FKZ_WX_DATA \"${fkzWxDataDownloadLink}\" to \"${downloadFolderPath}\" due to a bad request (31). "
		echo "由于请求错误，无法将适配的核心文件数据 \"${fkzWxDataDownloadLink}\" 下载到 \"${downloadFolderPath}\"（31）。"
		echo ""
		exit 31
	else
		echo "Successfully downloaded the fetch adapted FKZ_WX_DATA \"${fkzWxDataDownloadLink}\" to \"${downloadFolderPath}\". "
		echo "成功将适配的核心文件数据 \"${fkzWxDataDownloadLink}\" 下载到 \"${downloadFolderPath}\"。"
		echo ""
	fi
elif [[ ${exitCode} -eq ${EXIT_FAILURE} ]];
then
	echo "Failed to download the fetch adapted FKZ_WX_DATA \"${fkzWxDataDownloadLink}\" to \"${downloadFolderPath}\" due to writing failures (32). "
	echo "由于写入失败，无法将适配的核心文件数据 \"${fkzWxDataDownloadLink}\" 下载到 \"${downloadFolderPath}\"（32）。"
	echo ""
	exit 32
else
	echo "Failed to download the fetch adapted FKZ_WX_DATA \"${fkzWxDataDownloadLink}\" to \"${downloadFolderPath}\" due to network errors or no adapted data found. "
	echo "无法将适配的核心文件数据 \"${fkzWxDataDownloadLink}\" 下载到 \"${downloadFolderPath}\"，可能是网络原因，也可能是没有找到适配文件。"
	echo ""
	echo "Please try to use a VPN if you are in mainland China, or check the repository home page manually (33). "
	echo "如果您在中国大陆，请尝试科学上网，或手动打开存储库的主页进行检查（33）。"
	exit 33
fi

# Exit #
exit ${EXIT_SUCCESS}
