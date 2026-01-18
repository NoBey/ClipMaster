//
//  PopoverManager.swift
//  ClipMaster
//
//  Popover 弹出窗口管理器
//

import AppKit
import SwiftUI

/// Popover 管理器
class PopoverManager {

    /// 单例实例
    static let shared = PopoverManager()

    /// NSPopover 实例
    private(set) var popover: NSPopover?

    /// 事件监听器 (用于监听点击外部区域)
    private var eventMonitor: EventMonitor?

    private init() {
        setupPopover()
    }

    // MARK: - 设置 Popover

    /// 配置 Popover
    private func setupPopover() {
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 600)
        popover.behavior = .transient  // 点击外部区域自动关闭
        popover.contentViewController = NSHostingController(rootView: MainPopoverView())

        // 设置外观
        popover.appearance = NSAppearance(named: .aqua)

        self.popover = popover
    }

    // MARK: - 显示/隐藏

    /// 显示 Popover
    func show(from button: NSStatusBarButton) {
        guard let popover = popover else {
            return
        }

        // 如果已经显示,则不重复显示
        if popover.isShown {
            return
        }

        // 显示 Popover
        popover.show(
            relativeTo: button.bounds,
            of: button,
            preferredEdge: .minY  // 向下弹出
        )

        // 启动事件监听器 (点击外部区域时关闭)
        startEventMonitor()

        // 激活应用,确保 Popover 能响应事件
        NSApp.activate(ignoringOtherApps: true)
    }

    /// 隐藏 Popover
    func hide() {
        guard let popover = popover, popover.isShown else {
            return
        }

        popover.performClose(nil)
        stopEventMonitor()
    }

    /// 切换显示状态
    func toggle(from button: NSStatusBarButton) {
        if let popover = popover, popover.isShown {
            hide()
        } else {
            show(from: button)
        }
    }

    // MARK: - 事件监听

    /// 启动事件监听器
    private func startEventMonitor() {
        guard eventMonitor == nil else {
            return
        }

        // 监听左键点击事件
        eventMonitor = EventMonitor(mask: .leftMouseDown) { [weak self] event in
            if let popover = self?.popover, popover.isShown {
                // 检查点击是否在 Popover 内部
                if let contentView = popover.contentViewController?.view,
                    contentView.window?.isVisible == true {
                    // 转换坐标
                    let clickLocation = event.locationInWindow
                    let bounds = contentView.bounds

                    // 如果点击在 Popover 外部,关闭 Popover
                    if !bounds.contains(clickLocation) {
                        self?.hide()
                    }
                }
            }
        }

        eventMonitor?.start()
    }

    /// 停止事件监听器
    private func stopEventMonitor() {
        eventMonitor?.stop()
        eventMonitor = nil
    }

    // MARK: - 更新内容

    /// 刷新 Popover 内容
    func refreshContent() {
        // 如果需要动态更新 Popover 内容,可以在这里实现
        // 例如:当剪切板有新内容时,刷新列表
    }
}
