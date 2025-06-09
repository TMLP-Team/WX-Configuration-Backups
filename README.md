# WX Configuration Backups

This repository is designed to store the configurations of the WechatXposed plugin. 

Please: 
- Install and activate the latest WX Repair Tool; 
- Force-stop the WeChat; and
- Launch WeChat again. 

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

Please **copy** the corresponding GitHub repository folder (e.g., wx6_2.44) adapted to both your WeChat and WechatXposed **to** both of the following directories (the second one is optional) on your Android device. Subsequently, grant 777 permissions for the two copied folders. 

- /data/user/0/com.tencent.mm/files/
- /sdcard/Android/data/com.tencent.mm/files/WechatXposed/BACKUP/BACKUP_MODULE/

That is, taking wx6_2.44 as an example, both of the following directories should exist and should not be empty, with permissions set to 777, on your Android device, after successful operations. The second one is optional. 

- /data/user/0/com.tencent.mm/files/wx6_2.44/
- /sdcard/Android/data/com.tencent.mm/files/WechatXposed/BACKUP/BACKUP_MODULE/wx6_2.44/

### FKZ_WX_DATA

If you used the WechatXposed plugin before, the WechatXposed plugin can work after importing only the core files. 

Please **copy** the files in corresponding GitHub repository folder adapted to both your WeChat and WechatXposed **to** both of the following directories (the second one is optional) on your Android device. 

- /data/data/com.tencent.mm/databases/
- /sdcard/Android/data/com.tencent.mm/files/WechatXposed/BACKUP/BACKUP_DATABASE/

That is, both of the following directory should exist and should not be empty on your Android device after successful operations. The second one is optional. 

- /data/data/com.tencent.mm/databases/
- /sdcard/Android/data/com.tencent.mm/files/WechatXposed/BACKUP/BACKUP_DATABASE/

## Acknowledgement

- [https://github.com/fkzhang/WechatUnrecalled](https://github.com/fkzhang/WechatUnrecalled)
- [https://github.com/Xposed-Modules-Repo/com.fkzhang.wechatxposed](https://github.com/Xposed-Modules-Repo/com.fkzhang.wechatxposed)
- [https://github.com/Xposed-Modules-Repo/wx.repair.tool](https://github.com/Xposed-Modules-Repo/wx.repair.tool)
- [https://www.coolapk.com/feed/65356995](https://www.coolapk.com/feed/65356995)
- [https://www.123684.com/s/gIe6Vv-jMHd3](https://www.123684.com/s/gIe6Vv-jMHd3)

---

# WX Configuration Backups

本存储库旨在存储微 X 模块的配置。

请安装最新版 WX Repair Tool 并重启微信。

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

请将对应您微信和微 X 模块的 GitHub 仓库文件夹（例如 wx6_2.44）复制到您安卓设备的以下两个目录下（第二个目录不是必须的）并授予 777 权限。

- /data/user/0/com.tencent.mm/files/
- /sdcard/Android/data/com.tencent.mm/files/WechatXposed/BACKUP/BACKUP_MODULE/

即，以 wx6_2.44 为例，操作完成后，在您的安卓设备中，以下两个目录应当存在且非空，其权限为 777。第二个目录不是必须的。

- /data/user/0/com.tencent.mm/files/wx6_2.44/
- /sdcard/Android/data/com.tencent.mm/files/WechatXposed/BACKUP/BACKUP_MODULE/wx6_2.44/

### FKZ_WX_DATA

如果之前已经使用过微 X 模块，只需要导入核心文件即可使用微 X 模块。

请将对应您微信和微 X 模块的 GitHub 仓库文件夹**中的文件**复制到您安卓设备的以下两个目录下，其中第二个目录不是必须的。

- /data/data/com.tencent.mm/databases/
- /sdcard/Android/data/com.tencent.mm/files/WechatXposed/BACKUP/BACKUP_DATABASE/

即，操作完成后，在您的安卓设备中，以下目录应当存在且为非空。第二个目录不是必须的。

- /data/data/com.tencent.mm/databases/
- /sdcard/Android/data/com.tencent.mm/files/WechatXposed/BACKUP/BACKUP_DATABASE/

## 特别鸣谢

- [https://github.com/fkzhang/WechatUnrecalled](https://github.com/fkzhang/WechatUnrecalled)
- [https://github.com/Xposed-Modules-Repo/com.fkzhang.wechatxposed](https://github.com/Xposed-Modules-Repo/com.fkzhang.wechatxposed)
- [https://github.com/Xposed-Modules-Repo/wx.repair.tool](https://github.com/Xposed-Modules-Repo/wx.repair.tool)
- [https://www.coolapk.com/feed/65356995](https://www.coolapk.com/feed/65356995)
- [https://www.123684.com/s/gIe6Vv-jMHd3](https://www.123684.com/s/gIe6Vv-jMHd3)
