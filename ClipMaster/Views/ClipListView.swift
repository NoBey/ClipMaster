//
//  ClipListView.swift
//  ClipMaster
//
//  剪切板列表视图
//

import SwiftUI

/// 剪切板列表视图
struct ClipListView: View {
    /// 剪切板项目列表
    let items: [ClipItem]

    /// 点击事件
    let onClick: (ClipItem) -> Void

    /// 复制事件
    let onCopy: (ClipItem) -> Void

    /// 置顶事件
    let onPin: (ClipItem) -> Void

    /// 删除事件
    let onDelete: (ClipItem) -> Void

    var body: some View {
        Group {
            if items.isEmpty {
                emptyView
            } else {
                listView
            }
        }
    }

    // MARK: - 子视图

    /// 空视图
    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "clipboard")
                .font(.system(size: 48))
                .foregroundColor(.secondary)

            Text("暂无剪切板记录")
                .font(.system(size: 16))
                .foregroundColor(.secondary)

            Text("复制内容后会自动显示在这里")
                .font(.system(size: 13))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 40)
    }

    /// 列表视图
    private var listView: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(items) { item in
                    ClipListRow(
                        item: item,
                        onClick: {
                            onClick(item)
                        },
                        onCopy: {
                            onCopy(item)
                        },
                        onPin: {
                            onPin(item)
                        },
                        onDelete: {
                            onDelete(item)
                        }
                    )
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
    }
}

// MARK: - 预览

#Preview("空列表") {
    ClipListView(
        items: [],
        onClick: { _ in },
        onCopy: { _ in },
        onPin: { _ in },
        onDelete: { _ in }
    )
    .frame(width: 400, height: 400)
}

#Preview("有数据") {
    let sampleItems = [
        ClipItem(
            id: 1,
            content: "示例文本内容",
            type: .text,
            sourceApp: "com.apple.Safari",
            timestamp: Date(),
            isPinned: false
        ),
        ClipItem(
            id: 2,
            content: "https://github.com",
            type: .url,
            sourceApp: "com.google.Chrome",
            timestamp: Date().addingTimeInterval(-3600),
            isPinned: true
        ),
        ClipItem(
            id: 3,
            content: "#FF5733",
            type: .color,
            sourceApp: "com.apple.Terminal",
            timestamp: Date().addingTimeInterval(-7200),
            isPinned: false
        )
    ]

    return ClipListView(
        items: sampleItems,
        onClick: { _ in },
        onCopy: { _ in },
        onPin: { _ in },
        onDelete: { _ in }
    )
    .frame(width: 400, height: 400)
}
