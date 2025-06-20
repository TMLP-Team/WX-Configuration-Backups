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
readonly fkzWxData999FolderPath="/data/user/999/${wechatPackageName}/databases"
readonly fkzWxDataFileName="FKZ_WX_DATA"
readonly fkzWxDataFilePath="${fkzWxDataFolderPath}/${fkzWxDataFileName}"
readonly fkzWxData999FilePath="${fkzWxDataFolderPath}/${fkzWxDataFileName}"
if [[ -n "${EXTERNAL_STORAGE}" ]];
then
	readonly deviceDownloadFolderPath="${EXTERNAL_STORAGE}/Download"
else
	readonly deviceDownloadFolderPath="/sdcard/Download"
fi
readonly wxConfigurationFolderName=".wxConfigurations"
readonly downloadFolderPath="${deviceDownloadFolderPath}/${wxConfigurationFolderName}"
readonly timeToSleep=3

# Welcome (1--3) #
printf "\n\033[1;34m===== Welcome to %s =====\033[0m\n" "${scriptName}"
printf "\033[1;34m===== 欢迎使用 %s =====\033[0m\n\n" "${scriptName}"
printf "\033[1;33mPlease review the script before execution.\033[0m\n"
printf "\033[1;33m请在执行前仔细审计脚本内容。\033[0m\n\n"
printf "\033[1;32mSubmit core and FKZ_WX_DATA files to:\033[0m\n  %s\n" "${repositoryHomePage}"
printf "\033[1;32m如有核心文件或 FKZ_WX_DATA，请提交 PR 至：\033[0m\n  %s\n\n" "${repositoryHomePage}"
printf "\033[1;36mBy continuing, you agree to the terms of use and take responsibility for any risks.\033[0m\n"
printf "\033[1;36m继续运行即表示您同意使用条款并承担相关风险。\033[0m\n\n"
printf "\033[1;33mEnter 'y' to agree and continue, or any other key to exit. \033[0m\n"
printf "\033[1;33m输入 'y' 同意并继续，或输入其它按键退出。\033[0m\n"
printf ">>> "
read -r user_input
if [[ "${user_input}" != "y" && "${user_input}" != "Y" ]];
then
    printf "\n\033[1;31mAgreement not confirmed. Exiting script.\033[0m\n"
    printf "\033[1;31m未同意条款，脚本退出。\033[0m\n"
    printf "\033[1;34m====================\033[0m\n\n"
    exit 4
fi
printf "\n\033[1;32mAgreement confirmed. Proceeding with script execution.\033[0m\n"
printf "\033[1;32m已确认同意，继续执行脚本。\033[0m\n"
printf "\033[1;34m====================\033[0m\n\n"

if [[ $(id -u) -eq 0 ]];
then
	mkdir -p "${downloadFolderPath}"
	if [[ $? -eq ${EXIT_SUCCESS} && -d "${downloadFolderPath}" ]];
	then
		printf "\033[1;32mThe local folder for download \"%s\" is ready.\033[0m\n" "${downloadFolderPath}"
		printf "\033[1;32m本地用于下载的文件夹 \"%s\" 已就绪。\033[0m\n\n" "${downloadFolderPath}"
	else
		printf "\033[1;31mFailed to handle the local folder for download \"%s\" (2).\033[0m\n" "${downloadFolderPath}"
		printf "\033[1;31m由于无法就绪本地用于下载的文件夹 \"%s\"，脚本退出（2）。\033[0m\n\n" "${downloadFolderPath}"
		exit 2
	fi
else
	printf "\033[1;31mScript not executed with root permissions. Please run as root.\033[0m\n"
	printf "\033[1;31mIf your device is not rooted, visit %s to find configuration data for manual import (3).\033[0m\n" "${repositoryHomePage}"
	printf "\033[1;31m脚本未以 root 权限运行，请使用 root 身份执行。\033[0m\n"
	printf "\033[1;31m如设备未 root，请访问 %s 查找配置数据并手动导入（3）。\033[0m\n\n" "${repositoryHomePage}"
	exit 3
fi

