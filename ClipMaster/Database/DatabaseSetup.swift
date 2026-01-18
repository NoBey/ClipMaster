//
//  DatabaseSetup.swift
//  ClipMaster
//
//  数据库初始化和设置
//

import Foundation

/// 数据库设置辅助类
class DatabaseSetup {

    /// 初始化数据库
    static func setup() {
        let db = DatabaseManager.shared

        // 插入默认黑名单应用
        insertDefaultBlacklistApps()
    }

    /// 插入默认的黑名单应用
    private static func insertDefaultBlacklistApps() {
        let defaultApps: [(bundleId: String, appName: String)] = [
            ("com.1password.1password", "1Password"),
            ("com.agilebits.onepassword7", "1Password 7"),
            ("com.apple.keychain", "Keychain Access"),
            ("com.bitwarden.desktop", "Bitwarden"),
            ("com.lastpass.lastpass", "LastPass"),
            ("com.dashlane.dashlanepairing", "Dashlane"),
            (" Keeper Security Inc.Keeper", "Keeper")
        ]

        for app in defaultApps {
            BlacklistDAO.shared.insert(bundleId: app.bundleId, appName: app.appName)
        }

        print("✅ 默认黑名单应用已添加")
    }

    /// 检查数据库是否需要升级
    static func checkDatabaseVersion() -> Bool {
        // 未来可以用于数据库版本管理和迁移
        return true
    }

    /// 清理旧数据 (超过 30 天)
    static func cleanupOldData() {
        let thirtyDaysAgo = Date().addingTimeInterval(-30 * 24 * 60 * 60)
        let timestamp = Int64(thirtyDaysAgo.timeIntervalSince1970)

        let sql = "DELETE FROM clips WHERE timestamp < ? AND is_pinned = 0;"
        _ = DatabaseManager.shared.executeSQL(sql) // 这里需要支持绑定参数

        print("✅ 旧数据清理完成")
    }
}
