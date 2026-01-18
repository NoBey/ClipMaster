//
//  ContentTypeDetector.swift
//  ClipMaster
//
//  内容类型智能识别工具
//

import Foundation
import AppKit

/// 内容类型检测器
class ContentTypeDetector {

    /// 单例实例
    static let shared = ContentTypeDetector()

    private init() {}

    // MARK: - 类型检测

    /// 检测内容的类型
    func detectType(for content: String) -> ClipType {
        // 空内容
        if content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return .unknown
        }

        // 优先级 1: URL 检测
        if isURL(content) {
            return .url
        }

        // 优先级 2: 颜色代码检测
        if isColor(content) {
            return .color
        }

        // 优先级 3: 文件路径检测
        if isFilePath(content) {
            return .file
        }

        // 默认为文本
        return .text
    }

    // MARK: - URL 检测

    /// 检查是否为 URL
    private func isURL(_ content: String) -> Bool {
        // URL 正则表达式
        let urlPattern = #"^(https?|ftp)://[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$"#

        let regex = try? NSRegularExpression(pattern: urlPattern, options: [])
        let range = NSRange(location: 0, length: content.utf16.count)
        let matches = regex?.firstMatch(in: content, options: [], range: range)

        return matches != nil
    }

    // MARK: - 颜色代码检测

    /// 检查是否为颜色代码
    private func isColor(_ content: String) -> Bool {
        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)

        // HEX 颜色: #RGB 或 #RRGGBB
        if isHexColor(trimmed) {
            return true
        }

        // RGB 颜色: rgb(r, g, b) 或 rgba(r, g, b, a)
        if isRGBColor(trimmed) {
            return true
        }

        return false
    }

    /// 检查是否为 HEX 颜色
    private func isHexColor(_ content: String) -> Bool {
        let hexPattern = "^#([0-9A-Fa-f]{3}|[0-9A-Fa-f]{6})$"
        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)

        return trimmed.range(of: hexPattern, options: .regularExpression) != nil
    }

    /// 检查是否为 RGB 颜色
    private func isRGBColor(_ content: String) -> Bool {
        // rgb(r, g, b)
        let rgbPattern = "^rgb\\(\\s*\\d+\\s*,\\s*\\d+\\s*,\\s*\\d+\\s*\\)$"
        // rgba(r, g, b, a)
        let rgbaPattern = "^rgba\\(\\s*\\d+\\s*,\\s*\\d+\\s*,\\s*\\d+\\s*,\\s*[0-9.]+\\s*\\)$"

        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)

        return trimmed.range(of: rgbPattern, options: .regularExpression) != nil ||
               trimmed.range(of: rgbaPattern, options: .regularExpression) != nil
    }

    // MARK: - 文件路径检测

    /// 检查是否为文件路径
    private func isFilePath(_ content: String) -> Bool {
        // macOS 文件路径通常以 / 开头
        // 或者包含 ~ (用户目录)
        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.hasPrefix("/") || trimmed.hasPrefix("~") {
            return true
        }

        // 检查是否包含文件扩展名
        let fileExtensionPattern = #"^.+\.[a-zA-Z0-9]{2,4}$"#
        if trimmed.range(of: fileExtensionPattern, options: .regularExpression) != nil {
            // 排除 URL
            if !trimmed.contains("://") {
                return true
            }
        }

        return false
    }

    // MARK: - 颜色转换

    /// 将颜色代码转换为 NSColor
    func colorFromCode(_ code: String) -> NSColor? {
        let trimmed = code.trimmingCharacters(in: .whitespacesAndNewlines)

        // HEX 颜色
        if trimmed.hasPrefix("#") {
            return hexToColor(trimmed)
        }

        // RGB 颜色
        if trimmed.lowercased().hasPrefix("rgb") {
            return rgbToColor(trimmed)
        }

        return nil
    }

    /// HEX 颜色转 NSColor
    private func hexToColor(_ hex: String) -> NSColor? {
        var colorCode = hex
        colorCode.removeFirst()

        var rgb: UInt64 = 0
        Scanner(string: colorCode).scanHexInt64(&rgb)

        let r, g, b: CGFloat
        if colorCode.count == 6 {
            // #RRGGBB
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        } else {
            // #RGB
            r = CGFloat((rgb & 0xF00) >> 8) / 15.0
            g = CGFloat((rgb & 0x0F0) >> 4) / 15.0
            b = CGFloat(rgb & 0x00F) / 15.0
        }

        return NSColor(red: r, green: g, blue: b, alpha: 1.0)
    }

    /// RGB 颜色转 NSColor
    private func rgbToColor(_ rgb: String) -> NSColor? {
        // 提取数字
        let pattern = #"(\d+)"#
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: rgb.utf16.count)

        guard let matches = regex?.matches(in: rgb, options: [], range: range),
              matches.count >= 3 else {
            return nil
        }

        func extractValue(at index: Int) -> CGFloat? {
            guard let range = Range(matches[index].range, in: rgb),
                  let value = Int(rgb[range]) else {
                return nil
            }
            return CGFloat(value) / 255.0
        }

        guard let r = extractValue(at: 0),
              let g = extractValue(at: 1),
              let b = extractValue(at: 2) else {
            return nil
        }

        var a: CGFloat = 1.0
        if matches.count >= 4, let alpha = extractValue(at: 3) {
            a = alpha
        }

        return NSColor(red: r, green: g, blue: b, alpha: a)
    }

    // MARK: - URL 解析

    /// 从 URL 中提取域名
    func extractDomain(from url: String) -> String? {
        guard let urlObj = URL(string: url) else { return nil }
        return urlObj.host
    }
}
