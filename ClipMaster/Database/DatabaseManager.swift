//
//  DatabaseManager.swift
//  ClipMaster
//
//  SQLite 数据库连接管理器
//

import Foundation
import SQLite3

/// 数据库管理器单例
class DatabaseManager {
    /// 单例实例
    static let shared = DatabaseManager()

    /// 数据库连接指针
    private var db: OpaquePointer?

    /// 提供数据库连接指针给 DAO 使用
    var dbPointer: OpaquePointer? {
        return db
    }

    /// 数据库文件路径
    private let dbPath: String

    /// 初始化
    private init() {
        // 获取 Application Support 目录
        let paths = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
        let appSupportDir = paths.first!

        // 创建 ClipMaster 子目录
        let clipMasterDir = appSupportDir.appending("/ClipMaster")
        let fileManager = FileManager.default

        // 如果目录不存在则创建
        if !fileManager.fileExists(atPath: clipMasterDir) {
            try? fileManager.createDirectory(atPath: clipMasterDir, withIntermediateDirectories: true, attributes: nil)
        }

        // 数据库文件路径
        dbPath = clipMasterDir.appending("/clipmaster.db")

        // 打开数据库
        openDatabase()
    }

    /// 打开数据库连接
    private func openDatabase() {
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            print("✅ 数据库连接成功: \(dbPath)")
            // 创建表结构
            createTables()
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("❌ 数据库连接失败: \(errorMessage)")
        }
    }

    /// 关闭数据库连接
    func closeDatabase() {
        if sqlite3_close(db) == SQLITE_OK {
            print("✅ 数据库连接已关闭")
            db = nil
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("❌ 数据库关闭失败: \(errorMessage)")
        }
    }

    /// 创建表结构
    private func createTables() {
        // 创建 clips 表
        let createClipsTableSQL = """
        CREATE TABLE IF NOT EXISTS clips (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            content TEXT NOT NULL,
            content_type TEXT NOT NULL,
            source_app TEXT,
            timestamp INTEGER NOT NULL,
            is_pinned INTEGER DEFAULT 0,
            preview_image BLOB,
            metadata TEXT,
            created_at INTEGER DEFAULT (strftime('%s', 'now'))
        );

        CREATE INDEX IF NOT EXISTS idx_clips_timestamp ON clips(timestamp DESC);
        CREATE INDEX IF NOT EXISTS idx_clips_type ON clips(content_type);
        CREATE INDEX IF NOT EXISTS idx_clips_pinned ON clips(is_pinned DESC);
        """

        // 创建 blacklist_apps 表
        let createBlacklistTableSQL = """
        CREATE TABLE IF NOT EXISTS blacklist_apps (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            bundle_id TEXT UNIQUE NOT NULL,
            app_name TEXT,
            added_at INTEGER DEFAULT (strftime('%s', 'now'))
        );

        CREATE INDEX IF NOT EXISTS idx_blacklist_bundle ON blacklist_apps(bundle_id);
        """

        executeSQL(createClipsTableSQL)
        executeSQL(createBlacklistTableSQL)
    }

    /// 执行 SQL 语句 (无返回值)
    func executeSQL(_ sql: String) -> Bool {
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                sqlite3_finalize(statement)
                return true
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("❌ SQL 执行失败: \(errorMessage)")
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("❌ SQL 准备失败: \(errorMessage)")
        }

        sqlite3_finalize(statement)
        return false
    }

    /// 执行查询 SQL (有返回值)
    func executeQuery(_ sql: String, bindings: [Any] = []) -> [[String: Any]] {
        var statement: OpaquePointer?
        var results: [[String: Any]] = []

        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
            // 绑定参数
            for (index, binding) in bindings.enumerated() {
                let paramIndex = Int32(index + 1)

                switch binding {
                case let text as String:
                    sqlite3_bind_text(statement, paramIndex, (text as NSString).utf8String, -1, nil)
                case let number as Int:
                    sqlite3_bind_int64(statement, paramIndex, Int64(number))
                case let number as Int64:
                    sqlite3_bind_int64(statement, paramIndex, number)
                case let data as Data:
                    data.withUnsafeBytes { bytes in
                        sqlite3_bind_blob(statement, paramIndex, bytes.baseAddress, Int32(data.count), nil)
                    }
                case let number as Double:
                    sqlite3_bind_double(statement, paramIndex, number)
                default:
                    break
                }
            }

            // 遍历结果集
            while sqlite3_step(statement) == SQLITE_ROW {
                var row: [String: Any] = [:]
                let columnCount = sqlite3_column_count(statement)

                for i in 0..<columnCount {
                    let name = String(cString: sqlite3_column_name(statement, i))
                    let type = sqlite3_column_type(statement, i)

                    switch type {
                    case SQLITE_TEXT:
                        let value = String(cString: sqlite3_column_text(statement, i))
                        row[name] = value
                    case SQLITE_INTEGER:
                        let value = sqlite3_column_int64(statement, i)
                        row[name] = Int(value)
                    case SQLITE_FLOAT:
                        let value = sqlite3_column_double(statement, i)
                        row[name] = Double(value)
                    case SQLITE_BLOB:
                        let data = sqlite3_column_blob(statement, i)
                        let size = sqlite3_column_bytes(statement, i)
                        if let data = data {
                            row[name] = Data(bytes: data, count: Int(size))
                        }
                    case SQLITE_NULL:
                        row[name] = nil
                    default:
                        break
                    }
                }

                results.append(row)
            }
        }

        sqlite3_finalize(statement)
        return results
    }

    /// 获取最后插入的 ID
    func lastInsertRowId() -> Int64 {
        return sqlite3_last_insert_rowid(db)
    }

    /// 删除所有数据 (用于测试或重置)
    func deleteAllData() {
        executeSQL("DELETE FROM clips;")
        executeSQL("DELETE FROM blacklist_apps;")
        print("⚠️ 所有数据已清除")
    }
}
