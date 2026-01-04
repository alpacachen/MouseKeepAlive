import Cocoa
import CoreGraphics

class MouseMonitor {
    private var timer: Timer?
    private var lastMousePosition: CGPoint?
    private var lastActivityTime: Date?
    private var keyboardMonitor: Any?
    private let settings = AppSettings.shared

    func start() {
        print("活动监控器已启动（鼠标+键盘）")

        // 记录初始位置和时间
        lastMousePosition = NSEvent.mouseLocation
        lastActivityTime = Date()

        // 启动时立即检查权限
        checkAndRequestAccessibilityPermission()

        // 启动键盘监听
        startKeyboardMonitoring()

        // 每秒检查一次
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.checkActivity()
        }
    }

    private func startKeyboardMonitoring() {
        // 监听全局键盘事件（需要辅助功能权限）
        // 监听所有键盘相关事件类型
        let keyboardEvents: NSEvent.EventTypeMask = [.keyDown, .keyUp, .flagsChanged]

        keyboardMonitor = NSEvent.addGlobalMonitorForEvents(matching: keyboardEvents) { [weak self] event in
            if event.type == .keyDown {
                // 获取按键字符（如果可能）
                if let characters = event.characters, !characters.isEmpty {
                    print("🎹 全局键盘: 按下字符键 '\(characters)'")
                } else {
                    print("🎹 全局键盘: keyDown (特殊键)")
                }
            } else if event.type == .flagsChanged {
                print("🎹 全局键盘: 修饰键变化")
            }
            self?.onKeyboardActivity()
        }

        // 也监听本应用内的键盘事件
        NSEvent.addLocalMonitorForEvents(matching: keyboardEvents) { [weak self] event in
            if event.type == .keyDown {
                if let characters = event.characters, !characters.isEmpty {
                    print("🎹 本地键盘: 按下字符键 '\(characters)'")
                } else {
                    print("🎹 本地键盘: keyDown (特殊键)")
                }
            }
            self?.onKeyboardActivity()
            return event
        }

        // 验证监听器状态
        let hasPermission = AXIsProcessTrusted()
        if keyboardMonitor != nil {
            print("✅ 键盘监听器已创建（监听 keyDown/keyUp/flagsChanged）")
            if hasPermission {
                print("✅ 辅助功能权限已授予，应该可以监听全局键盘")
            } else {
                print("⚠️ 缺少辅助功能权限，只能监听本应用内的键盘事件")
            }
        } else {
            print("❌ 键盘监听器创建失败！")
        }

        // 测试提示
        print("📝 测试方法：在其他应用中输入字母，观察是否有 '🎹 全局键盘' 日志")
    }

    private func onKeyboardActivity() {
        lastActivityTime = Date()
        print("⏱️ 活动时间已重置（键盘）")
    }

    private func checkAndRequestAccessibilityPermission() {
        // 检查权限
        let accessEnabled = AXIsProcessTrusted()

        if accessEnabled {
            print("✅ 已获得辅助功能权限")
        } else {
            print("⚠️ 需要辅助功能权限，将请求授权")
            // 请求权限
            requestPermission()
        }
    }

    private func requestPermission() {
        let checkOptPrompt = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String
        let options = [checkOptPrompt: true] as CFDictionary
        let accessEnabled = AXIsProcessTrustedWithOptions(options)

        if !accessEnabled {
            showPermissionAlert()
        }
    }

    private func showPermissionAlert() {
        let alert = NSAlert()
        alert.messageText = "需要辅助功能权限"
        alert.informativeText = "MouseKeepAlive 需要辅助功能权限来控制鼠标移动。\n\n请在打开的系统设置中找到 MouseKeepAlive 并勾选它。"
        alert.alertStyle = .warning
        alert.addButton(withTitle: "打开系统设置")
        alert.addButton(withTitle: "稍后设置")

        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            // 打开系统设置的辅助功能页面
            let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
            NSWorkspace.shared.open(url)
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil

        // 移除键盘监听
        if let monitor = keyboardMonitor {
            NSEvent.removeMonitor(monitor)
            keyboardMonitor = nil
        }

        print("活动监控器已停止")
    }

    private func checkActivity() {
        let currentPosition = NSEvent.mouseLocation

        // 检查鼠标是否移动
        if let lastPos = lastMousePosition, currentPosition != lastPos {
            // 鼠标移动了，更新记录
            lastMousePosition = currentPosition
            lastActivityTime = Date()
            print("🖱️ 检测到鼠标移动，活动时间已重置")
            return
        }

        // 检查是否超过无活动阈值（包括鼠标和键盘）
        if let lastActivity = lastActivityTime {
            let timeSinceLastActivity = Date().timeIntervalSince(lastActivity)

            if timeSinceLastActivity >= settings.inactivityThreshold {
                print("⚠️ 检测到 \(Int(timeSinceLastActivity)) 秒无活动（鼠标+键盘），执行随机移动")

                // 在触发移动前再次检查权限
                let hasPermission = AXIsProcessTrusted()
                if !hasPermission {
                    print("❌ 无辅助功能权限，尝试请求权限")
                    checkAndRequestAccessibilityPermission()
                    // 重置计时器，避免频繁提示
                    lastActivityTime = Date()
                    return
                }

                performRandomMouseMove()
                // 重置计时器
                lastActivityTime = Date()
            } else if Int(timeSinceLastActivity) % 5 == 0 && Int(timeSinceLastActivity) > 0 {
                // 每5秒输出一次倒计时
                let remaining = Int(settings.inactivityThreshold - timeSinceLastActivity)
                print("⏳ 无活动 \(Int(timeSinceLastActivity)) 秒，还剩 \(remaining) 秒触发移动")
            }
        }
    }

    private func performRandomMouseMove() {
        guard let currentPos = lastMousePosition else { return }

        // 生成随机偏移（确保移动明显可见）
        let range = CGFloat(settings.moveRange)
        let deltaX = CGFloat.random(in: -range...range)
        let deltaY = CGFloat.random(in: -range...range)

        let newX = currentPos.x + deltaX
        let newY = currentPos.y + deltaY

        print("🖱️ 准备移动鼠标: (\(Int(currentPos.x)), \(Int(currentPos.y))) -> (\(Int(newX)), \(Int(newY))) [偏移: (\(Int(deltaX)), \(Int(deltaY)))]")

        // 使用 CGEvent 移动鼠标
        if let moveEvent = CGEvent(mouseEventSource: nil,
                                   mouseType: .mouseMoved,
                                   mouseCursorPosition: CGPoint(x: newX, y: newY),
                                   mouseButton: .left) {
            moveEvent.post(tap: .cghidEventTap)
            print("✅ 鼠标已移动到: (\(Int(newX)), \(Int(newY)))")

            // 更新记录的位置
            lastMousePosition = CGPoint(x: newX, y: newY)
        } else {
            print("❌ 无法创建鼠标移动事件")
        }
    }

    deinit {
        stop()
    }
}
