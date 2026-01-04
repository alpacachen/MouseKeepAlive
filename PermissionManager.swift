import Cocoa

/// 辅助功能权限管理器
class PermissionManager {
    static let shared = PermissionManager()

    private init() {}

    /// 检查是否有辅助功能权限
    func hasAccessibilityPermission() -> Bool {
        return AXIsProcessTrusted()
    }

    /// 请求辅助功能权限（带提示窗口）
    /// - Returns: 是否已有权限
    @discardableResult
    func requestAccessibilityPermission() -> Bool {
        // 如果已经有权限，直接返回
        if hasAccessibilityPermission() {
            NSLog("✅ 已有辅助功能权限")
            return true
        }

        NSLog("⚠️ 没有辅助功能权限，显示提示窗口")

        // 显示提示窗口
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = "需要辅助功能权限"
            alert.informativeText = "MouseKeepAlive 需要辅助功能权限来控制鼠标移动。\n\n请在打开的系统设置中找到 MouseKeepAlive 并勾选它。"
            alert.alertStyle = .warning
            alert.addButton(withTitle: "打开系统设置")
            alert.addButton(withTitle: "稍后设置")

            let response = alert.runModal()
            if response == .alertFirstButtonReturn {
                self.openAccessibilitySettings()
            }
        }

        return false
    }

    /// 打开系统设置的辅助功能页面
    func openAccessibilitySettings() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
        NSWorkspace.shared.open(url)
    }

    /// 检查并在需要时请求权限
    /// - Parameter showAlertIfNeeded: 如果没有权限，是否显示提示窗口
    /// - Returns: 是否有权限
    func checkAndRequestIfNeeded(showAlertIfNeeded: Bool = true) -> Bool {
        let hasPermission = hasAccessibilityPermission()

        if !hasPermission && showAlertIfNeeded {
            requestAccessibilityPermission()
        }

        return hasPermission
    }
}
