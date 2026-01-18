//
//  ClipType.swift
//  ClipMaster
//
//  剪切板数据类型枚举
//

import Foundation

/// 剪切板数据类型
enum ClipType: String, Codable, CaseIterable {
    case text       = "text"       // 纯文本
    case image      = "image"      // 图片
    case rtf        = "rtf"        // 富文本
    case file       = "file"       // 文件路径
    case url        = "url"        // 链接
    case color      = "color"      // 颜色代码
    case unknown    = "unknown"    // 未知类型

    /// 显示名称
    var displayName: String {
        switch self {
        case .text: return "文本"
        case .image: return "图片"
        case .rtf: return "富文本"
        case .file: return "文件"
        case .url: return "链接"
        case .color: return "颜色"
        case .unknown: return "其他"
        }
    }

    /// 图标名称 (SF Symbol)
    var iconName: String {
        switch self {
        case .text: return "doc.plaintext"
        case .image: return "photo"
        case .rtf: return "doc.text"
        case .file: return "doc"
        case .url: return "link"
        case .color: return "paintpalette"
        case .unknown: return "doc.on.doc"
        }
    }
}
