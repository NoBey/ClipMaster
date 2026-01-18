//
//  ClipListViewModel.swift
//  ClipMaster
//
//  剪切板列表视图模型
//

import Foundation
import Combine

/// 剪切板列表视图模型
class ClipListViewModel: ObservableObject {

    /// 所有剪切板项目
    @Published private(set) var clips: [ClipItem] = []

    /// 过滤后的剪切板项目
    @Published private(set) var filteredClips: [ClipItem] = []

    /// 搜索文本
    @Published var searchText: String = "" {
        didSet {
            updateFilteredClips()
        }
    }

    /// 选中的类型过滤器
    @Published var selectedType: ClipType? = nil {
        didSet {
            updateFilteredClips()
        }
    }

    /// 数据访问对象
    private let dao = ClipItemDAO.shared

    /// 剪切板服务
    private let pasteboardService = PasteboardService.shared

    /// 监听器
    private var monitor: ClipboardMonitor {
        ClipboardMonitor.shared
    }

    /// Combine 订阅
    private var cancellables = Set<AnyCancellable>()

    init() {
        // 加载数据
        loadClips()

        // 监听剪切板更新
        NotificationCenter.default.publisher(for: .clipDidUpdate)
            .sink { [weak self] _ in
                self?.loadClips()
            }
            .store(in: &cancellables)
    }

    // MARK: - 加载数据

    /// 加载剪切板项目
    func loadClips() {
        clips = dao.fetchAll(limit: 1000)
        updateFilteredClips()
    }

    /// 刷新数据
    func refresh() {
        loadClips()
    }

    // MARK: - 过滤逻辑

    /// 更新过滤后的列表
    private func updateFilteredClips() {
        filteredClips = clips.filter { clip in
            // 类型过滤
            if let type = selectedType {
                if clip.type != type {
                    return false
                }
            }

            // 搜索过滤
            if !searchText.isEmpty {
                return clip.content.localizedCaseInsensitiveContains(searchText)
            }

            return true
        }
    }

    // MARK: - 操作

    /// 复制项目到剪切板
    func copyToClipboard(_ item: ClipItem) {
        pasteboardService.copyToPasteboard(item)
        print("✅ 已复制: \(item.content.prefix(20))...")
    }

    /// 切换置顶状态
    func togglePin(_ item: ClipItem) {
        let newPinnedStatus = !item.isPinned
        let success = dao.updatePinnedStatus(id: item.id, isPinned: newPinnedStatus)

        if success {
            // 更新本地数据
            if let index = clips.firstIndex(where: { $0.id == item.id }) {
                clips[index].isPinned = newPinnedStatus
            }
            updateFilteredClips()
            print("✅ 置顶状态已更新: \(newPinnedStatus)")
        }
    }

    /// 删除项目
    func delete(_ item: ClipItem) {
        let success = dao.delete(id: item.id)

        if success {
            // 从列表中移除
            clips.removeAll { $0.id == item.id }
            updateFilteredClips()
            print("✅ 已删除: \(item.content.prefix(20))...")
        }
    }

    /// 清空所有历史记录
    func clearAllHistory() {
        let success = dao.deleteAll()

        if success {
            clips.removeAll()
            filteredClips.removeAll()
            print("✅ 所有历史记录已清空")
        }
    }

    /// 处理点击项目
    func handleClick(_ item: ClipItem) {
        // 点击项目直接复制
        copyToClipboard(item)
    }
}
