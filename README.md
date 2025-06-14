# WX Configuration Backups

本存储库旨在存储微 X 模块的配置。为便于表述，本仓库中定义的微 X 模块包含 2.x 系列的微 X 模块和 3.0 版本的 X 模块。此外，此处提供了一个自动导入配置的 shell 脚本，该脚本需要 root 权限，请审计后使用。

请安装最新版 WX Repair Tool，激活微 X 模块和 WX Repair Tool，导入适配的核心文件和 FKZ_WX_DATA，并重启微信。为安全起见，请配置 HMAL/HMA 以保持微信无法在应用列表中检测到微 X 模块和 WX Repair Tool。

已正常使用过微 X 模块且未清除或重置 FKZ_WX_DATA 的用户可能不需要导入 FKZ_WX_DATA，要导入的 FKZ_WX_DATA 可能不需要同时适配微信和微 X 模块版本也能成功修复微 X 模块。

本存储库的配置数据备份源于五湖四海，请在导入后自行实测是否可用。测试时，请以实际功能而非 WX Repair Tool 的检验结果或插件的用户界面（User Interface，简称 UI）为准。

欢迎各位朋友向本仓库提交核心文件和 FKZ_WX_DATA 备份，其中，FKZ_WX_DATA 可能含有 WXID 信息，介意者请勿向本仓库提交 FKZ_WX_DATA。在此，我们向提供配置数据的朋友们一并表示感谢。

## 架构

架构总览如下。为方便单独下载，每个基层文件夹都被转换为了一个压缩包，压缩包内容与原文件夹相同，下载后需要解压后使用。有关基层文件夹的定义和内容，请参阅下文。

```
├─核心文件
│  ├─8.0.49
│  │  └─x7_3.0
│  │  └─wx6_2.44
│  │  └─wx6_2.43
│  │  └─……
│  ├─8.0.48
│  │  └─x7_3.0
│  │  └─wx6_2.44
│  │  └─wx6_2.43
│  │  └─……
│  └─……
│      └─……
└─FKZ_WX_DATA
    ├─8.0.49
    │  └─x7_v3.0
    │  └─wx6_v2.44
    │  └─wx6_v2.43
    │  └─……
    ├─8.0.48
    │  └─x7_v3.0
    │  └─wx6_v2.44
    │  └─wx6_v2.43
    │  └─……
    └─……
        └─……
```

### 核心文件

在本存储库中，核心文件的下一层为微信版本；再下一层为插件版本，即为需要被复制的文件夹。我们定义该文件夹为基层文件夹，核心文件的基层文件夹中含有若干文件，也可能含有文件夹。

请将对应您微信和微 X 模块的 GitHub 仓库文件夹（例如 wx6_2.44）复制到您安卓设备的以下两个目录下（第二个目录不是必须的），向目录授予 755 权限，并向其子文件夹（如有）和子文件分别授予 755 和 644 权限。
随后，请将这两个目录及目录内的所有内容的所有者和用户组均设置为微信应用。

- /data/user/0/com.tencent.mm/files/
- /sdcard/Android/data/com.tencent.mm/files/WechatXposed/BACKUP/BACKUP_MODULE/

即，以 wx6_2.44 为例，操作完成后，在您的安卓设备中，以下两个目录应当存在且非空，其权限为 755，其里面的文件夹（如有）的权限为 755，其里面的文件的权限为 644。
两个目录及目录内的所有内容的所有者和用户组均应已被设置为微信应用。同理，第二个目录不是必须的。

- /data/user/0/com.tencent.mm/files/wx6_2.44/
- /sdcard/Android/data/com.tencent.mm/files/WechatXposed/BACKUP/BACKUP_MODULE/wx6_2.44/

此外，如果您所使用的微信位于多用户系统中，请将以上操作中的目录 /data/user/0/com.tencent.mm/files/ 中的 0 替换为您的用户 ID，例如 999。

### FKZ_WX_DATA

已正常使用过微 X 模块且未清除或重置 FKZ_WX_DATA 的用户可能不需要导入 FKZ_WX_DATA，要导入的 FKZ_WX_DATA 可能不需要同时适配微信和微 X 模块版本也能成功修复微 X 模块。

在本存储库中，FKZ_WX_DATA 的下一层为微信版本；再下一层为插件版本，里面的文件即为需要被复制的文件。