# Versions (11--15) #
printf "\033[1;34m----- Checking Versions -----\033[0m\n"
printf "\033[1;34m----- 检查版本信息 -----\033[0m\n\n"
wechatVersionName="$(dumpsys package ${wechatPackageName} | grep "versionName" | cut -d '=' -f2 | cut -d ' ' -f1)"
wechatVersionCode="$(dumpsys package ${wechatPackageName} | grep "versionCode" | cut -d '=' -f2 | cut -d ' ' -f1)"
if [[ -z "${wechatVersionName}" || -z "${wechatVersionCode}" ]];
then
	printf "\033[1;31mUnknown WeChat version. Exiting script (11).\033[0m\n"
	printf "\033[1;31m由于无法获取微信版本，脚本退出（11）。\033[0m\n\n"
	exit 11
fi
wechatUserId="$(ls -ld /data/user/0/${wechatPackageName}/files | awk '{print $3}' | grep -oE '[0-9]+$' | while read num; do expr 10000 + "$num"; done)"
if ! echo "${wechatUserId}" | grep -qE '^[0-9]+$';
then
    printf "\033[1;31mCould not fetch the user ID of WeChat. Exiting script (12).\033[0m\n"
    printf "\033[1;31m由于无法获取微信的用户 ID，脚本退出（12）。\033[0m\n\n"
    exit 12
fi
if [[ $(expr ${wechatVersionCode} % 20) -ne 0 ]];
then
	wechatVersionName="Play ${wechatVersionName}"
fi
wechatVersionPlain="${wechatVersionName} (${wechatVersionCode})"
wechatVersionData="$(echo "${wechatVersionPlain}" | sed 's/ /%20/g')"
wxVersionName="$(dumpsys package ${wxPackageName} | grep "versionName" | cut -d '=' -f2 | cut -d ' ' -f1)"
xVersionName="$(dumpsys package ${xPackageName} | grep "versionName" | cut -d '=' -f2 | cut -d ' ' -f1)"
if [[ "${wxVersionName}" == 2.* ]];
then
	if [[ "${xVersionName}" == "3.0" ]];
	then
		printf "\033[1;31mPlugin conflicts detected. Please use either WechatXposed or X (13).\033[0m\n"
		printf "\033[1;31m检测到插件冲突，请仅使用微 X 模块或 X 模块中的一个（13）。\033[0m\n\n"
		exit 13
	else
		wxXVersionName="${wxVersionName}"
		wxXVersionCoreData="wx6_${wxVersionName}"
		wxXVersionFkzWxData="wx6_v${wxVersionName}"
	fi
elif [[ "${xVersionName}" == "3.0" ]];
then
	wxXVersionName="${xVersionName}"
	wxXVersionCoreData="x7_${xVersionName}"
	wxXVersionFkzWxData="x7_v${xVersionName}"
else
	printf "\033[1;31mUnknown WechatXposed version. Exiting script (14).\033[0m\n"
	printf "\033[1;31m由于无法获取微 X 模块的版本，脚本退出（14）。\033[0m\n\n"
	exit 14
fi
wxRepairToolVersionName="$(dumpsys package ${wxRepairToolPackageName} | grep "versionName" | cut -d '=' -f2 | cut -d ' ' -f1)"
wxRepairToolVersionCode="$(dumpsys package ${wxRepairToolPackageName} | grep "versionCode" | cut -d '=' -f2 | cut -d ' ' -f1)"
if [[ -z "${wxRepairToolVersionName}" || ${wxRepairToolVersionCode} -lt 2 ]];
then
	printf "\033[1;31mWX Repair Tool not installed or version < 2. Please install the latest version (15).\033[0m\n"
	printf "\033[1;31mWX Repair Tool 未安装或版本低于 2，请安装最新版本（15）。\033[0m\n\n"
	exit 15
fi
printf "\033[1;32mCurrent versions:\033[0m\n"
printf "  WeChat: %s\n" "${wechatVersionPlain}"
printf "  WechatXposed: %s\n" "${wxXVersionName}"
printf "  WX Repair Tool: %s\n" "${wxRepairToolVersionName}"
printf "\033[1;32m当前版本信息：\033[0m\n"
printf "  微信：%s\n" "${wechatVersionPlain}"
printf "  微 X 模块：%s\n" "${wxXVersionName}"
printf "  WX Repair Tool：%s\n\n" "${wxRepairToolVersionName}"

