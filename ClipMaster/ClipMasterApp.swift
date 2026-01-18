//
//  ClipMasterApp.swift
//  ClipMaster
//
//  应用主入口
//

import SwiftUI

@main
struct ClipMasterApp: App {
    /// 应用代理
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        // 空场景,因为我们使用状态栏图标
        Settings {
            EmptyView()
        }
    }
}