我们定义指示插件版本的文件夹为基层文件夹，FKZ_WX_DATA 的基层文件夹中含有若干个文件名以 ``FKZ_WX_`` 开头的文件，不含有文件夹。

请将对应您微信和微 X 模块的 GitHub 仓库文件夹中文件名以 ``FKZ_WX_`` 开头的文件复制到您安卓设备的以下两个目录下，其中第二个目录不是必须的。

请将被复制过去的文件的权限、所有者、用户组分别设置为 660、微信应用和微信应用。

- /data/data/com.tencent.mm/databases/
- /sdcard/Android/data/com.tencent.mm/files/WechatXposed/BACKUP/BACKUP_DATABASE/

即，操作完成后，在您的安卓设备中，以下目录应当存在且为非空。被复制过去的文件的权限、所有者、用户组应已被分别设置为 660、微信应用和微信应用。同理，第二个目录不是必须的。

- /data/data/com.tencent.mm/databases/
- /sdcard/Android/data/com.tencent.mm/files/WechatXposed/BACKUP/BACKUP_DATABASE/

## autoImport.sh

在安卓设备上审计后使用 root 权限本地执行，该脚本将基于本存储库自动向安卓设备本地导入微 X 模块核心文件和 FKZ_WX_DATA。

该脚本支持在 Termux 或 MT 管理器中执行，在 MT 管理器中执行时请使用系统环境。

## 常见异常处理

此处提供一些 WX Repair Tool 中常出现的异常的处理方式。

### hookFail 可疑

该异常往往伴随核心文件数据文件数不正确或版本适配错误的异常出现，导入同时适配于所使用的微信和微 X 模块版本的核心文件数据即可处理该异常。

### verifier6_time 或 verifier6 异常

该异常通常出现于使用具有 root 权限的 MT 管理器导入 FKZ_WX_DATA 后，将导入的 FKZ_WX_DATA 的所有者和用户组均设置为微信应用即可解决该异常。

## 使用许可

本存储库的使用许可遵从上游使用许可，即基于微 X 模块和 WX Repair Tool 的使用许可开放使用。

## 致谢