# Core Data (2X) #
printf "\033[1;34m----- Processing Core Data -----\033[0m\n"
printf "\033[1;34m----- 处理核心文件数据 -----\033[0m\n\n"
coreDataDownloadLink="${repositoryContentLink}/${coreData}/${wechatVersionData}/${wxXVersionCoreData}.zip"
coreDataDownloadFilePath="${downloadFolderPath}/${wxXVersionCoreData}.zip"
coreDataDownloadFolderPath="${downloadFolderPath}/${wxXVersionCoreData}"
printf "\033[1;33mFetching core data from \"%s\" to \"%s\", please wait.\033[0m\n" "${coreDataDownloadLink}" "${downloadFolderPath}"
printf "\033[1;33m正在下载核心文件数据 \"%s\" 到 \"%s\"，请稍候。\033[0m\n\n" "${coreDataDownloadLink}" "${downloadFolderPath}"
if wget 2>&1 | grep -q -F "inaccessible or not found";
then
	curl -s "${coreDataDownloadLink}" > "${coreDataDownloadFilePath}"
	returnCode=$?
else
	wget -c "${coreDataDownloadLink}" -O "${coreDataDownloadFilePath}"
	returnCode=$?
fi
if [[ ${returnCode} -eq ${EXIT_SUCCESS} && -e "${coreDataDownloadFilePath}" ]];
then
	if zipinfo "${coreDataDownloadFilePath}" > /dev/null 2>&1;
	then
		printf "\033[1;32mSuccessfully tested core data \"%s\".\033[0m\n" "${coreDataDownloadFilePath}"
		printf "\033[1;32m核心文件数据 \"%s\" 测试通过。\033[0m\n\n" "${coreDataDownloadFilePath}"
	else
		printf "\033[1;31mFailed to test core data \"%s\" (21).\033[0m\n" "${coreDataDownloadFilePath}"
		printf "\033[1;31m核心文件数据 \"%s\" 测试失败（21）。\033[0m\n\n" "${coreDataDownloadFilePath}"
		exit 21
	fi
elif [[ ${returnCode} -eq ${EXIT_FAILURE} ]];
then
	printf "\033[1;31mFailed to download core data \"%s\" due to write errors (22).\033[0m\n" "${coreDataDownloadLink}"
	printf "\033[1;31m由于写入错误，下载核心文件数据 \"%s\" 失败（22）。\033[0m\n\n" "${coreDataDownloadLink}"
	exit 22
else
	printf "\033[1;31mFailed to download core data \"%s\" due to network errors or no data found.\033[0m\n" "${coreDataDownloadLink}"
	printf "\033[1;31m无法下载核心文件数据 \"%s\"，可能是网络问题或无适配数据。\033[0m\n"
	printf "\033[1;33mFor network issues, try a VPN if in mainland China, or check %s.\033[0m\n" "${repositoryHomePage}"
	printf "\033[1;33mFor missing data, try WeChat 8.0.48 (home) and WechatXposed 2.44 (23).\033[0m\n"
	printf "\033[1;33m网络问题请尝试科学上网或访问 %s；无适配数据请使用微信 8.0.48 和微 X 模块 2.44（23）。\033[0m\n\n" "${repositoryHomePage}"
	exit 23
fi
printf "\033[1;33mDecompressing core data \"%s\" to \"%s\", please wait.\033[0m\n" "${coreDataDownloadFilePath}" "${coreDataDownloadFolderPath}"
printf "\033[1;33m正在解压核心文件数据 \"%s\" 到 \"%s\"，请稍候。\033[0m\n\n" "${coreDataDownloadFilePath}" "${coreDataDownloadFolderPath}"
rm -rf "${coreDataDownloadFolderPath}" && unzip -o "${coreDataDownloadFilePath}" -d "${coreDataDownloadFolderPath}" > /dev/null 2>&1
if [[ $? -eq ${EXIT_SUCCESS} && -d "${coreDataDownloadFolderPath}" ]];
then
	printf "\033[1;32mSuccessfully decompressed core data to \"%s\".\033[0m\n" "${coreDataDownloadFolderPath}"
	printf "\033[1;32m成功解压核心文件数据到 \"%s\"。\033[0m\n\n" "${coreDataDownloadFolderPath}"
