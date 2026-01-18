//
//  AppDelegate.swift
//  ClipMaster
//
//  应用生命周期管理和权限请求
//

import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    /// 状态栏管理器
    private var statusBarManager: StatusBarManager?

    /// 剪切板监听器
    private var clipboardMonitor: ClipboardMonitor?

    /// 应用检测服务
    private let appDetection = AppDetectionService.shared

    // MARK: - 应用生命周期

    /// 应用启动完成
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("✅ ClipMaster 启动")

        // 1. 初始化数据库
        _ = DatabaseManager.shared
        DatabaseSetup.setup()

        // 2. 检查辅助功能权限
        checkAccessibilityPermission()

        // 3. 启动剪切板监听
        clipboardMonitor = ClipboardMonitor.shared
        clipboardMonitor?.startMonitoring()

        // 4. 创建状态栏图标
        statusBarManager = StatusBarManager.shared

        // 5. 设置应用为纯代理应用 (不显示 Dock 图标)
        setupAsAgentApp()

        print("✅ ClipMaster 已就绪")
    }

    /// 应用即将终止
    func applicationWillTerminate(_ notification: Notification) {
        print("⏹ ClipMaster 即将退出")

        // 停止监听
        clipboardMonitor?.stopMonitoring()

        // 关闭数据库
        DatabaseManager.shared.closeDatabase()
    }

    // MARK: - 应用配置

    /// 设置为纯代理应用 (不显示 Dock 图标)
    private func setupAsAgentApp() {
        // 设置应用激活策略为禁止
        NSApp.setActivationPolicy(.accessory)

        // 这样应用就不会在 Dock 中显示图标
        // 只在状态栏显示
    }

    // MARK: - 权限检查

    /// 检查辅助功能权限
    private func checkAccessibilityPermission() {
        if !appDetection.hasAccessibilityPermission() {
            print("⚠️ 需要辅助功能权限")

            // 检查是否已经提示过用户
            let hasPromptedBefore = UserDefaults.standard.bool(forKey: "hasPromptedAccessibilityPermission")

            if !hasPromptedBefore {
                // 首次检测到无权限，显示提示
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.showPermissionAlert()
                }
            } else {
                print("ℹ️ 用户已知晓需要辅助功能权限，不再提示")
            }
        } else {
            print("✅ 已获得辅助功能权限")
        }
    }

    /// 显示权限请求对话框
    private func showPermissionAlert() {
        // 标记已经提示过用户
        UserDefaults.standard.set(true, forKey: "hasPromptedAccessibilityPermission")

        let alert = NSAlert()
        alert.messageText = "需要辅助功能权限"
        alert.informativeText = """
        ClipMaster 需要辅助功能权限以检测前台应用,实现隐私保护功能。

        请在弹出的系统偏好设置中勾选 ClipMaster,然后重启应用。

        如果对话框未弹出,请前往:
        系统偏好设置 > 隐私与安全性 > 辅助功能
        """
        alert.alertStyle = .informational
        alert.addButton(withTitle: "好")
        alert.addButton(withTitle: "稍后")

        let response = alert.runModal()

        if response == .alertFirstButtonReturn {
            // 用户点击了"好",请求权限
            appDetection.requestAccessibilityPermission()

            // 再次检查
            if appDetection.hasAccessibilityPermission() {
                print("✅ 用户已授权辅助功能权限")
            } else {
                print("⚠️ 用户尚未授权辅助功能权限")
            }
        }
    }

    // MARK: - 应用激活

    /// 应用被激活时
    func applicationDidBecomeActive(_ notification: Notification) {
        // 当应用被激活时,可以做一些操作
        // 例如:显示 Popover
    }

    /// 应用即将失去激活
    func applicationDidResignActive(_ notification: Notification) {
        // 当应用失去激活时,可以做一些清理操作
        // 例如:隐藏 Popover
    }
}
