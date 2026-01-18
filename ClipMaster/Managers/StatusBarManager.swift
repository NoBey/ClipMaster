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

            // 启用右键菜单
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }

        print("✅ 状态栏图标已创建")
    }

    // MARK: - 点击事件

    /// 状态栏按钮点击事件
    @objc private func statusBarButtonClicked() {
        guard let button = statusItem?.button else {
            return
        }

        // 获取当前事件
        let event = NSApp.currentEvent

        // 判断是否为右键点击
        if event?.type == .rightMouseUp {
            // 显示右键菜单
            showContextMenu(at: button.bounds.origin)
        } else {
            // 左键点击：切换 Popover 显示状态
            popoverManager.toggle(from: button)
        }
    }

    // MARK: - 右键菜单

    /// 显示右键菜单
    private func showContextMenu(at point: NSPoint) {
        let menu = NSMenu()

        // 关于
        let aboutItem = NSMenuItem(
            title: "关于 ClipMaster",
            action: #selector(showAbout),
            keyEquivalent: ""
        )
        aboutItem.target = self
        menu.addItem(aboutItem)

        menu.addItem(NSMenuItem.separator())

        // 退出
        let quitItem = NSMenuItem(
            title: "退出 ClipMaster",
            action: #selector(quitApp),
            keyEquivalent: "q"
        )
        quitItem.target = self
        menu.addItem(quitItem)

        // 显示菜单
        if let button = statusItem?.button {
            // 获取屏幕信息以正确计算位置
            if let window = button.window {
                let windowFrame = window.frame
                // 菜单显示在状态栏图标下方，与左边缘对齐
                menu.popUp(positioning: nil, at: NSPoint(x: 0, y: windowFrame.height), in: button)
            } else {
                // 备用方案
                menu.popUp(positioning: menu.item(at: 0), at: NSPoint(x: 0, y: button.bounds.height + 5), in: button)
            }
        }
    }

    // MARK: - 菜单动作

    /// 显示关于对话框
    @objc private func showAbout() {
        let alert = NSAlert()
        alert.messageText = "ClipMaster"
        alert.informativeText = """
        版本: 1.0

        一款 macOS 剪切板管理工具
        核心价值: 无感记录、极速检索、一键回填

        © 2025 ClipMaster
        """
        alert.alertStyle = .informational
        alert.addButton(withTitle: "确定")
        alert.runModal()
    }

    /// 退出应用
    @objc private func quitApp() {
        NSApp.terminate(nil)
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