else
	printf "\033[1;31mFailed to decompress core data to \"%s\" (24).\033[0m\n" "${coreDataDownloadFolderPath}"
	printf "\033[1;31m无法解压核心文件数据到 \"%s\"（24）。\033[0m\n"
	printf "\033[1;33mPlease import core data using WX Repair Tool or manually.\033[0m\n"
	printf "\033[1;33m请使用 WX Repair Tool 或手动导入核心文件数据（24）。\033[0m\n\n"
	exit 24
fi
coreData0FolderInternalPath="${coreData0FolderPath}/${wxXVersionCoreData}"
if [[ -d "${coreData0FolderPath}" ]];
then
	printf "\033[1;33mParent directory \"%s\" exists, copying core data.\033[0m\n" "${coreData0FolderPath}"
	printf "\033[1;33m核心文件父目录 \"%s\" 存在，即将复制。\033[0m\n"
	printf "\033[1;33mExisting data will be replaced.\033[0m\n"
	printf "\033[1;33m原有数据将被替换。\033[0m\n\n"
	rm -rf "${coreData0FolderInternalPath}" && cp -r "${coreDataDownloadFolderPath}" "${coreData0FolderInternalPath}"
	if [[ $? -eq ${EXIT_SUCCESS} && -d "${coreData0FolderInternalPath}" ]];
	then
		printf "\033[1;32mSuccessfully copied core data to \"%s\".\033[0m\n" "${coreData0FolderInternalPath}"
		printf "\033[1;32m成功复制核心文件数据到 \"%s\"。\033[0m\n\n" "${coreData0FolderInternalPath}"
	else
		printf "\033[1;31mFailed to copy core data to \"%s\" (25).\033[0m\n" "${coreData0FolderInternalPath}"
		printf "\033[1;31m无法复制核心文件数据到 \"%s\"（25）。\033[0m\n"
		printf "\033[1;33mPlease import core data using WX Repair Tool or manually.\033[0m\n"
		printf "\033[1;33m请使用 WX Repair Tool 或手动导入核心文件数据（25）。\033[0m\n\n"
		exit 25
	fi
	if [[ -z "$(find "${coreData0FolderInternalPath}" -type d -exec chmod 755 {} \; 2>&1)" && -z "$(find "${coreData0FolderInternalPath}" -type f -exec chmod 644 {} \; 2>&1)" ]];
	then
		printf "\033[1;32mSuccessfully set permissions (755 for folders, 644 for files) on \"%s\".\033[0m\n" "${coreData0FolderInternalPath}"
		printf "\033[1;32m成功设置 \"%s\" 权限（文件夹 755，文件 644）。\033[0m\n\n" "${coreData0FolderInternalPath}"
	else
		printf "\033[1;31mFailed to set permissions on \"%s\" (26).\033[0m\n" "${coreData0FolderInternalPath}"
		printf "\033[1;31m无法设置 \"%s\" 权限（26）。\033[0m\n\n" "${coreData0FolderInternalPath}"
		exit 26
	fi
	if [[ -z "$(find "${coreData0FolderInternalPath}" -exec chown ${wechatUserId} {} \; -exec chgrp ${wechatUserId} {} \; 2>&1)" ]];
	then
		printf "\033[1;32mSuccessfully set owner and group of \"%s\" to UID %s.\033[0m\n" "${coreData0FolderInternalPath}" "${wechatUserId}"
		printf "\033[1;32m成功将 \"%s\" 的所有者和用户组设置为 UID %s。\033[0m\n\n" "${coreData0FolderInternalPath}" "${wechatUserId}"
	else
		printf "\033[1;31mFailed to set owner and group of \"%s\" to UID %s (27).\033[0m\n" "${coreData0FolderInternalPath}" "${wechatUserId}"
		printf "\033[1;31m无法将 \"%s\" 的所有者和用户组设置为 UID %s（27）。\033[0m\n\n" "${coreData0FolderInternalPath}" "${wechatUserId}"
		exit 27
	fi
