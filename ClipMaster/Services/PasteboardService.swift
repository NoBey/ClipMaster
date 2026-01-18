//
//  PasteboardService.swift
//  ClipMaster
//
//  NSPasteboard 封装服务
//

import AppKit

/// 剪切板服务
class PasteboardService {

    /// 单例实例
    static let shared = PasteboardService()

    /// 系统剪切板
    private let pasteboard: NSPasteboard

    /// 上次的 changeCount
    private var lastChangeCount: Int = 0

    private init() {
        pasteboard = NSPasteboard.general
        lastChangeCount = pasteboard.changeCount
    }

    // MARK: - 检查变化

    /// 检查剪切板是否有新内容
    func hasNewContent() -> Bool {
        let currentCount = pasteboard.changeCount
        if currentCount != lastChangeCount {
            lastChangeCount = currentCount
            return true
        }
        return false
    }

    // MARK: - 提取内容

    /// 从剪切板提取剪切板项目
    func extractClipItem() -> ClipItem? {
        // 优先级 1: 提取文本
        if let string = pasteboard.string(forType: .string) {
            // 检测文本类型
            let type = ContentTypeDetector.shared.detectType(for: string)

            // 如果是图片数据,尝试提取图片
            if type == .image, let imageData = extractImage() {
                return ClipItem(
                    content: string,
                    type: .image,
                    timestamp: Date(),
                    previewImage: imageData
                )
            }

            return ClipItem(
                content: string,
                type: type,
                timestamp: Date()
            )
        }

        // 优先级 2: 提取图片
        if let imageData = extractImage() {
            return ClipItem(
                content: "[图片]",
                type: .image,
                timestamp: Date(),
                previewImage: imageData
            )
        }

        // 优先级 3: 提取文件路径
        if let fileURLs = pasteboard.readObjects(forClasses: [NSURL.self], options: nil) as? [URL] {
            let paths = fileURLs.map { $0.path }.joined(separator: "\n")
            return ClipItem(
                content: paths,
                type: .file,
                timestamp: Date()
            )
        }

        return nil
    }

    /// 提取图片数据
    private func extractImage() -> Data? {
        guard let imageData = pasteboard.data(forType: .png) ??
                      pasteboard.data(forType: .tiff) else {
            return nil
        }
        return imageData
    }

    // MARK: - 复制操作

    /// 复制内容到剪切板
    func copyToPasteboard(_ item: ClipItem) {
        pasteboard.clearContents()

        switch item.type {
        case .text, .url, .color, .unknown:
            pasteboard.setString(item.content, forType: .string)

        case .image:
            if let imageData = item.previewImage {
                pasteboard.setData(imageData, forType: .png)
            }

        case .file:
            if let fileURLs = item.content.split(separator: "\n").map({
                URL(fileURLWithPath: String($0))
            }) as [URL]? {
                pasteboard.writeObjects(fileURLs as [NSURL])
            }

        case .rtf:
            pasteboard.setString(item.content, forType: .string)
            // TODO: 支持富文本格式

        }

        // 更新 changeCount
        lastChangeCount = pasteboard.changeCount
    }

    /// 复制文本到剪切板
    func copyText(_ text: String) {
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
        lastChangeCount = pasteboard.changeCount
    }
}
