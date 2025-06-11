# WX Configuration Backups

本存储库旨在存储微 X 模块的配置。此外，此处提供了一个自动导入配置的 shell 脚本。

请安装最新版 WX Repair Tool 并重启微信。为便于表述，以下内容中微 X 模块包含 2.x 系列的微 X 模块和 3.0 版本的 X 模块。

## 架构

架构总览如下。为方便单独下载，每个最基层的文件夹都被转换为了一个压缩包，压缩包内容与原文件夹相同，下载后需要解压后使用。

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
│  ├─……
│  │  └─……
│  └─未归类
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
    ├─……
    │  └─……
    └─未归类
        └─……
```

### 核心文件

该文件夹的下一层为微信版本；再下一层为插件版本，即为需要被复制的文件夹。

请将对应您微信和微 X 模块的 GitHub 仓库文件夹（例如 wx6_2.44）复制到您安卓设备的以下两个目录下（第二个目录不是必须的），向目录授予 755 权限，并向其子文件夹（如有）和子文件分别授予 755 和 644 权限。随后，请将这两个目录及目录内的所有内容的所有者和用户组均设置为微信应用。

- /data/user/0/com.tencent.mm/files/
- /sdcard/Android/data/com.tencent.mm/files/WechatXposed/BACKUP/BACKUP_MODULE/

即，以 wx6_2.44 为例，操作完成后，在您的安卓设备中，以下两个目录应当存在且非空，其权限为 755，其里面的文件夹（如有）的权限为 755，其里面的文件的权限为 644。两个目录及目录内的所有内容的所有者和用户组均应已被设置为微信应用。同理，第二个目录不是必须的。

- /data/user/0/com.tencent.mm/files/wx6_2.44/
- /sdcard/Android/data/com.tencent.mm/files/WechatXposed/BACKUP/BACKUP_MODULE/wx6_2.44/

此外，如果您所使用的微信位于多用户系统中，请将以上操作中的目录 /data/user/0/com.tencent.mm/files/ 中的 0 替换为您的用户 ID，例如 999。

### FKZ_WX_DATA

如果之前已经使用过微 X 模块，只需要导入核心文件即可使用微 X 模块。

请将对应您微信和微 X 模块的 GitHub 仓库文件夹**中的文件**复制到您安卓设备的以下两个目录下，其中第二个目录不是必须的。请将被复制过去的文件的权限、所有者、用户组分别设置为 660、微信应用和微信应用。

- /data/data/com.tencent.mm/databases/
- /sdcard/Android/data/com.tencent.mm/files/WechatXposed/BACKUP/BACKUP_DATABASE/

即，操作完成后，在您的安卓设备中，以下目录应当存在且为非空。被复制过去的文件的权限、所有者、用户组应已被分别设置为 660、微信应用和微信应用。同理，第二个目录不是必须的。

- /data/data/com.tencent.mm/databases/
- /sdcard/Android/data/com.tencent.mm/files/WechatXposed/BACKUP/BACKUP_DATABASE/

## autoImport.sh

在安卓设备上审计后使用 root 权限本地执行，该脚本将基于本存储库自动向安卓设备本地导入微 X 模块核心文件和 FKZ_WX_DATA。

## 常见异常处理

此处提供一些 WX Repair Tool 中常出现的异常的处理方式。

### hookFail 可疑

该异常往往伴随核心文件数据文件数不正确或版本适配错误的异常出现，导入同时适配于所使用的微信和微 X 模块版本的核心文件数据即可处理该异常。

### verifier6_time 或 verifier6 异常

该异常通常出现于使用具有 root 权限的 MT 管理器导入 FKZ_WX_DATA 后，将导入的 FKZ_WX_DATA 的所有者和用户组均设置为微信应用即可解决该异常。

## 致谢

- [https://github.com/fkzhang/WechatUnrecalled](https://github.com/fkzhang/WechatUnrecalled)
- [https://github.com/Xposed-Modules-Repo/com.fkzhang.wechatxposed](https://github.com/Xposed-Modules-Repo/com.fkzhang.wechatxposed)
- [https://github.com/Xposed-Modules-Repo/wx.repair.tool](https://github.com/Xposed-Modules-Repo/wx.repair.tool)
- [@longli928](https://github.com/longli928)
- [@Y-sir](https://github.com/Y-sir)
- [https://www.coolapk.com/feed/65356995](https://www.coolapk.com/feed/65356995)
- [https://www.123684.com/s/gIe6Vv-jMHd3](https://www.123684.com/s/gIe6Vv-jMHd3)
- [https://wwbg.lanzoub.com/iEhha2yg9ehi](https://wwbg.lanzoub.com/iEhha2yg9ehi)
- [https://www.123684.com/s/78hZVv-G2Bn3](https://www.123684.com/s/78hZVv-G2Bn3)

---

# WX Configuration Backups

This repository is designed to store the configurations of the WechatXposed plugin. Additionally, a shell script for automatic configuration importing is provided. 

Please: 
- Install and activate the latest WX Repair Tool; 
- Force-stop the WeChat; and
- Launch WeChat again. 

To make it convenient, the WechatXposed plugin in the following content includes 2.x series of the WechatXposed plugin and X 3.0. 

## Architecture

Here is an overview of the architecture. To facilitate separate downloading, each bottom-level folder has been converted into a ZIP file, whose content is the same as the original folder and requires decompression after downloading. 

```
├─Core files
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
│  ├─...
│  │  └─...
│  └─Unresolved
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
    ├─...
    │  └─...
    └─Unresolved
        └─...
