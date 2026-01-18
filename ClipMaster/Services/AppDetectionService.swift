//
//  AppDetectionService.swift
//  ClipMaster
//
//  前台应用检测服务
//

import AppKit

/// 前台应用检测服务
class AppDetectionService {

    /// 单例实例
    static let shared = AppDetectionService()

    private init() {}

    // MARK: - 获取前台应用

    /// 获取当前前台应用的 Bundle ID
    func getFrontmostApp() -> String? {
        let workspace = NSWorkspace.shared
        let runningApps = workspace.runningApplications

        // 查找当前激活的应用
        if let frontmostApp = runningApps.first(where: { $0.activationPolicy == .regular && $0.isActive }) {
            return frontmostApp.bundleIdentifier
        }

        // 备选方案: 获取最前面的应用
        for app in runningApps {
            if app.activationPolicy == .regular {
                return app.bundleIdentifier
            }
        }

        return nil
    }

    /// 获取当前前台应用的名称
    func getFrontmostAppName() -> String? {
        let workspace = NSWorkspace.shared
        let runningApps = workspace.runningApplications

        if let frontmostApp = runningApps.first(where: { $0.activationPolicy == .regular && $0.isActive }) {
            return frontmostApp.localizedName
        }

        return nil
    }

    /// 获取当前前台应用的图标
    func getFrontmostAppIcon() -> NSImage? {
        let workspace = NSWorkspace.shared
        let runningApps = workspace.runningApplications

        if let frontmostApp = runningApps.first(where: { $0.activationPolicy == .regular && $0.isActive }) {
            return frontmostApp.icon
        }

        return nil
    }

    // MARK: - 黑名单检查

    /// 检查应用是否在黑名单中
    func isBlacklisted(_ bundleId: String?) -> Bool {
        guard let bundleId = bundleId else {
            return false
        }
        return BlacklistDAO.shared.contains(bundleId: bundleId)
    }

    /// 检查当前前台应用是否在黑名单中
    func isCurrentAppBlacklisted() -> Bool {
        return isBlacklisted(getFrontmostApp())
    }

    // MARK: - 权限检查

    /// 检查是否有辅助功能权限
    func hasAccessibilityPermission() -> Bool {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: false]
        let accessEnabled = AXIsProcessTrustedWithOptions(options as CFDictionary)
        return accessEnabled
    }

    /// 请求辅助功能权限
    func requestAccessibilityPermission() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        _ = AXIsProcessTrustedWithOptions(options as CFDictionary)
    }

    // MARK: - 应用信息

    /// 根据 Bundle ID 获取应用名称
    func getAppName(for bundleId: String) -> String? {
        let workspace = NSWorkspace.shared
        let runningApps = workspace.runningApplications

        if let app = runningApps.first(where: { $0.bundleIdentifier == bundleId }) {
            return app.localizedName
        }

        return nil
    }

    /// 根据 Bundle ID 获取应用图标
    func getAppIcon(for bundleId: String) -> NSImage? {
        let workspace = NSWorkspace.shared
        let runningApps = workspace.runningApplications

        if let app = runningApps.first(where: { $0.bundleIdentifier == bundleId }) {
            return app.icon
        }

        return nil
    }

    /// 获取所有运行中的应用 Bundle ID
    func getAllRunningApps() -> [String] {
        let workspace = NSWorkspace.shared
        let runningApps = workspace.runningApplications

        return runningApps.compactMap { $0.bundleIdentifier }
    }
}
