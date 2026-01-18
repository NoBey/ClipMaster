//
//  ClipItem.swift
//  ClipMaster
//
//  剪切板项目数据模型
//

import Foundation
import SwiftUI

/// 剪切板项目数据模型
struct ClipItem: Identifiable, Codable {
    /// 数据库 ID
    let id: Int64

    /// 内容主体
    var content: String

    /// 数据类型
    var type: ClipType

    /// 来源应用 Bundle ID
    var sourceApp: String?

    /// 记录时间
    var timestamp: Date

    /// 是否置顶
    var isPinned: Bool

    /// 图片预览数据 (可选)
    var previewImage: Data?

    /// 额外元数据 (JSON 字符串)
    var metadata: String?

    /// 构造函数
    init(
        id: Int64 = 0,
        content: String,
        type: ClipType,
        sourceApp: String? = nil,
        timestamp: Date = Date(),
        isPinned: Bool = false,
        previewImage: Data? = nil,
        metadata: String? = nil
    ) {
        self.id = id
        self.content = content
        self.type = type
        self.sourceApp = sourceApp
        self.timestamp = timestamp
        self.isPinned = isPinned
        self.previewImage = previewImage
        self.metadata = metadata
    }

    /// 解析元数据为字典
    var metadataDict: [String: Any]? {
        guard let metadata = metadata,
              let data = metadata.data(using: .utf8),
              let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }
        return dict
    }

    /// 显示文本 (截断过长的内容)
    var displayText: String {
        let maxLength = 100
        if content.count > maxLength {
            let index = content.index(content.startIndex, offsetBy: maxLength)
            return String(content[..<index]) + "..."
        }
        return content.isEmpty ? "(空内容)" : content
    }

    /// 格式化的时间显示
    var formattedTime: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }

    /// 类型图标
    var icon: Image {
        Image(systemName: type.iconName)
    }

    /// 来源应用名称 (从 Bundle ID 提取)
    var sourceAppName: String {
        guard let bundleId = sourceApp else { return "未知应用" }
        // 从 Bundle ID 中提取应用名称
        let components = bundleId.split(separator: ".")
        if let appName = components.last {
            return String(appName).capitalized
        }
        return bundleId
    }
}

/// 扩展: Codable 支持 (处理 Data 类型的 previewImage)
extension ClipItem {
    enum CodingKeys: String, CodingKey {
        case id
        case content
        case type
        case sourceApp
        case timestamp
        case isPinned
        case previewImage
        case metadata
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int64.self, forKey: .id)
        content = try container.decode(String.self, forKey: .content)
        type = try container.decode(ClipType.self, forKey: .type)
        sourceApp = try container.decodeIfPresent(String.self, forKey: .sourceApp)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
        isPinned = try container.decode(Bool.self, forKey: .isPinned)
        previewImage = try container.decodeIfPresent(Data.self, forKey: .previewImage)
        metadata = try container.decodeIfPresent(String.self, forKey: .metadata)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(content, forKey: .content)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(sourceApp, forKey: .sourceApp)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(isPinned, forKey: .isPinned)
        try container.encodeIfPresent(previewImage, forKey: .previewImage)
        try container.encodeIfPresent(metadata, forKey: .metadata)
    }
}
