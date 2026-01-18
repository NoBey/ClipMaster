//
//  StatusBarManager.swift
//  ClipMaster
//
//  状态栏管理器
//

import AppKit

/// 状态栏管理器
class StatusBarManager {

    /// 单例实例
    static let shared = StatusBarManager()

    /// NSStatusItem 实例
    private var statusItem: NSStatusItem?

    /// Popover 管理器
    private let popoverManager = PopoverManager.shared

    private init() {
        setupStatusBar()
    }

    // MARK: - 设置状态栏

    /// 配置状态栏图标
    private func setupStatusBar() {
        // 创建状态栏按钮
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            // 设置图标
            button.image = NSImage(
                systemSymbolName: "doc.on.clipboard",
                accessibilityDescription: "ClipMaster"
            )

            // 设置图标大小
            button.image?.isTemplate = true  // 适应深色/浅色模式

            // 设置点击事件
            button.action = #selector(statusBarButtonClicked)
            button.target = self
        }

        print("✅ 状态栏图标已创建")
    }

    // MARK: - 点击事件

    /// 状态栏按钮点击事件
    @objc private func statusBarButtonClicked() {
        guard let button = statusItem?.button else {
            return
        }

        // 切换 Popover 显示状态
        popoverManager.toggle(from: button)
    }

    // MARK: - 公开方法

    /// 显示 Popover
    func showPopover() {
        guard let button = statusItem?.button else {
            return
        }
        popoverManager.show(from: button)
    }

    /// 隐藏 Popover
    func hidePopover() {
        popoverManager.hide()
    }

    /// 销毁状态栏图标
    func destroy() {
        if let statusItem = statusItem {
            NSStatusBar.system.removeStatusItem(statusItem)
            self.statusItem = nil
        }
    }

    /// 更新状态栏图标 (可选)
    func updateIcon(hasNewContent: Bool) {
        if let button = statusItem?.button {
            if hasNewContent {
                // 有新内容时显示不同的图标或颜色
                button.image = NSImage(
                    systemSymbolName: "doc.on.clipboard.fill",
                    accessibilityDescription: "ClipMaster - New Content"
                )
            } else {
                // 默认图标
                button.image = NSImage(
                    systemSymbolName: "doc.on.clipboard",
                    accessibilityDescription: "ClipMaster"
                )
            }
        }
    }
}