```

### Core files

The child level of this folder indicates the WeChat version. The child level of a WeChat version indicates the plugin version, which is the folder that needs to be copied.

Please **copy** the corresponding GitHub repository folder (e.g., wx6_2.44) adapted to both your WeChat and WechatXposed **to** both of the following directories (the second one is optional) on your Android device. Please grant 755 permissions for the two copied folders. Please grant 755 and 644 permissions for their subfolders (if there are) and subfiles, respectively. Subsequently, please change the owner and the user group of the two folders and all the objects inside them to the WeChat application. 

- /data/user/0/com.tencent.mm/files/
- /sdcard/Android/data/com.tencent.mm/files/WechatXposed/BACKUP/BACKUP_MODULE/

That is, taking wx6_2.44 as an example, both of the following directories should exist and should not be empty, with permissions set to 755, on your Android device, after successful operations. The permissions of their subfolders (if there are) and subfiles should have been set to 755 and 644, respectively. The owner and the user group of the two folders and all the objects inside them should have been set to the WeChat application. Similarly, the second folder is optional. 

- /data/user/0/com.tencent.mm/files/wx6_2.44/
- /sdcard/Android/data/com.tencent.mm/files/WechatXposed/BACKUP/BACKUP_MODULE/wx6_2.44/

In addition, if the WeChat you are using is in a multi-user system, please replace 0 in the directory /data/user/0/com.tencent.mm/files/ in the above operations with your user ID, such as 999. 

### FKZ_WX_DATA

If you used the WechatXposed plugin before, it will work after importing only the core files. 

Please **copy** the files in the corresponding GitHub repository folder adapted to both your WeChat and WechatXposed **to** both of the following directories (the second one is optional) on your Android device. Please set the permissions, the owner, and the user group of all the files copied to 660, the WeChat application, and the WeChat application, respectively. 

- /data/data/com.tencent.mm/databases/
- /sdcard/Android/data/com.tencent.mm/files/WechatXposed/BACKUP/BACKUP_DATABASE/

That is, both of the following directories should exist and should not be empty on your Android device after successful operations. The permissions, the owner, and the user group of all the files copied should have been set to 660, the WeChat application, and the WeChat application, respectively. 

- /data/data/com.tencent.mm/databases/
- /sdcard/Android/data/com.tencent.mm/files/WechatXposed/BACKUP/BACKUP_DATABASE/

## autoImport.sh

By executing it locally with root privileges on your Android device after checking it, this script will automatically import the core data and FKZ_WX_DATA files for the WechatXposed plugin. 

## Exceptions

Here are some common exception handling methods in the WX Repair Tool.

### hookFail suspicious

This exception often occurs due to an incorrect number of core data files or version adaptation errors. Importing core data adapted to both the WeChat and WechatXposed versions can solve this exception. 

### verifier6_time or verifier6 exception

This exception usually occurs after importing FKZ_WX_DATA using MT Manager with root permissions. Setting both the owner and user group of the imported FKZ_WX_DATA to the WeChat application can solve this exception. 

## Acknowledgement

- [https://github.com/fkzhang/WechatUnrecalled](https://github.com/fkzhang/WechatUnrecalled)
- [https://github.com/Xposed-Modules-Repo/com.fkzhang.wechatxposed](https://github.com/Xposed-Modules-Repo/com.fkzhang.wechatxposed)
- [https://github.com/Xposed-Modules-Repo/wx.repair.tool](https://github.com/Xposed-Modules-Repo/wx.repair.tool)
- [@longli928](https://github.com/longli928)
- [@Y-sir](https://github.com/Y-sir)
- [https://www.coolapk.com/feed/65356995](https://www.coolapk.com/feed/65356995)
- [https://www.123684.com/s/gIe6Vv-jMHd3](https://www.123684.com/s/gIe6Vv-jMHd3)
- [https://wwbg.lanzoub.com/iEhha2yg9ehi](https://wwbg.lanzoub.com/iEhha2yg9ehi)
- [https://www.123684.com/s/78hZVv-G2Bn3](https://www.123684.com/s/78hZVv-G2Bn3)