else
	printf "\033[1;33mParent directory \"%s\" does not exist, skipping.\033[0m\n" "${coreData0FolderPath}"
	printf "\033[1;33m核心文件父目录 \"%s\" 不存在，跳过。\033[0m\n\n" "${coreData0FolderPath}"
fi
coreData999FolderInternalPath="${coreData999FolderPath}/${wxXVersionCoreData}"
if [[ -d "${coreData999FolderPath}" ]];
then
	printf "\033[1;33mMulti-user parent directory \"%s\" exists, copying core data.\033[0m\n" "${coreData999FolderPath}"
	printf "\033[1;33m双开核心文件父目录 \"%s\" 存在，即将复制。\033[0m\n"
	printf "\033[1;33mExisting data will be replaced.\033[0m\n"
	printf "\033[1;33m原有数据将被替换。\033[0m\n\n"
	rm -rf "${coreData999FolderInternalPath}" && cp -r "${coreDataDownloadFolderPath}" "${coreData999FolderInternalPath}"
	if [[ $? -eq ${EXIT_SUCCESS} && -d "${coreData999FolderInternalPath}" ]];
	then
		printf "\033[1;32mSuccessfully copied core data to \"%s\".\033[0m\n" "${coreData999FolderInternalPath}"
		printf "\033[1;32m成功复制核心文件数据到 \"%s\"。\033[0m\n\n" "${coreData999FolderInternalPath}"
	else
		printf "\033[1;31mFailed to copy core data to \"%s\" (28).\033[0m\n" "${coreData999FolderInternalPath}"
		printf "\033[1;31m无法复制核心文件数据到 \"%s\"（28）。\033[0m\n"
		printf "\033[1;33mPlease import core data using WX Repair Tool or manually.\033[0m\n"
		printf "\033[1;33m请使用 WX Repair Tool 或手动导入核心文件数据（28）。\033[0m\n\n"
		exit 28
	fi
	if [[ -z "$(find "${coreData999FolderInternalPath}" -type d -exec chmod 755 {} \; 2>&1)" && -z "$(find "${coreData999FolderInternalPath}" -type f -exec chmod 644 {} \; 2>&1)" ]];
	then
		printf "\033[1;32mSuccessfully set permissions (755 for folders, 644 for files) on \"%s\".\033[0m\n" "${coreData999FolderInternalPath}"
		printf "\033[1;32m成功设置 \"%s\" 权限（文件夹 755，文件 644）。\033[0m\n\n" "${coreData999FolderInternalPath}"
	else
		printf "\033[1;31mFailed to set permissions on \"%s\" (29).\033[0m\n" "${coreData999FolderInternalPath}"
		printf "\033[1;31m无法设置 \"%s\" 权限（29）。\033[0m\n\n" "${coreData999FolderInternalPath}"
		exit 29
	fi
	if [[ -z "$(find "${coreData999FolderInternalPath}" -exec chown ${wechatUserId} {} \; -exec chgrp ${wechatUserId} {} \; 2>&1)" ]];
	then
		printf "\033[1;32mSuccessfully set owner and group of \"%s\" to UID %s.\033[0m\n" "${coreData999FolderInternalPath}" "${wechatUserId}"
		printf "\033[1;32m成功将 \"%s\" 的所有者和用户组设置为 UID %s。\033[0m\n\n" "${coreData999FolderInternalPath}" "${wechatUserId}"
	else
		printf "\033[1;31mFailed to set owner and group of \"%s\" to UID %s (30).\033[0m\n" "${coreData999FolderInternalPath}" "${wechatUserId}"
		printf "\033[1;31m无法将 \"%s\" 的所有者和用户组设置为 UID %s（30）。\033[0m\n\n" "${coreData999FolderInternalPath}" "${wechatUserId}"
		exit 30
	fi
