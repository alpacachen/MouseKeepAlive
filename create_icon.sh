#!/bin/bash

# 使用 SF Symbols 创建应用图标
# 这个脚本使用 macOS 的 sips 和 swift 来生成图标

OUTPUT_DIR="Assets.xcassets/AppIcon.appiconset"
mkdir -p "$OUTPUT_DIR"

# 创建一个 Swift 脚本来生成图标
cat > /tmp/generate_icon.swift << 'EOF'
import Cocoa
import CoreGraphics

func createIcon(size: CGFloat) -> NSImage {
    let image = NSImage(size: NSSize(width: size, height: size))
    image.lockFocus()

    // 绘制圆形背景 - 蓝色
    let context = NSGraphicsContext.current!.cgContext
    let rect = CGRect(x: 0, y: 0, width: size, height: size)

    // 背景圆形
    let circlePath = NSBezierPath(ovalIn: rect.insetBy(dx: size * 0.05, dy: size * 0.05))
    NSColor(red: 0.2, green: 0.47, blue: 0.96, alpha: 1.0).setFill()
    circlePath.fill()

    // 绘制鼠标光标形状（白色）
    let cursorScale: CGFloat = 0.5
    let cursorSize = size * cursorScale
    let cursorLeft = (size - cursorSize) / 2
    let cursorTop = (size - cursorSize) / 2

    let cursorPath = NSBezierPath()
    cursorPath.move(to: CGPoint(x: cursorLeft, y: cursorTop))
    cursorPath.line(to: CGPoint(x: cursorLeft, y: cursorTop + cursorSize))
    cursorPath.line(to: CGPoint(x: cursorLeft + cursorSize * 0.35, y: cursorTop + cursorSize * 0.65))
    cursorPath.line(to: CGPoint(x: cursorLeft + cursorSize * 0.5, y: cursorTop + cursorSize * 0.85))
    cursorPath.line(to: CGPoint(x: cursorLeft + cursorSize * 0.65, y: cursorTop + cursorSize * 0.5))
    cursorPath.line(to: CGPoint(x: cursorLeft + cursorSize * 0.35, y: cursorTop + cursorSize * 0.35))
    cursorPath.close()

    NSColor.white.setFill()
    cursorPath.fill()

    // 绘制一个小的活动指示点（绿色）
    let dotSize = size * 0.15
    let dotX = size * 0.7
    let dotY = size * 0.3
    let dotPath = NSBezierPath(ovalIn: CGRect(x: dotX - dotSize/2, y: dotY - dotSize/2, width: dotSize, height: dotSize))
    NSColor(red: 0.3, green: 0.85, blue: 0.39, alpha: 1.0).setFill()
    dotPath.fill()

    image.unlockFocus()
    return image
}

// 生成所需的所有尺寸
let sizes: [(String, CGFloat)] = [
    ("icon_16x16.png", 16),
    ("icon_16x16@2x.png", 32),
    ("icon_32x32.png", 32),
    ("icon_32x32@2x.png", 64),
    ("icon_128x128.png", 128),
    ("icon_128x128@2x.png", 256),
    ("icon_256x256.png", 256),
    ("icon_256x256@2x.png", 512),
    ("icon_512x512.png", 512),
    ("icon_512x512@2x.png", 1024),
]

let outputDir = "Assets.xcassets/AppIcon.appiconset"

for (filename, size) in sizes {
    let icon = createIcon(size: size)

    if let tiffData = icon.tiffRepresentation,
       let bitmapImage = NSBitmapImageRep(data: tiffData),
       let pngData = bitmapImage.representation(using: .png, properties: [:]) {
        let filepath = "\(outputDir)/\(filename)"
        try? pngData.write(to: URL(fileURLWithPath: filepath))
        print("✅ Created \(filename)")
    }
}

print("✨ All icons generated!")
EOF

# 运行 Swift 脚本
echo "🎨 Generating app icons..."
swift /tmp/generate_icon.swift

echo ""
echo "📁 Icons saved to: $OUTPUT_DIR"
echo "🔄 Clean build and rebuild the app to see the new icon"
