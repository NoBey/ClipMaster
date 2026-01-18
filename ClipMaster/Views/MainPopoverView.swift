//
//  MainPopoverView.swift
//  ClipMaster
//
//  主弹出窗口视图
//

import SwiftUI

/// 主弹出窗口视图
struct MainPopoverView: View {
    /// 视图模型
    @StateObject private var viewModel = ClipListViewModel()

    /// 是否显示设置界面
    @State private var showSettings = false

    var body: some View {
        VStack(spacing: 0) {
            // 顶部栏: 搜索 + 设置按钮
            headerView

            Divider()

            // 过滤标签
            filterTabView
                .padding(.top, 8)
                .padding(.horizontal, 12)

            Divider()
                .padding(.top, 8)

            // 剪切板列表
            clipListView

            // 底部栏: 统计信息
            footerView
        }
        .frame(width: 400, height: 600)
        .onAppear {
            // 初始加载数据
            viewModel.refresh()
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }

    // MARK: - 子视图

    /// 顶部栏
    private var headerView: some View {
        HStack(spacing: 12) {
            // 搜索栏
            SearchBarView(searchText: $viewModel.searchText)
                .frame(maxWidth: .infinity)

            // 设置按钮
            Button(action: {
                showSettings = true
            }) {
                Image(systemName: "gear")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .frame(width: 28, height: 28)
            }
            .buttonStyle(.plain)
            .help("设置")
        }
        .padding(12)
    }

    /// 过滤标签视图
    private var filterTabView: some View {
        FilterTabView(selectedType: $viewModel.selectedType)
    }

    /// 剪切板列表视图
    private var clipListView: some View {
        ClipListView(
            items: viewModel.filteredClips,
            onClick: { item in
                viewModel.handleClick(item)
            },
            onCopy: { item in
                viewModel.copyToClipboard(item)
            },
            onPin: { item in
                viewModel.togglePin(item)
            },
            onDelete: { item in
                viewModel.delete(item)
            }
        )
    }

    /// 底部栏
    private var footerView: some View {
        HStack {
            // 统计信息
            Text("\(viewModel.filteredClips.count) 项")
                .font(.system(size: 11))
                .foregroundColor(.secondary)

            Spacer()

            // 清空按钮
            if !viewModel.clips.isEmpty {
                Button(action: {
                    viewModel.clearAllHistory()
                }) {
                    Text("清空")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(NSColor.controlBackgroundColor))
    }
}

// MARK: - 预览

#Preview {
    MainPopoverView()
        .frame(width: 400, height: 600)
}
