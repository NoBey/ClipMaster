//
//  SearchBarView.swift
//  ClipMaster
//
//  搜索栏视图
//

import SwiftUI

/// 搜索栏视图
struct SearchBarView: View {
    /// 搜索文本
    @Binding var searchText: String

    /// 是否有搜索内容
    private var hasSearchText: Bool {
        !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        HStack(spacing: 8) {
            // 搜索图标
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
                .font(.system(size: 14))

            // 搜索输入框
            TextField("搜索剪切板历史", text: $searchText)
                .textFieldStyle(.plain)
                .font(.system(size: 13))
                .onChange(of: searchText) { newValue in
                    // 实时搜索,onChange 会自动触发 ViewModel 的更新
                }

            // 清除按钮
            if hasSearchText {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                        .font(.system(size: 14))
                }
                .buttonStyle(.plain)
                .help("清除搜索")
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }
}

// MARK: - 预览

#Preview {
    SearchBarView(searchText: .constant(""))
        .padding()
        .frame(width: 300)
}