else
	printf "\033[1;33mMulti-user parent directory \"%s\" does not exist, skipping.\033[0m\n" "${coreData999FolderPath}"
	printf "\033[1;33m双开核心文件父目录 \"%s\" 不存在，跳过。\033[0m\n\n" "${coreData999FolderPath}"
fi

# FKZ_WX_DATA (31--37) #
printf "\033[1;34m----- Processing FKZ_WX_DATA -----\033[0m\n"
printf "\033[1;34m----- 处理 FKZ_WX_DATA -----\033[0m\n\n"
mkdir -p "${fkzWxDataFolderPath}" && chmod 755 "${fkzWxDataFolderPath}" && chown ${wechatUserId} "${fkzWxDataFolderPath}" && chgrp ${wechatUserId} "${fkzWxDataFolderPath}"
if [[ $? -eq ${EXIT_SUCCESS} && -d "${fkzWxDataFolderPath}" ]];
then
	if [[ -f "${fkzWxDataFilePath}" ]];
	then
		printf "\033[1;33mFKZ_WX_DATA file \"%s\" exists, skipping.\033[0m\n" "${fkzWxDataFilePath}"
		printf "\033[1;33mFKZ_WX_DATA 文件 \"%s\" 已存在，跳过。\033[0m\n"
		printf "\033[1;33mRemove it manually to fetch a new one from the repository.\033[0m\n"
		printf "\033[1;33m如需从仓库获取新文件，请手动删除。\033[0m\n\n"
	else
		fkzWxDataDownloadLink="${repositoryContentLink}/${fkzWxData}/${wechatVersionData}/${wxXVersionFkzWxData}.zip"
		fkzWxDataDownloadFilePath="${downloadFolderPath}/${wxXVersionFkzWxData}.zip"
		fkzWxDataDownloadFolderPath="${downloadFolderPath}/${wxXVersionFkzWxData}"
		printf "\033[1;33mFetching FKZ_WX_DATA from \"%s\" to \"%s\", please wait.\033[0m\n" "${fkzWxDataDownloadLink}" "${downloadFolderPath}"
		printf "\033[1;33m正在下载 FKZ_WX_DATA \"%s\" 到 \"%s\"，请稍候。\033[0m\n\n" "${fkzWxDataDownloadLink}" "${downloadFolderPath}"
		if wget 2>&1 | grep -q -F "inaccessible or not found";
		then
			curl -s "${fkzWxDataDownloadLink}" > "${fkzWxDataDownloadFilePath}"
			returnCode=$?
		else
			wget -c "${fkzWxDataDownloadLink}" -O "${fkzWxDataDownloadFilePath}"
			returnCode=$?
		fi
		if [[ ${returnCode} -eq ${EXIT_SUCCESS} && -e "${fkzWxDataDownloadFilePath}" ]];
		then
			if zipinfo "${fkzWxDataDownloadFilePath}" > /dev/null 2>&1;
			then
				printf "\033[1;32mSuccessfully tested FKZ_WX_DATA \"%s\".\033[0m\n" "${fkzWxDataDownloadFilePath}"
				printf "\033[1;32mFKZ_WX_DATA \"%s\" 测试通过。\033[0m\n\n" "${fkzWxDataDownloadFilePath}"
			else
				printf "\033[1;31mFailed to test FKZ_WX_DATA \"%s\" (31).\033[0m\n" "${fkzWxDataDownloadFilePath}"
				printf "\033[1;31mFKZ_WX_DATA \"%s\" 测试失败（31）。\033[0m\n\n" "${fkzWxDataDownloadFilePath}"
				exit 31
			fi
		elif [[ ${returnCode} -eq ${EXIT_FAILURE} ]];
		then
			printf "\033[1;31mFailed to download FKZ_WX_DATA \"%s\" due to write errors (32).\033[0m\n" "${fkzWxDataDownloadLink}"
			printf "\033[1;31m由于写入错误，下载 FKZ_WX_DATA \"%s\" 失败（32）。\033[0m\n\n" "${fkzWxDataDownloadLink}"
			exit 32
		else
			printf "\033[1;31mFailed to download FKZ_WX_DATA \"%s\" due to network errors or no data found.\033[0m\n" "${fkzWxDataDownloadLink}"
			printf "\033[1;31m无法下载 FKZ_WX_DATA \"%s\"，可能是网络问题或无适配数据。\033[0m\n"
			printf "\033[1;33mFor network issues, try a VPN if in mainland China, or check %s.\033[0m\n" "${repositoryHomePage}"
			printf "\033[1;33mFor missing data, try WeChat 8.0.48 (home) and WechatXposed 2.44 (33).\033[0m\n"
			printf "\033[1;33m网络问题请尝试科学上网或访问 %s；无适配数据请使用微信 8.0.48 和微 X 模块 2.44（33）。\033[0m\n\n" "${repositoryHomePage}"
			exit 33
		fi
		printf "\033[1;33mDecompressing FKZ_WX_DATA \"%s\" to \"%s\", please wait.\033[0m\n" "${fkzWxDataDownloadFilePath}" "${fkzWxDataDownloadFolderPath}"
		printf "\033[1;33m正在解压 FKZ_WX_DATA \"%s\" 到 \"%s\"，请稍候。\033[0m\n\n" "${fkzWxDataDownloadFilePath}" "${fkzWxDataDownloadFolderPath}"
		rm -rf "${fkzWxDataDownloadFolderPath}" && unzip -o "${fkzWxDataDownloadFilePath}" -d "${fkzWxDataDownloadFolderPath}" > /dev/null 2>&1
		if [[ $? -eq ${EXIT_SUCCESS} && -d "${fkzWxDataDownloadFolderPath}" ]];
		then
			printf "\033[1;32mSuccessfully decompressed FKZ_WX_DATA to \"%s\".\033[0m\n" "${fkzWxDataDownloadFolderPath}"
			printf "\033[1;32m成功解压 FKZ_WX_DATA 到 \"%s\"。\033[0m\n\n" "${fkzWxDataDownloadFolderPath}"
		else
			printf "\033[1;31mFailed to decompress FKZ_WX_DATA to \"%s\" (34).\033[0m\n" "${fkzWxDataDownloadFolderPath}"
			printf "\033[1;31m无法解压 FKZ_WX_DATA 到 \"%s\"（34）。\033[0m\n"
			printf "\033[1;33mPlease import FKZ_WX_DATA using WX Repair Tool or manually.\033[0m\n"
			printf "\033[1;33m请使用 WX Repair Tool 或手动导入 FKZ_WX_DATA（34）。\033[0m\n\n"
			exit 34
		fi
		flag=${EXIT_SUCCESS}
		for filePath in $(find "${fkzWxDataDownloadFolderPath}" -type f -name "FKZ_WX_*")
		do
			fileName="$(basename "${filePath}")"
			targetFilePath="${fkzWxDataFolderPath}/${fileName}"
			cp "${filePath}" "${targetFilePath}" && chmod 660 "${targetFilePath}" && chown ${wechatUserId} "${targetFilePath}" && chgrp ${wechatUserId} "${targetFilePath}"
			if [[ $? -ne ${EXIT_SUCCESS} || ! -f "${targetFilePath}" ]];
			then
				flag=${EXIT_FAILURE}
			fi
		done
		if [[ ${flag} -eq ${EXIT_SUCCESS} ]];
		then
			printf "\033[1;32mSuccessfully copied FKZ_WX_* files to \"%s\" with permissions 660, owner/group %s.\033[0m\n" "${fkzWxDataFolderPath}" "${wechatUserId}"
			printf "\033[1;32m成功复制 FKZ_WX_* 文件到 \"%s\"，权限 660，所有者/用户组 %s。\033[0m\n\n" "${fkzWxDataFolderPath}" "${wechatUserId}"
		else
			printf "\033[1;31mFailed to copy FKZ_WX_* files to \"%s\" with permissions 660, owner/group %s (35).\033[0m\n" "${fkzWxDataFolderPath}" "${wechatUserId}"
			printf "\033[1;31m无法复制 FKZ_WX_* 文件到 \"%s\"，权限 660，所有者/用户组 %s（35）。\033[0m\n"
			printf "\033[1;33mPlease import FKZ_WX_DATA using WX Repair Tool or manually.\033[0m\n"
			printf "\033[1;33m请使用 WX Repair Tool 或手动导入 FKZ_WX_DATA（35）。\033[0m\n\n"
			exit 35
		fi
		if [[ -d "$(dirname "${fkzWxData999FolderPath}")" && ! -f "${fkzWxData999FilePath}" ]];
		then
			if mkdir -p "${fkzWxData999FolderPath}" && chmod 755 "${fkzWxData999FolderPath}" && chown ${wechatUserId} "${fkzWxData999FolderPath}" && chgrp ${wechatUserId} "${fkzWxData999FolderPath}";
			then
				for filePath in $(find "${fkzWxDataDownloadFolderPath}" -type f -name "FKZ_WX_*")
				do
					fileName="$(basename "${filePath}")"
					targetFilePath="${fkzWxData999FolderPath}/${fileName}"
					cp "${filePath}" "${targetFilePath}" && chmod 660 "${targetFilePath}" && chown ${wechatUserId} "${targetFilePath}" && chgrp ${wechatUserId} "${targetFilePath}"
					if [[ $? -ne ${EXIT_SUCCESS} || ! -f "${targetFilePath}" ]];
					then
						flag=${EXIT_FAILURE}
					fi
				done
			else
				flag=${EXIT_FAILURE}
			fi
			if [[ ${flag} -eq ${EXIT_SUCCESS} ]];
			then
				printf "\033[1;32mSuccessfully copied FKZ_WX_* files to \"%s\" with permissions 660, owner/group %s.\033[0m\n" "${fkzWxData999FolderPath}" "${wechatUserId}"
				printf "\033[1;32m成功复制 FKZ_WX_* 文件到 \"%s\"，权限 660，所有者/用户组 %s。\033[0m\n\n" "${fkzWxData999FolderPath}" "${wechatUserId}"
			else
				printf "\033[1;31mFailed to copy FKZ_WX_* files to \"%s\" with permissions 660, owner/group %s (36).\033[0m\n" "${fkzWxData999FolderPath}" "${wechatUserId}"
				printf "\033[1;31m无法复制 FKZ_WX_* 文件到 \"%s\"，权限 660，所有者/用户组 %s（36）。\033[0m\n"
				printf "\033[1;33mPlease import FKZ_WX_DATA using WX Repair Tool or manually.\033[0m\n"
				printf "\033[1;33m请使用 WX Repair Tool 或手动导入 FKZ_WX_DATA（36）。\033[0m\n\n"
				exit 36
			fi
		fi
	fi
