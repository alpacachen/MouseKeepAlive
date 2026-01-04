import Cocoa
import CoreGraphics

class MouseMonitor {
    private var timer: Timer?
    private var lastMousePosition: CGPoint?
    private var lastActivityTime: Date?
    private var keyboardMonitor: Any?
    private let settings = AppSettings.shared
    private let permissionManager = PermissionManager.shared
    private(set) var moveCount: Int = 0
    var onMoveCountChanged: ((Int) -> Void)?

    // 记录上次请求权限的时间，避免频繁弹窗
    private var lastPermissionRequestTime: Date?
    private let permissionRequestInterval: TimeInterval = 300 // 5分钟内不重复请求

    func start() {
        NSLog("🚀 活动监控器已启动（鼠标+键盘）")

        // 记录初始位置和时间
        lastMousePosition = NSEvent.mouseLocation
        lastActivityTime = Date()

        // 检查权限状态（不弹窗）
        let hasPermission = permissionManager.hasAccessibilityPermission()
        if hasPermission {
            NSLog("✅ 已获得辅助功能权限")
        } else {
            NSLog("⚠️ 尚未获得辅助功能权限，将在需要移动鼠标时提示用户")
        }

        // 启动键盘监听
        startKeyboardMonitoring()

        // 每秒检查一次
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.checkActivity()
        }
        NSLog("✅ Timer 已启动，将每秒检查一次")
    }

    private func startKeyboardMonitoring() {
        // 监听全局键盘事件（需要辅助功能权限）
        // 监听所有键盘相关事件类型
        let keyboardEvents: NSEvent.EventTypeMask = [.keyDown, .keyUp, .flagsChanged]

        keyboardMonitor = NSEvent.addGlobalMonitorForEvents(matching: keyboardEvents) { [weak self] event in
            if event.type == .keyDown {
                // 获取按键字符（如果可能）
                if let characters = event.characters, !characters.isEmpty {
                    NSLog("🎹 全局键盘: 按下字符键 '\(characters)'")
                } else {
                    NSLog("🎹 全局键盘: keyDown (特殊键)")
                }
            } else if event.type == .flagsChanged {
                NSLog("🎹 全局键盘: 修饰键变化")
            }
            self?.onKeyboardActivity()
        }

        // 也监听本应用内的键盘事件
        NSEvent.addLocalMonitorForEvents(matching: keyboardEvents) { [weak self] event in
            if event.type == .keyDown {
                if let characters = event.characters, !characters.isEmpty {
                    NSLog("🎹 本地键盘: 按下字符键 '\(characters)'")
                } else {
                    NSLog("🎹 本地键盘: keyDown (特殊键)")
                }
            }
            self?.onKeyboardActivity()
            return event
        }

        // 验证监听器状态
        let hasPermission = permissionManager.hasAccessibilityPermission()
        if keyboardMonitor != nil {
            NSLog("✅ 键盘监听器已创建（监听 keyDown/keyUp/flagsChanged）")
            if hasPermission {
                NSLog("✅ 辅助功能权限已授予，应该可以监听全局键盘")
            } else {
                NSLog("⚠️ 缺少辅助功能权限，只能监听本应用内的键盘事件")
            }
        } else {
            NSLog("❌ 键盘监听器创建失败！")
        }

        // 测试提示
        NSLog("📝 测试方法：在其他应用中输入字母，观察是否有 '🎹 全局键盘' 日志")
    }

    private func onKeyboardActivity() {
        lastActivityTime = Date()
        NSLog("⏱️ 活动时间已重置（键盘）")
    }


    func stop() {
        timer?.invalidate()
        timer = nil

        // 移除键盘监听
        if let monitor = keyboardMonitor {
            NSEvent.removeMonitor(monitor)
            keyboardMonitor = nil
        }

        NSLog("🛑 活动监控器已停止")
    }

    private func checkActivity() {
        let currentPosition = NSEvent.mouseLocation

        // 检查鼠标是否移动
        if let lastPos = lastMousePosition, currentPosition != lastPos {
            // 鼠标移动了，更新记录
            lastMousePosition = currentPosition
            lastActivityTime = Date()
            NSLog("🖱️ 检测到鼠标移动，活动时间已重置")
            return
        }

        // 检查是否超过无活动阈值（包括鼠标和键盘）
        if let lastActivity = lastActivityTime {
            let timeSinceLastActivity = Date().timeIntervalSince(lastActivity)

            if timeSinceLastActivity >= settings.inactivityThreshold {
                NSLog("⚠️ 检测到 \(Int(timeSinceLastActivity)) 秒无活动（鼠标+键盘），准备执行随机移动")

                // 检查权限
                let hasPermission = permissionManager.hasAccessibilityPermission()
                NSLog("🔐 权限检查结果: \(hasPermission)")

                if !hasPermission {
                    // 检查是否需要请求权限（避免频繁弹窗）
                    let shouldRequestPermission: Bool
                    if let lastRequestTime = lastPermissionRequestTime {
                        let timeSinceLastRequest = Date().timeIntervalSince(lastRequestTime)
                        shouldRequestPermission = timeSinceLastRequest >= permissionRequestInterval
                        if !shouldRequestPermission {
                            NSLog("⚠️ 距上次权限请求仅 \(Int(timeSinceLastRequest)) 秒，暂不重复请求")
                        }
                    } else {
                        shouldRequestPermission = true
                    }

                    if shouldRequestPermission {
                        NSLog("❌ 无辅助功能权限，提示用户授权")
                        lastPermissionRequestTime = Date()
                        permissionManager.requestAccessibilityPermission()
                    }

                    // 重置计时器，避免频繁检查
                    lastActivityTime = Date()
                    return
                }

                NSLog("✅ 有权限，开始移动鼠标")
                performRandomMouseMove()
                // 重置计时器
                lastActivityTime = Date()
            } else if Int(timeSinceLastActivity) % 5 == 0 && Int(timeSinceLastActivity) > 0 {
                // 每5秒输出一次倒计时
                let remaining = Int(settings.inactivityThreshold - timeSinceLastActivity)
                NSLog("⏳ 无活动 \(Int(timeSinceLastActivity)) 秒，还剩 \(remaining) 秒触发移动")
            }
        }
    }

    private func performRandomMouseMove() {
        guard let currentPos = lastMousePosition else { return }

        // 获取主屏幕尺寸
        guard let screen = NSScreen.main else {
            NSLog("❌ 无法获取屏幕信息")
            return
        }

        let screenFrame = screen.frame
        let screenWidth = screenFrame.width
        let screenHeight = screenFrame.height

        // 随机生成屏幕上的任意位置
        let newX = CGFloat.random(in: 0...screenWidth)
        let newY = CGFloat.random(in: 0...screenHeight)

        NSLog("🖱️ 准备移动鼠标: (\(Int(currentPos.x)), \(Int(currentPos.y))) -> (\(Int(newX)), \(Int(newY))) [屏幕尺寸: \(Int(screenWidth))x\(Int(screenHeight))]")

        // 使用 CGEvent 移动鼠标
        if let moveEvent = CGEvent(mouseEventSource: nil,
                                   mouseType: .mouseMoved,
                                   mouseCursorPosition: CGPoint(x: newX, y: newY),
                                   mouseButton: .left) {
            moveEvent.post(tap: .cghidEventTap)
            NSLog("✅ 鼠标已移动到: (\(Int(newX)), \(Int(newY)))")

            // 更新记录的位置
            lastMousePosition = CGPoint(x: newX, y: newY)

            // 增加移动计数
            moveCount += 1
            onMoveCountChanged?(moveCount)
            NSLog("📊 自动移动次数: \(moveCount)")
        } else {
            NSLog("❌ 无法创建鼠标移动事件")
        }
    }

    deinit {
        stop()
    }
}
