# MouseKeepAlive

一款轻量级的 macOS 防休眠工具，通过智能监测鼠标和键盘活动，在用户无活动时自动模拟鼠标移动。

## 功能特点

- 智能监测鼠标和键盘活动
- 可配置的检测时间（5/10/30/60/120秒）
- 可配置的移动范围（5/10/20/50像素）
- 菜单栏集成，轻量高效

## 安装

### 下载预编译版本

1. 前往 [Releases](https://github.com/alpacachen/MouseKeepAlive/releases) 下载最新版本
2. 解压后拖入「应用程序」文件夹
3. 首次打开右键点击 -> 打开

### 从源码编译

```bash
git clone https://github.com/alpacachen/MouseKeepAlive.git
cd MouseKeepAlive
open MouseKeepAlive.xcodeproj
# 在 Xcode 中按 Cmd + R 运行
```

## 权限设置

应用需要**辅助功能权限**才能正常工作：

**系统设置** → **隐私与安全性** → **辅助功能** → 勾选 `MouseKeepAlive`

## 使用说明

1. 启动应用后会在菜单栏显示图标
2. 点击菜单栏图标可配置检测时间和移动范围
3. 应用会在后台自动工作

## 系统要求

- macOS 13.0 或更高版本

## 许可证

MIT License - 查看 [LICENSE](LICENSE) 文件了解详情
