//
//  ClipListRow.swift
//  ClipMaster
//
//  剪切板列表行视图
//

import SwiftUI

/// 剪切板列表行视图
struct ClipListRow: View {
    /// 剪切板项目
    let item: ClipItem

    /// 点击事件
    let onClick: () -> Void

    /// 复制事件
    let onCopy: () -> Void

    /// 置顶事件
    let onPin: () -> Void

    /// 删除事件
    let onDelete: () -> Void

    /// 是否显示预览
    @State private var showPreview = false

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // 左边: 类型图标
            typeIcon

            // 中间: 内容预览
            contentPreview

            // 右边: 操作按钮
            actionButtons
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(rowBackgroundColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(rowBorderColor, lineWidth: item.isPinned ? 2 : 0)
        )
        .onTapGesture {
            onClick()
        }
        .contextMenu {
            Button(action: onCopy) {
                Label("复制", systemImage: "doc.on.doc")
            }
            Button(action: onPin) {
                Label(item.isPinned ? "取消置顶" : "置顶", systemImage: item.isPinned ? "pin.slash" : "pin")
            }
            Divider()
            Button(action: onDelete) {
                Label("删除", systemImage: "trash")
            }
        }
    }

    // MARK: - 子视图

    /// 类型图标
    private var typeIcon: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(typeColor.opacity(0.2))
                .frame(width: 32, height: 32)

            Image(systemName: item.type.iconName)
                .foregroundColor(typeColor)
                .font(.system(size: 14))
        }
    }

    /// 内容预览
    private var contentPreview: some View {
        VStack(alignment: .leading, spacing: 4) {
            // 内容文本
            Text(item.displayText)
                .font(.system(size: 13))
                .lineLimit(3)
                .foregroundColor(.primary)

            // 底部信息: 来源应用 + 时间
            HStack(spacing: 6) {
                // 来源应用
                if let sourceApp = item.sourceApp {
                    HStack(spacing: 4) {
                        Image(systemName: "app")
                            .font(.system(size: 10))
                        Text(item.sourceAppName)
                            .font(.system(size: 11))
                    }
                    .foregroundColor(.secondary)
                }

                // 分隔符
                if item.sourceApp != nil {
                    Text("·")
                        .foregroundColor(.secondary)
                        .font(.system(size: 10))
                }

                // 时间
                Text(item.formattedTime)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    /// 操作按钮
    private var actionButtons: some View {
        HStack(spacing: 4) {
            // 复制按钮
            Button(action: onCopy) {
                Image(systemName: "doc.on.doc")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(.plain)
            .help("复制到剪切板")

            // 置顶按钮
            Button(action: onPin) {
                Image(systemName: item.isPinned ? "pin.fill" : "pin")
                    .font(.system(size: 12))
                    .foregroundColor(item.isPinned ? .accentColor : .secondary)
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(.plain)
            .help(item.isPinned ? "取消置顶" : "置顶")

            // 删除按钮
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(.plain)
            .help("删除")
        }
    }

    // MARK: - 辅助属性

    /// 类型颜色
    private var typeColor: Color {
        switch item.type {
        case .text:
            return .blue
        case .image:
            return .purple
        case .url:
            return .green
        case .color:
            return .pink
        case .file:
            return .orange
        case .rtf:
            return .indigo
        case .unknown:
            return .gray
        }
    }

    /// 行背景色
    private var rowBackgroundColor: Color {
        Color(NSColor.controlBackgroundColor)
    }

    /// 行边框色
    private var rowBorderColor: Color {
        item.isPinned ? .accentColor : .clear
    }
}

// MARK: - 预览

#Preview {
    VStack(spacing: 8) {
        ClipListRow(
            item: ClipItem(
                id: 1,
                content: "这是一段示例文本,用于预览剪切板列表行的显示效果",
                type: .text,
                sourceApp: "com.apple.Safari",
                timestamp: Date(),
                isPinned: false
            ),
            onClick: {},
            onCopy: {},
            onPin: {},
            onDelete: {}
        )

        ClipListRow(
            item: ClipItem(
                id: 2,
                content: "https://github.com",
                type: .url,
                sourceApp: "com.google.Chrome",
                timestamp: Date().addingTimeInterval(-3600),
                isPinned: true
            ),
            onClick: {},
            onCopy: {},
            onPin: {},
            onDelete: {}
        )
    }
    .padding()
}
