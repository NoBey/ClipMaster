//
//  ClipItemDAO.swift
//  ClipMaster
//
//  剪切板项目数据访问对象
//

import Foundation

/// 剪切板项目数据访问对象
class ClipItemDAO {

    /// 单例实例
    static let shared = ClipItemDAO()

    private init() {}

    // MARK: - 插入操作

    /// 插入新的剪切板项目
    func insert(_ item: ClipItem) -> Bool {
        let sql = """
        INSERT INTO clips (content, content_type, source_app, timestamp, is_pinned, preview_image, metadata)
        VALUES (?, ?, ?, ?, ?, ?, ?);
        """

        var statement: OpaquePointer?
        let db = DatabaseManager.shared

        guard sqlite3_prepare_v2(db.dbPointer, sql, -1, &statement, nil) == SQLITE_OK else {
            let errorMessage = String(cString: sqlite3_errmsg(db.dbPointer))
            print("❌ 插入 clips 准备失败: \(errorMessage)")
            return false
        }

        // 绑定参数
        sqlite3_bind_text(statement, 1, (item.content as NSString).utf8String, -1, nil)
        sqlite3_bind_text(statement, 2, (item.type.rawValue as NSString).utf8String, -1, nil)

        if let sourceApp = item.sourceApp {
            sqlite3_bind_text(statement, 3, (sourceApp as NSString).utf8String, -1, nil)
        } else {
            sqlite3_bind_null(statement, 3)
        }

        sqlite3_bind_int64(statement, 4, Int64(item.timestamp.timeIntervalSince1970))
        sqlite3_bind_int(statement, 5, item.isPinned ? 1 : 0)

        if let previewImage = item.previewImage {
            previewImage.withUnsafeBytes { bytes in
                sqlite3_bind_blob(statement, 6, bytes.baseAddress, Int32(previewImage.count), nil)
            }
        } else {
            sqlite3_bind_null(statement, 6)
        }

        if let metadata = item.metadata {
            sqlite3_bind_text(statement, 7, (metadata as NSString).utf8String, -1, nil)
        } else {
            sqlite3_bind_null(statement, 7)
        }

        // 执行
        let result = sqlite3_step(statement) == SQLITE_DONE
        sqlite3_finalize(statement)

        if result {
            print("✅ 插入剪切板项目成功: \(item.content.prefix(20))...")
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db.dbPointer))
            print("❌ 插入剪切板项目失败: \(errorMessage)")
        }

        return result
    }

    // MARK: - 查询操作

    /// 查询所有剪切板项目 (按时间倒序,置顶优先)
    func fetchAll(limit: Int = 100) -> [ClipItem] {
        let sql = """
        SELECT * FROM clips
        ORDER BY is_pinned DESC, timestamp DESC
        LIMIT ?;
        """

        var statement: OpaquePointer?
        let db = DatabaseManager.shared
        var items: [ClipItem] = []

        guard sqlite3_prepare_v2(db.dbPointer, sql, -1, &statement, nil) == SQLITE_OK else {
            return items
        }

        sqlite3_bind_int64(statement, 1, Int64(limit))

        while sqlite3_step(statement) == SQLITE_ROW {
            if let item = createClipItem(from: statement) {
                items.append(item)
            }
        }

        sqlite3_finalize(statement)
        return items
    }

    /// 根据类型查询
    func fetchByType(_ type: ClipType, limit: Int = 100) -> [ClipItem] {
        let sql = """
        SELECT * FROM clips
        WHERE content_type = ?
        ORDER BY is_pinned DESC, timestamp DESC
        LIMIT ?;
        """

        var statement: OpaquePointer?
        let db = DatabaseManager.shared
        var items: [ClipItem] = []

        guard sqlite3_prepare_v2(db.dbPointer, sql, -1, &statement, nil) == SQLITE_OK else {
            return items
        }

        sqlite3_bind_text(statement, 1, (type.rawValue as NSString).utf8String, -1, nil)
        sqlite3_bind_int64(statement, 2, Int64(limit))

        while sqlite3_step(statement) == SQLITE_ROW {
            if let item = createClipItem(from: statement) {
                items.append(item)
            }
        }

        sqlite3_finalize(statement)
        return items
    }

    /// 根据关键字搜索
    func searchByKeyword(_ keyword: String, limit: Int = 100) -> [ClipItem] {
        let sql = """
        SELECT * FROM clips
        WHERE content LIKE ?
        ORDER BY is_pinned DESC, timestamp DESC
        LIMIT ?;
        """

        var statement: OpaquePointer?
        let db = DatabaseManager.shared
        var items: [ClipItem] = []

        guard sqlite3_prepare_v2(db.dbPointer, sql, -1, &statement, nil) == SQLITE_OK else {
            return items
        }

        let searchPattern = "%\(keyword)%"
        sqlite3_bind_text(statement, 1, (searchPattern as NSString).utf8String, -1, nil)
        sqlite3_bind_int64(statement, 2, Int64(limit))

        while sqlite3_step(statement) == SQLITE_ROW {
            if let item = createClipItem(from: statement) {
                items.append(item)
            }
        }

        sqlite3_finalize(statement)
        return items
    }

    /// 根据类型和关键字搜索
    func searchByKeywordAndType(_ keyword: String, type: ClipType?, limit: Int = 100) -> [ClipItem] {
        if let type = type {
            // 同时搜索类型和关键字
            let sql = """
            SELECT * FROM clips
            WHERE content_type = ? AND content LIKE ?
            ORDER BY is_pinned DESC, timestamp DESC
            LIMIT ?;
            """

            var statement: OpaquePointer?
            let db = DatabaseManager.shared
            var items: [ClipItem] = []

            guard sqlite3_prepare_v2(db.dbPointer, sql, -1, &statement, nil) == SQLITE_OK else {
                return items
            }

            sqlite3_bind_text(statement, 1, (type.rawValue as NSString).utf8String, -1, nil)

            let searchPattern = "%\(keyword)%"
            sqlite3_bind_text(statement, 2, (searchPattern as NSString).utf8String, -1, nil)
            sqlite3_bind_int64(statement, 3, Int64(limit))

            while sqlite3_step(statement) == SQLITE_ROW {
                if let item = createClipItem(from: statement) {
                    items.append(item)
                }
            }

            sqlite3_finalize(statement)
            return items
        } else {
            return searchByKeyword(keyword, limit: limit)
        }
    }

    // MARK: - 更新操作

    /// 更新置顶状态
    func updatePinnedStatus(id: Int64, isPinned: Bool) -> Bool {
        let sql = "UPDATE clips SET is_pinned = ? WHERE id = ?;"

        var statement: OpaquePointer?
        let db = DatabaseManager.shared

        guard sqlite3_prepare_v2(db.dbPointer, sql, -1, &statement, nil) == SQLITE_OK else {
            return false
        }

        sqlite3_bind_int(statement, 1, isPinned ? 1 : 0)
        sqlite3_bind_int64(statement, 2, id)

        let result = sqlite3_step(statement) == SQLITE_DONE
        sqlite3_finalize(statement)

        return result
    }

    // MARK: - 删除操作

    /// 删除指定项目
    func delete(id: Int64) -> Bool {
        let sql = "DELETE FROM clips WHERE id = ?;"

        var statement: OpaquePointer?
        let db = DatabaseManager.shared

        guard sqlite3_prepare_v2(db.dbPointer, sql, -1, &statement, nil) == SQLITE_OK else {
            return false
        }

        sqlite3_bind_int64(statement, 1, id)

        let result = sqlite3_step(statement) == SQLITE_DONE
        sqlite3_finalize(statement)

        return result
    }

    /// 清除所有项目
    func deleteAll() -> Bool {
        let sql = "DELETE FROM clips;"
        return DatabaseManager.shared.executeSQL(sql)
    }

    // MARK: - 辅助方法

    /// 从查询结果创建 ClipItem 对象
    private func createClipItem(from statement: OpaquePointer?) -> ClipItem? {
        guard let statement = statement else { return nil }

        let id = sqlite3_column_int64(statement, 0)

        let content = String(cString: sqlite3_column_text(statement, 1))
        let typeRaw = String(cString: sqlite3_column_text(statement, 2))
        let type = ClipType(rawValue: typeRaw) ?? .unknown

        let sourceApp = sqlite3_column_text(statement, 3).map { String(cString: $0) }

        let timestamp = sqlite3_column_int64(statement, 4)
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))

        let isPinned = sqlite3_column_int(statement, 5) == 1

        var previewImage: Data?
        if sqlite3_column_type(statement, 6) != SQLITE_NULL {
            let data = sqlite3_column_blob(statement, 6)
            let size = sqlite3_column_bytes(statement, 6)
            if let data = data {
                previewImage = Data(bytes: data, count: Int(size))
            }
        }

        let metadata = sqlite3_column_text(statement, 7).map { String(cString: $0) }

        return ClipItem(
            id: id,
            content: content,
            type: type,
            sourceApp: sourceApp,
            timestamp: date,
            isPinned: isPinned,
            previewImage: previewImage,
            metadata: metadata
        )
    }
}
