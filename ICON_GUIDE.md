# 应用图标指南

## 需要的图标尺寸

macOS 应用需要以下尺寸的图标（位于 `Assets.xcassets/AppIcon.appiconset/`）：

| 文件名 | 尺寸 |
|--------|------|
| icon_16x16.png | 16x16 |
| icon_16x16@2x.png | 32x32 |
| icon_32x32.png | 32x32 |
| icon_32x32@2x.png | 64x64 |
| icon_128x128.png | 128x128 |
| icon_128x128@2x.png | 256x256 |
| icon_256x256.png | 256x256 |
| icon_256x256@2x.png | 512x512 |
| icon_512x512.png | 512x512 |
| icon_512x512@2x.png | 1024x1024 |

## 设计建议

### 图标主题
- 🖱️ 鼠标相关图形
- ⚡ 表示"保持活动"的元素
- 🎯 简洁清晰，16x16 尺寸下也能识别

### 设计规范
- **风格**：扁平化、现代感
- **颜色**：蓝色/绿色系（表示活跃），或使用 macOS 系统配色
- **背景**：透明或渐变背景
- **圆角**：遵循 macOS 图标圆角规范

### 推荐工具
- Figma / Sketch - 设计
- [App Icon Generator](https://appicon.co/) - 在线生成多尺寸图标
- ImageMagick - 命令行批量生成

## 快速生成图标

如果你有一个 1024x1024 的主图标，可以使用以下脚本生成所有尺寸：

```bash
#!/bin/bash

# 需要安装 ImageMagick: brew install imagemagick

MASTER_ICON="icon_master.png"  # 你的 1024x1024 主图标
OUTPUT_DIR="Assets.xcassets/AppIcon.appiconset"

# 生成各个尺寸
sips -z 16 16     "${MASTER_ICON}" --out "${OUTPUT_DIR}/icon_16x16.png"
sips -z 32 32     "${MASTER_ICON}" --out "${OUTPUT_DIR}/icon_16x16@2x.png"
sips -z 32 32     "${MASTER_ICON}" --out "${OUTPUT_DIR}/icon_32x32.png"
sips -z 64 64     "${MASTER_ICON}" --out "${OUTPUT_DIR}/icon_32x32@2x.png"
sips -z 128 128   "${MASTER_ICON}" --out "${OUTPUT_DIR}/icon_128x128.png"
sips -z 256 256   "${MASTER_ICON}" --out "${OUTPUT_DIR}/icon_128x128@2x.png"
sips -z 256 256   "${MASTER_ICON}" --out "${OUTPUT_DIR}/icon_256x256.png"
sips -z 512 512   "${MASTER_ICON}" --out "${OUTPUT_DIR}/icon_256x256@2x.png"
sips -z 512 512   "${MASTER_ICON}" --out "${OUTPUT_DIR}/icon_512x512.png"
sips -z 1024 1024 "${MASTER_ICON}" --out "${OUTPUT_DIR}/icon_512x512@2x.png"

echo "✅ 图标生成完成！"
```

## 临时解决方案

如果暂时没有自定义图标，应用会使用 SF Symbols 中的系统图标：
- `cursorarrow.click.2` - 鼠标点击图标

这在菜单栏中显示效果也很好。

## 更新图标后

1. 清理 Xcode 构建缓存
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```

2. 重新构建项目
   ```bash
   xcodebuild clean build
   ```

3. 如果图标没有更新，重启 Xcode