- [https://github.com/fkzhang/WechatUnrecalled](https://github.com/fkzhang/WechatUnrecalled)
- [https://github.com/Xposed-Modules-Repo/com.fkzhang.wechatxposed](https://github.com/Xposed-Modules-Repo/com.fkzhang.wechatxposed)
- [https://github.com/Xposed-Modules-Repo/wx.repair.tool](https://github.com/Xposed-Modules-Repo/wx.repair.tool)
- [@bzggnveee](https://github.com/bzggnveee)
  - [Pull Request #10](https://github.com/TMLP-Team/WX-Configuration-Backups/pull/10)：更新 ``autoImport.sh``
    - 修复微信用户ID解析
    - 美化脚本
    - 优化英文表达
    - 使用 ``printf`` 替换多余的 ``echo``
    - 添加用户协议
  - [https://www.123865.com/s/U2rKVv-UeH4H](https://www.123865.com/s/U2rKVv-UeH4H)
    - ``./核心文件/8.0.24 (2100)/wx6_2.33`` 和 ``./FKZ_WX_DATA/8.0.24 (2100)/wx6_2.33``
    - ``./核心文件/8.0.24 (2100)/wx6_2.41`` 和 ``./FKZ_WX_DATA/8.0.24 (2100)/wx6_2.41``
- [@cuuemo](https://github.com/cuuemo)：``./核心文件/8.0.48 (2580)/wx6_2.44``
- [@longli928](https://github.com/longli928)：``./核心文件/Play 8.0.48 (2588)/x7_3.0`` 和 ``./FKZ_WX_DATA/Play 8.0.48 (2588)/x7_3.0``
- [@Y-sir](https://github.com/Y-sir)：``./FKZ_WX_DATA/8.0.45 (2520)/wx6_v2.44``
- 来自 WX Repair Tool 官方 QQ 2 群的某匿名群友
  - [https://www.coolapk.com/feed/65356995](https://www.coolapk.com/feed/65356995)
  - [https://www.123684.com/s/gIe6Vv-jMHd3](https://www.123684.com/s/gIe6Vv-jMHd3)
  - [https://wwbg.lanzoub.com/iEhha2yg9ehi](https://wwbg.lanzoub.com/iEhha2yg9ehi)
  - [https://www.123684.com/s/78hZVv-G2Bn3](https://www.123684.com/s/78hZVv-G2Bn3)

---

# WX Configuration Backups

This repository is designed to store the configurations of the WechatXposed plugin. To make it convenient, the WechatXposed plugin defined in this repository includes 2.x series of the WechatXposed plugin and X 3.0. 
Additionally, a shell script for automatic configuration importing is provided. 

Please install the latest WX Repair Tool, activate it, import the adapted core data and FKZ_WX_DATA files, and restart the WeChat. 
To be safe, please configure HMAL/HMA to prevent the WechatXposed plugin and the WX Repair Tool from being seen by WeChat. 

For users who used the WechatXposed plugin before, importing FKZ_WX_DATA files may be unnecessary if the plugin was not reset. The FKZ_WX_DATA to be imported may not need to be adapted to both WeChat and WechatXposed versions. 

The configuration backups of this repository came from everywhere. Please test on your own whether the functions of the WechatXposed plugin become available after importing. 
The judgment relying on the prompt of the WX Repair Tool or the user interface (UI) of the WechatXposed plugin can be incorrect. 

Welcome to submit core data and FKZ_WX_DATA backups to this repository. Among them, FKZ_WX_DATA may contain WXID information. Please do not submit FKZ_WX_DATA to this repository if you mind this. 
Here, we would like to express our sincere gratitude to those who provided the configuration backups. 

## Architecture

Here is an overview of the architecture. To facilitate separate downloading, each bottom-level folder has been converted into a ZIP file, whose content is the same as the original folder and requires decompression after downloading. 
Please see below for the definition and contents of fundamental folders. 

```
├─核心文件
│  ├─8.0.49
│  │  └─x7_3.0
│  │  └─wx6_2.44
│  │  └─wx6_2.43
│  │  └─...
│  ├─8.0.48
│  │  └─x7_3.0
│  │  └─wx6_2.44
│  │  └─wx6_2.43
│  │  └─...
│  └─...
│      └─...
└─FKZ_WX_DATA
    ├─8.0.49
    │  └─x7_v3.0
    │  └─wx6_v2.44
    │  └─wx6_v2.43
    │  └─...
    ├─8.0.48
    │  └─x7_v3.0
    │  └─wx6_v2.44
    │  └─wx6_v2.43
    │  └─...
    └─...
        └─...
```

### 核心文件

The English of this folder is ``Core Data``. The child level of this folder indicates the WeChat version. The child level of a WeChat version indicates the plugin version, which is the folder that needs to be copied. 
We define each of these folders as a fundamental folder. Each fundamental folder of the core data contains several files and may also contain folders. 

Please **copy** the corresponding GitHub repository folder (e.g., wx6_2.44) adapted to both your WeChat and WechatXposed **to** both of the following directories (the second one is optional) on your Android device. 
Please grant 755 permissions for the two copied folders. Please grant 755 and 644 permissions for their subfolders (if there are) and subfiles, respectively. 
Subsequently, please change the owner and the user group of the two folders and all the objects inside them to the WeChat application. 

- /data/user/0/com.tencent.mm/files/
- /sdcard/Android/data/com.tencent.mm/files/WechatXposed/BACKUP/BACKUP_MODULE/

That is, taking wx6_2.44 as an example, both of the following directories should exist and should not be empty, with permissions set to 755, on your Android device, after successful operations. 
The permissions of their subfolders (if there are) and subfiles should have been set to 755 and 644, respectively. 
The owner and the user group of the two folders and all the objects inside them should have been set to the WeChat application. Similarly, the second folder is optional. 

- /data/user/0/com.tencent.mm/files/wx6_2.44/
- /sdcard/Android/data/com.tencent.mm/files/WechatXposed/BACKUP/BACKUP_MODULE/wx6_2.44/

In addition, if the WeChat you are using is in a multi-user system, please replace 0 in the directory /data/user/0/com.tencent.mm/files/ in the above operations with your user ID, such as 999. 

### FKZ_WX_DATA

For users who used the WechatXposed plugin before, importing FKZ_WX_DATA files may be unnecessary if the plugin was not reset. The FKZ_WX_DATA to be imported may not need to be adapted to both WeChat and WechatXposed versions. 

In this repository, the child level of this folder indicates the WeChat version. The child level of a WeChat version indicates the plugin version, which contains the files that need to be copied. 

We define each of the folders that indicate the plugin version as a fundamental folder. Each fundamental folder of FKZ_WX_DATA contains several files whose names start with ``FKZ_WX_``, but no folders. 

Please **copy** the files whose names start with ``FKZ_WX_`` in the corresponding GitHub repository folder adapted to both your WeChat and WechatXposed **to** both of the following directories (the second one is optional) on your Android device. 

Please set the permissions, the owner, and the user group of all the files copied to 660, the WeChat application, and the WeChat application, respectively. 

- /data/data/com.tencent.mm/databases/
- /sdcard/Android/data/com.tencent.mm/files/WechatXposed/BACKUP/BACKUP_DATABASE/

That is, both of the following directories should exist and should not be empty on your Android device after successful operations. 
The permissions, the owner, and the user group of all the files copied should have been set to 660, the WeChat application, and the WeChat application, respectively. 

- /data/data/com.tencent.mm/databases/
- /sdcard/Android/data/com.tencent.mm/files/WechatXposed/BACKUP/BACKUP_DATABASE/

## autoImport.sh

By executing it locally with root privileges on your Android device after checking it, this script will automatically import the core data and FKZ_WX_DATA files for the WechatXposed plugin. 

This script can be executed in Termux or MT Manager. Please use the system environment when executing in MT Manager. 

## Exceptions

Here are some common exception handling methods in the WX Repair Tool.

### hookFail suspicious

This exception often occurs due to an incorrect number of core data files or version adaptation errors. Importing the files of the core data adapted to both the WeChat and WechatXposed versions can solve this exception. 

### verifier6_time or verifier6 exception

This exception usually occurs after importing FKZ_WX_DATA using MT Manager with root permissions. Setting both the owner and user group of the imported FKZ_WX_DATA to the WeChat application can solve this exception. 

## License

The license of this repository complies with the upstream license, which is open for use based on the license of the WechatXposed plugin and the WX Repair Tool. 

## Acknowledgement

- [https://github.com/fkzhang/WechatUnrecalled](https://github.com/fkzhang/WechatUnrecalled)
- [https://github.com/Xposed-Modules-Repo/com.fkzhang.wechatxposed](https://github.com/Xposed-Modules-Repo/com.fkzhang.wechatxposed)
- [https://github.com/Xposed-Modules-Repo/wx.repair.tool](https://github.com/Xposed-Modules-Repo/wx.repair.tool)
- [@cuuemo](https://github.com/cuuemo): ``./核心文件/8.0.48 (2580)/wx6_2.44``
- [@bzggnveee](https://github.com/bzggnveee)
  - [Pull Request #10](https://github.com/TMLP-Team/WX-Configuration-Backups/pull/10): Update ``autoImport.sh``
    - Repair the parsing of WeChat user ID
    - Beautify the script
    - Optimize English expressions
    - Use ``printf`` instead of redundant ``echo``
    - Add the user agreement
  - [https://www.123865.com/s/U2rKVv-UeH4H](https://www.123865.com/s/U2rKVv-UeH4H)
    - ``./核心文件/8.0.24 (2100)/wx6_2.33`` and ``./FKZ_WX_DATA/8.0.24 (2100)/wx6_2.33``
    - ``./核心文件/8.0.24 (2100)/wx6_2.41`` and ``./FKZ_WX_DATA/8.0.24 (2100)/wx6_2.41``
- [@longli928](https://github.com/longli928): ``./核心文件/Play 8.0.48 (2588)/x7_3.0`` and ``./FKZ_WX_DATA/Play 8.0.48 (2588)/x7_3.0``
- [@Y-sir](https://github.com/Y-sir): ``./FKZ_WX_DATA/8.0.45 (2520)/wx6_v2.44``
- An anonymous member from the Official QQ Group 2 of WX Repair Tool
  - [https://www.coolapk.com/feed/65356995](https://www.coolapk.com/feed/65356995)
  - [https://www.123684.com/s/gIe6Vv-jMHd3](https://www.123684.com/s/gIe6Vv-jMHd3)
  - [https://wwbg.lanzoub.com/iEhha2yg9ehi](https://wwbg.lanzoub.com/iEhha2yg9ehi)
  - [https://www.123684.com/s/78hZVv-G2Bn3](https://www.123684.com/s/78hZVv-G2Bn3)
