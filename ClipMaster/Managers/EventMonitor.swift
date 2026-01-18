//
//  EventMonitor.swift
//  ClipMaster
//
//  事件监听器 (用于监听点击外部区域等事件)
//

import AppKit

/// 事件监听器
class EventMonitor {
    private var monitor: Any?
    private let mask: NSEvent.EventTypeMask
    private let handler: (NSEvent) -> Void

    /// 初始化
    init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent) -> Void) {
        self.mask = mask
        self.handler = handler
    }

    /// 开始监听
    func start() {
        monitor = NSEvent.addLocalMonitorForEvents(matching: mask) { [weak self] event in
            if let self = self {
                self.handler(event)
            }
            return event
        }
    }

    /// 停止监听
    func stop() {
        if let monitor = monitor {
            NSEvent.removeMonitor(monitor)
            self.monitor = nil
        }
    }

    deinit {
        stop()
    }
}
