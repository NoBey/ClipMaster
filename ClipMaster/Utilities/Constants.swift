//
//  Constants.swift
//  ClipMaster
//
//  常量定义
//

import Foundation

/// 应用常量
enum AppConstants {
    /// 应用名称
    static let appName = "ClipMaster"

    /// Bundle Identifier
    static let bundleIdentifier = "com.example.ClipMaster"

    /// 应用版本
    static let appVersion = "1.0.0"

    /// 最大历史记录数量
    static let maxHistoryCount = 1000

    /// 数据清理天数 (超过此天数的历史记录将被清理)
    static let dataCleanupDays = 30

    /// 轮询间隔 (秒)
    static let pollingInterval: TimeInterval = 0.5

    /// Popover 尺寸
    static let popoverSize = NSSize(width: 400, height: 600)
}

/// 数据库常量
enum DatabaseConstants {
    /// 数据库名称
    static let databaseName = "clipmaster.db"

    /// 数据库版本
    static let databaseVersion = 1

    /// 表名
    static let clipsTable = "clips"
    static let blacklistTable = "blacklist_apps"
}

/// 通知名称常量
extension Notification.Name {
    /// 剪切板更新通知
    static let clipDidUpdate = Notification.Name("clipDidUpdate")

    /// 应用进入前台通知
    static let appDidBecomeActive = Notification.Name("appDidBecomeActive")

    /// 应用进入后台通知
    static let appDidResignActive = Notification.Name("appDidResignActive")
}

/// 用户默认键
enum UserDefaultsKeys {
    /// 首次运行标记
    static let isFirstLaunch = "isFirstLaunch"

    /// 已授权辅助功能权限
    static let hasAccessibilityPermission = "hasAccessibilityPermission"

    /// 最大历史记录数量
    static let maxHistoryCount = "maxHistoryCount"

    /// 启用自动清理
    static let enableAutoCleanup = "enableAutoCleanup"
}
