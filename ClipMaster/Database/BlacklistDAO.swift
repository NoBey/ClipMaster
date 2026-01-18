//
//  BlacklistDAO.swift
//  ClipMaster
//
//  黑名单应用数据访问对象
//

import Foundation

/// 黑名单应用数据访问对象
class BlacklistDAO {

    /// 单例实例
    static let shared = BlacklistDAO()

    private init() {}

    // MARK: - 插入操作

    /// 插入黑名单应用
    func insert(bundleId: String, appName: String? = nil) -> Bool {
        let sql = "INSERT OR IGNORE INTO blacklist_apps (bundle_id, app_name) VALUES (?, ?);"

        var statement: OpaquePointer?
        let db = DatabaseManager.shared

        guard sqlite3_prepare_v2(db.dbPointer, sql, -1, &statement, nil) == SQLITE_OK else {
            return false
        }

        sqlite3_bind_text(statement, 1, (bundleId as NSString).utf8String, -1, nil)

        if let appName = appName {
            sqlite3_bind_text(statement, 2, (appName as NSString).utf8String, -1, nil)
        } else {
            sqlite3_bind_null(statement, 2)
        }

        let result = sqlite3_step(statement) == SQLITE_DONE
        sqlite3_finalize(statement)

        return result
    }

    // MARK: - 查询操作

    /// 查询所有黑名单应用
    func fetchAll() -> [BlacklistApp] {
        let sql = "SELECT * FROM blacklist_apps ORDER BY added_at DESC;"

        var statement: OpaquePointer?
        let db = DatabaseManager.shared
        var apps: [BlacklistApp] = []

        guard sqlite3_prepare_v2(db.dbPointer, sql, -1, &statement, nil) == SQLITE_OK else {
            return apps
        }

        while sqlite3_step(statement) == SQLITE_ROW {
            if let app = createBlacklistApp(from: statement) {
                apps.append(app)
            }
        }

        sqlite3_finalize(statement)
        return apps
    }

    /// 检查应用是否在黑名单中
    func contains(bundleId: String) -> Bool {
        let sql = "SELECT id FROM blacklist_apps WHERE bundle_id = ? LIMIT 1;"

        var statement: OpaquePointer?
        let db = DatabaseManager.shared

        guard sqlite3_prepare_v2(db.dbPointer, sql, -1, &statement, nil) == SQLITE_OK else {
            return false
        }

        sqlite3_bind_text(statement, 1, (bundleId as NSString).utf8String, -1, nil)

        let result = sqlite3_step(statement) == SQLITE_ROW
        sqlite3_finalize(statement)

        return result
    }

    // MARK: - 删除操作

    /// 从黑名单中移除应用
    func delete(bundleId: String) -> Bool {
        let sql = "DELETE FROM blacklist_apps WHERE bundle_id = ?;"

        var statement: OpaquePointer?
        let db = DatabaseManager.shared

        guard sqlite3_prepare_v2(db.dbPointer, sql, -1, &statement, nil) == SQLITE_OK else {
            return false
        }

        sqlite3_bind_text(statement, 1, (bundleId as NSString).utf8String, -1, nil)

        let result = sqlite3_step(statement) == SQLITE_DONE
        sqlite3_finalize(statement)

        return result
    }

    /// 清空黑名单
    func deleteAll() -> Bool {
        let sql = "DELETE FROM blacklist_apps;"
        return DatabaseManager.shared.executeSQL(sql)
    }

    // MARK: - 辅助方法

    /// 从查询结果创建 BlacklistApp 对象
    private func createBlacklistApp(from statement: OpaquePointer?) -> BlacklistApp? {
        guard let statement = statement else { return nil }

        let id = sqlite3_column_int64(statement, 0)
        let bundleId = String(cString: sqlite3_column_text(statement, 1))

        let appName = sqlite3_column_text(statement, 2).map { String(cString: $0) }

        let addedAt = sqlite3_column_int64(statement, 3)
        let date = Date(timeIntervalSince1970: TimeInterval(addedAt))

        return BlacklistApp(
            id: id,
            bundleId: bundleId,
            appName: appName,
            addedAt: date
        )
    }
}
