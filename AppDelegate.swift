import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var mouseMonitor: MouseMonitor!
    private let settings = AppSettings.shared

    func applicationDidFinishLaunching(_ notification: Notification) {
        // 创建菜单栏图标
        setupStatusBar()

        // 初始化鼠标监控器
        mouseMonitor = MouseMonitor()
        mouseMonitor.onMoveCountChanged = { [weak self] count in
            DispatchQueue.main.async {
                self?.updateMenu()
            }
        }
        mouseMonitor.start()
    }

    private func setupStatusBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "cursorarrow.click.2", accessibilityDescription: "Mouse Keep Alive")
            button.image?.isTemplate = true
        }

        updateMenu()
    }

    private func updateMenu() {
        let menu = NSMenu()

        menu.addItem(NSMenuItem(title: "Mouse Keep Alive", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())

        let statusItem = NSMenuItem(title: "状态: 运行中 (鼠标+键盘)", action: nil, keyEquivalent: "")
        statusItem.isEnabled = false
        menu.addItem(statusItem)

        let countItem = NSMenuItem(title: "自动移动次数: \(mouseMonitor?.moveCount ?? 0)", action: nil, keyEquivalent: "")
        countItem.isEnabled = false
        menu.addItem(countItem)

        let infoItem = NSMenuItem(title: "\(settings.getInactivityThresholdSeconds())秒无活动时移动鼠标", action: nil, keyEquivalent: "")
        infoItem.isEnabled = false
        menu.addItem(infoItem)

        menu.addItem(NSMenuItem.separator())

        // 休眠时间配置
        let timeMenu = NSMenu()
        timeMenu.addItem(NSMenuItem(title: "5秒", action: #selector(setInactivityTime5), keyEquivalent: ""))
        timeMenu.addItem(NSMenuItem(title: "10秒", action: #selector(setInactivityTime10), keyEquivalent: ""))
        timeMenu.addItem(NSMenuItem(title: "30秒", action: #selector(setInactivityTime30), keyEquivalent: ""))
        timeMenu.addItem(NSMenuItem(title: "60秒", action: #selector(setInactivityTime60), keyEquivalent: ""))
        timeMenu.addItem(NSMenuItem(title: "120秒", action: #selector(setInactivityTime120), keyEquivalent: ""))

        let timeMenuItem = NSMenuItem(title: "休眠检测时间", action: nil, keyEquivalent: "")
        timeMenuItem.submenu = timeMenu
        menu.addItem(timeMenuItem)

        menu.addItem(NSMenuItem.separator())

        // 添加权限检查选项
        menu.addItem(NSMenuItem(title: "检查辅助功能权限", action: #selector(checkPermission), keyEquivalent: ""))

        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "退出", action: #selector(quitApp), keyEquivalent: "q"))

        self.statusItem.menu = menu
    }

    @objc func checkPermission() {
        let accessEnabled = AXIsProcessTrusted()

        let alert = NSAlert()
        if accessEnabled {
            alert.messageText = "权限状态"
            alert.informativeText = "✅ 辅助功能权限已授予，应用可正常工作。"
            alert.alertStyle = .informational
            alert.addButton(withTitle: "确定")
        } else {
            alert.messageText = "需要辅助功能权限"
            alert.informativeText = "⚠️ 应用需要辅助功能权限来控制鼠标移动。\n\n请在系统设置中授权后重启应用。"
            alert.alertStyle = .warning
            alert.addButton(withTitle: "打开系统设置")
            alert.addButton(withTitle: "取消")

            let response = alert.runModal()
            if response == .alertFirstButtonReturn {
                let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
                NSWorkspace.shared.open(url)
            }
            return
        }

        alert.runModal()
    }

    @objc func setInactivityTime5() {
        settings.inactivityThreshold = 5
        DispatchQueue.main.async { [weak self] in
            self?.updateMenu()
        }
    }

    @objc func setInactivityTime10() {
        settings.inactivityThreshold = 10
        DispatchQueue.main.async { [weak self] in
            self?.updateMenu()
        }
    }

    @objc func setInactivityTime30() {
        settings.inactivityThreshold = 30
        DispatchQueue.main.async { [weak self] in
            self?.updateMenu()
        }
    }

    @objc func setInactivityTime60() {
        settings.inactivityThreshold = 60
        DispatchQueue.main.async { [weak self] in
            self?.updateMenu()
        }
    }

    @objc func setInactivityTime120() {
        settings.inactivityThreshold = 120
        DispatchQueue.main.async { [weak self] in
            self?.updateMenu()
        }
    }

    @objc func quitApp() {
        mouseMonitor.stop()
        NSApplication.shared.terminate(nil)
    }
}
