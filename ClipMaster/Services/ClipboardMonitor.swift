//
//  ClipboardMonitor.swift
//  ClipMaster
//
//  剪切板监听器
//

import Foundation
import Combine

/// 剪切板监听器
class ClipboardMonitor: ObservableObject {

    /// 单例实例
    static let shared = ClipboardMonitor()

    /// 轮询定时器
    private var timer: Timer?

    /// 剪切板服务
    private let pasteboardService = PasteboardService.shared

    /// 应用检测服务
    private let appDetection = AppDetectionService.shared

    /// 数据访问对象
    private let dao = ClipItemDAO.shared

    /// 是否正在监听
    @Published private(set) var isMonitoring = false

    /// 最新的剪切板项目
    @Published private(set) var latestClip: ClipItem?

    /// 轮询间隔 (秒)
    private let pollingInterval: TimeInterval = 0.5

    private init() {}

    // MARK: - 启动/停止监听

    /// 开始监听剪切板
    func startMonitoring() {
        guard !isMonitoring else {
            print("⚠️ 剪切板监听器已在运行")
            return
        }

        print("✅ 启动剪切板监听器")

        // 创建定时器
        timer = Timer.scheduledTimer(
            withTimeInterval: pollingInterval,
            repeats: true
        ) { [weak self] _ in
            self?.checkForChanges()
        }

        isMonitoring = true
    }

    /// 停止监听剪切板
    func stopMonitoring() {
        guard isMonitoring else {
            print("⚠️ 剪切板监听器未在运行")
            return
        }

        print("⏹ 停止剪切板监听器")

        timer?.invalidate()
        timer = nil
        isMonitoring = false
    }

    // MARK: - 检查变化

    /// 检查剪切板是否有新内容
    private func checkForChanges() {
        // 检查是否有新内容
        guard pasteboardService.hasNewContent() else {
            return
        }

        // 获取前台应用
        guard let frontmostApp = appDetection.getFrontmostApp() else {
            return
        }

        // 检查是否在黑名单中
        if appDetection.isBlacklisted(frontmostApp) {
            print("🚫 应用 \(frontmostApp) 在黑名单中,跳过记录")
            return
        }

        // 提取剪切板内容
        guard var clip = pasteboardService.extractClipItem() else {
            print("⚠️ 无法提取剪切板内容")
            return
        }

        // 设置来源应用
        clip.sourceApp = frontmostApp

        // 检查是否重复 (最近 10 秒内是否有相同内容)
        if isDuplicate(clip) {
            print("⚠️ 检测到重复内容,跳过记录")
            return
        }

        // 保存到数据库
        let success = dao.insert(clip)

        if success {
            // 更新最新项目
            DispatchQueue.main.async {
                self.latestClip = clip
            }

            // 发送通知
            NotificationCenter.default.post(
                name: .clipDidUpdate,
                object: clip
            )

            print("✅ 新剪切板项目已记录: \(clip.type.displayName) - \(clip.content.prefix(30))...")
        }
    }

    // MARK: - 重复检测

    /// 检查是否为重复内容
    private func isDuplicate(_ clip: ClipItem) -> Bool {
        // 查询最近 10 秒内的记录
        let tenSecondsAgo = Date().addingTimeInterval(-10)
        let recentClips = dao.fetchAll(limit: 10)

        for recentClip in recentClips {
            // 检查时间是否在 10 秒内
            if recentClip.timestamp > tenSecondsAgo {
                // 检查内容是否相同
                if recentClip.content == clip.content &&
                   recentClip.type == clip.type {
                    return true
                }
            }
        }

        return false
    }

    // MARK: - 手动触发

    /// 手动检查剪切板 (用于测试)
    func manualCheck() {
        checkForChanges()
    }

    /// 清空所有历史记录
    func clearAllHistory() {
        dao.deleteAll()
        print("⚠️ 所有历史记录已清空")
    }
}
