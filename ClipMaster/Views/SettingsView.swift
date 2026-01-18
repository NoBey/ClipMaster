//
//  SettingsView.swift
//  ClipMaster
//
//  设置界面
//

import SwiftUI

/// 设置界面
struct SettingsView: View {
    /// 黑名单应用列表
    @State private var blacklistApps: [BlacklistApp] = []

    /// 是否显示添加应用弹窗
    @State private var showAddApp = false

    /// 新应用的 Bundle ID
    @State private var newAppBundleId = ""

    /// 新应用的名称
    @State private var newAppName = ""

    /// 当前正在运行的应用
    @State private var runningApps: [String] = []

    /// 环境变量: 是否关闭窗口
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            // 标题栏
            headerView

            Divider()

            // 内容区域
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 隐私保护说明
                    privacySection

                    // 黑名单应用列表
                    blacklistSection
                }
                .padding()
            }
        }
        .frame(width: 500, height: 400)
        .onAppear {
            loadBlacklistApps()
            loadRunningApps()
        }
    }

    // MARK: - 子视图

    /// 标题栏
    private var headerView: some View {
        HStack {
            Text("设置")
                .font(.system(size: 16, weight: .semibold))

            Spacer()

            Button(action: {
                dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)
        }
        .padding()
    }

    /// 隐私保护说明
    private var privacySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("隐私保护")
                .font(.system(size: 14, weight: .semibold))

            Text("黑名单中的应用剪切板内容不会被记录。例如:密码管理器、密钥访问等敏感应用。")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
    }

    /// 黑名单应用列表
    private var blacklistSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("黑名单应用")
                    .font(.system(size: 14, weight: .semibold))

                Spacer()

                // 添加应用按钮
                Button(action: {
                    showAddApp = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 12))
                    Text("添加")
                        .font(.system(size: 12))
                }
            }

            // 应用列表
            if blacklistApps.isEmpty {
                emptyView
            } else {
                appListView
            }
        }
    }

    /// 空视图
    private var emptyView: some View {
        VStack(spacing: 8) {
            Image(systemName: "checkmark.shield")
                .font(.system(size: 32))
                .foregroundColor(.green)

            Text("暂无黑名单应用")
                .font(.system(size: 13))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }

    /// 应用列表视图
    private var appListView: some View {
        VStack(spacing: 0) {
            ForEach(blacklistApps) { app in
                appRow(app)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)

                if app.id != blacklistApps.last?.id {
                    Divider()
                        .padding(.leading, 12)
                }
            }
        }
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }

    /// 应用行
    private func appRow(_ app: BlacklistApp) -> some View {
        HStack {
            // 应用图标
            Image(systemName: "app.badge.fill")
                .foregroundColor(.secondary)

            // 应用信息
            VStack(alignment: .leading, spacing: 2) {
                Text(app.appName ?? "Unknown")
                    .font(.system(size: 13))

                Text(app.bundleId)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }

            Spacer()

            // 移除按钮
            Button(action: {
                removeApp(app)
            }) {
                Image(systemName: "trash")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - 弹窗

    /// 添加应用弹窗
    var addAppSheet: some View {
        VStack(spacing: 16) {
            Text("添加黑名单应用")
                .font(.system(size: 16, weight: .semibold))

            // 运行中的应用选择器
            VStack(alignment: .leading, spacing: 8) {
                Text("选择运行中的应用:")
                    .font(.system(size: 12))

                Picker("应用", selection: $newAppBundleId) {
                    Text("请选择").tag("")
                    ForEach(runningApps, id: \.self) { bundleId in
                        Text(bundleId).tag(bundleId)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity)
            }

            // 自定义输入
            VStack(alignment: .leading, spacing: 8) {
                Text("或手动输入 Bundle ID:")
                    .font(.system(size: 12))

                TextField("com.example.app", text: $newAppBundleId)
                    .textFieldStyle(.roundedBorder)

                TextField("应用名称 (可选)", text: $newAppName)
                    .textFieldStyle(.roundedBorder)
            }

            // 按钮
            HStack(spacing: 12) {
                Button("取消") {
                    showAddApp = false
                    newAppBundleId = ""
                    newAppName = ""
                }
                .keyboardShortcut(.cancelAction)

                Button("添加") {
                    addApp()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(newAppBundleId.isEmpty)
            }

            Spacer()
        }
        .padding()
        .frame(width: 400, height: 300)
    }

    // MARK: - 操作

    /// 加载黑名单应用
    private func loadBlacklistApps() {
        blacklistApps = BlacklistDAO.shared.fetchAll()
    }

    /// 加载运行中的应用
    private func loadRunningApps() {
        runningApps = AppDetectionService.shared.getAllRunningApps()
    }

    /// 添加应用到黑名单
    private func addApp() {
        let success = BlacklistDAO.shared.insert(
            bundleId: newAppBundleId,
            appName: newAppName.isEmpty ? nil : newAppName
        )

        if success {
            loadBlacklistApps()
            showAddApp = false
            newAppBundleId = ""
            newAppName = ""
            print("✅ 已添加到黑名单: \(newAppBundleId)")
        }
    }

    /// 从黑名单移除应用
    private func removeApp(_ app: BlacklistApp) {
        let success = BlacklistDAO.shared.delete(bundleId: app.bundleId)

        if success {
            loadBlacklistApps()
            print("✅ 已从黑名单移除: \(app.bundleId)")
        }
    }
}

// MARK: - 预览

#Preview {
    SettingsView()
}
