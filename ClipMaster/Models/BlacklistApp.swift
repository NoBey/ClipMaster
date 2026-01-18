//
//  BlacklistApp.swift
//  ClipMaster
//
//  黑名单应用模型
//

import Foundation

/// 黑名单应用模型
struct BlacklistApp: Identifiable, Codable {
    /// 数据库 ID
    let id: Int64?

    /// 应用 Bundle ID (如 com.1password.1password)
    var bundleId: String

    /// 应用显示名称
    var appName: String?

    /// 添加时间
    var addedAt: Date

    /// 构造函数
    init(
        id: Int64? = nil,
        bundleId: String,
        appName: String? = nil,
        addedAt: Date = Date()
    ) {
        self.id = id
        self.bundleId = bundleId
        self.appName = appName
        self.addedAt = addedAt
    }

    /// 格式化的添加时间
    var formattedAddedTime: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: addedAt)
    }
}