else
	printf "\033[1;31mFailed to create directory \"%s\" for FKZ_WX_DATA (37).\033[0m\n" "${fkzWxDataFolderPath}"
	printf "\033[1;31m无法创建 FKZ_WX_DATA 目录 \"%s\"（37）。\033[0m\n\n" "${fkzWxDataFolderPath}"
	exit 37
fi

# Restart #
printf "\033[1;34m----- Restarting WeChat -----\033[0m\n"
printf "\033[1;34m----- 正在重启微信 -----\033[0m\n\n"
printf "\033[1;33mRestarting WeChat, please wait.\033[0m\n"
printf "\033[1;33m正在重启微信，请稍候。\033[0m\n\n"
am force-stop ${wechatPackageName}
sleep ${timeToSleep}
am start -n ${wechatPackageName}/${wechatUI}

# Exit #
printf "\033[1;34m===== Script Execution Complete =====\033[0m\n"
printf "\033[1;34m===== 脚本执行完成 =====\033[0m\n\n"
printf "\033[1;32mSuccessfully executed %s (%s).\033[0m\n" "${scriptName}" "${EXIT_SUCCESS}"
printf "\033[1;32m成功执行脚本 %s（%s）。\033[0m\n" "${scriptName}" "${EXIT_SUCCESS}"
printf "\033[1;34m====================\033[0m\n\n"
exit ${EXIT_SUCCESS}
