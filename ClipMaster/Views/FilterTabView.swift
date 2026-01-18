//
//  FilterTabView.swift
//  ClipMaster
//
//  过滤标签视图
//

import SwiftUI

/// 过滤标签视图
struct FilterTabView: View {
    /// 选中的类型
    @Binding var selectedType: ClipType?

    /// 所有类型选项 (添加 "全部" 选项)
    private let typeOptions: [ClipType?] = [
        nil,  // 全部
        .text,
        .image,
        .url,
        .color
    ]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(typeOptions.indices, id: \.self) { index in
                    FilterTabButton(
                        type: typeOptions[index],
                        isSelected: selectedType == typeOptions[index],
                        action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedType = typeOptions[index]
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 4)
        }
    }
}

/// 过滤标签按钮
struct FilterTabButton: View {
    /// 类型
    let type: ClipType?

    /// 是否选中
    let isSelected: Bool

    /// 点击事件
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: iconName)
                Text(displayName)
                    .font(.system(size: 12, weight: isSelected ? .semibold : .regular))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? Color.accentColor : Color(NSColor.controlBackgroundColor))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(6)
        }
        .buttonStyle(.plain)
    }

    /// 显示名称
    private var displayName: String {
        if let type = type {
            return type.displayName
        } else {
            return "全部"
        }
    }

    /// 图标名称
    private var iconName: String {
        if let type = type {
            return type.iconName
        } else {
            return "square.grid.2x2"
        }
    }
}

// MARK: - 预览

#Preview {
    FilterTabView(selectedType: .constant(nil))
        .padding()
        .frame(width: 400)
}
