#!/bin/bash

# ClipMaster 自动化构建脚本
# 此脚本会帮助您在 Xcode 中创建项目并构建应用

set -e

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                                                                ║"
echo "║              ClipMaster 自动化构建脚本                          ║"
echo "║                                                                ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

PROJECT_DIR="/Users/yaoo13/ai/ClipMaster"
PROJECT_NAME="ClipMaster"
BUNDLE_ID="com.example.ClipMaster"

# 检查 Xcode 是否安装
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ 错误: 未找到 Xcode"
    echo ""
    echo "请先安装 Xcode:"
    echo "  1. 从 App Store 安装 Xcode"
    echo "  2. 打开 Xcode 并同意许可协议"
    echo "  3. 安装命令行工具: xcode-select --install"
    echo ""
    exit 1
fi

echo "✅ 找到 Xcode: $(xcodebuild -version | head -n 1)"
echo ""

# 检查源文件是否存在
if [ ! -d "$PROJECT_DIR/ClipMaster" ]; then
    echo "❌ 错误: 未找到源文件目录"
    echo "   期望路径: $PROJECT_DIR/ClipMaster"
    exit 1
fi

echo "✅ 源文件目录存在"
echo ""

# 步骤 1: 创建临时 Xcode 项目
echo "📝 步骤 1: 准备 Xcode 项目..."
echo ""

# 由于无法通过命令行直接创建 .xcodeproj，我们需要用户手动操作
cat << 'EOF'

由于 Xcode 项目的复杂性，请按照以下步骤手动创建项目：

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 手动创建步骤:

1️⃣  打开 Xcode

2️⃣  创建新项目
    • 选择 File > New > Project
    • 选择 macOS > App
    • 点击 Next

3️⃣  填写项目信息
    • Product Name: ClipMaster
    • Team: 选择您的开发团队 (或选择 "None" 用于本地开发)
    • Organization Identifier: com.example
    • Bundle Identifier: com.example.ClipMaster
    • Interface: SwiftUI
    • Language: Swift
    • 取消勾选 "Use Core Data"
    • 点击 Next

4️⃣  保存项目
    • 选择保存位置: /Users/yaoo13/ai/ClipMaster
    • 确保 "Create Git repository" 选项已取消
    • 点击 Create

5️⃣  删除默认文件
    • 在项目导航器中找到 "ClipMasterView.swift"
    • 右键点击 -> Delete
    • 选择 "Move to Trash"

6️⃣  导入源文件
    • 在 Finder 中打开: /Users/yaoo13/ai/ClipMaster/ClipMaster/
    • 将以下文件夹拖入 Xcode 项目导航器:
      ✓ Models/
      ✓ Database/
      ✓ Services/
      ✓ Managers/
      ✓ ViewModels/
      ✓ Views/
      ✓ Utilities/
      ✓ ClipMasterApp.swift (覆盖现有文件)
      ✓ AppDelegate.swift (覆盖现有文件)

    • 在弹出的对话框中:
      ✓ 勾选 "Copy items if needed"
      ✓ 选择 "Create groups"
      ✓ 确保 "ClipMaster" target 被选中
      ✓ 点击 Finish

7️⃣  配置 Info.plist
    • 选择项目文件 (最顶部的 ClipMaster)
    • 选择 Target > ClipMaster > Info 标签
    • 点击 "+" 添加以下键值:

    Key: NSAccessibilityUsageDescription
    Type: String
    Value: 需要辅助功能权限以获取前台应用信息,实现隐私保护功能

    Key: NSAppleEventsUsageDescription
    Type: String
    Value: 需要脚本权限以检测前台应用

8️⃣  设置部署目标
    • 选择项目文件
    • 在 "Deployment Target" 中设置: macOS 12.0

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

完成上述步骤后，请按任意键继续，或按 Ctrl+C 退出...
EOF

read -n 1 -s -r -p ""
echo ""
echo ""

# 步骤 2: 查找 Xcode 项目
echo "🔍 步骤 2: 查找 Xcode 项目..."
echo ""

find "$PROJECT_DIR" -name "*.xcodeproj" -type d | while read project; do
    echo "✅ 找到项目: $project"
done

echo ""
echo "如果项目未在上面的列表中显示，请确保您已正确创建项目。"
echo ""

PROJECT_PATH=$(find "$PROJECT_DIR" -name "${PROJECT_NAME}.xcodeproj" -type d -maxdepth 2 | head -n 1)

if [ -z "$PROJECT_PATH" ]; then
    echo "⚠️  未找到 Xcode 项目文件"
    echo ""
    echo "请确保您已完成上述手动步骤，然后重新运行此脚本。"
    exit 1
fi

echo "✅ 使用项目: $PROJECT_PATH"
echo ""

# 步骤 3: 构建应用
echo "🔨 步骤 3: 构建应用..."
echo ""

cd "$PROJECT_DIR"

# 清理构建
xcodebuild -project "$PROJECT_PATH" \
    -scheme "$PROJECT_NAME" \
    -configuration Debug \
    clean

# 构建
xcodebuild -project "$PROJECT_PATH" \
    -scheme "$PROJECT_NAME" \
    -configuration Debug \
    -derivedDataPath ./build \
    build

echo ""
echo "✅ 构建完成！"
echo ""

# 查找构建的应用
APP_PATH=$(find ./build -name "${PROJECT_NAME}.app" -type d | head -n 1)

if [ -n "$APP_PATH" ]; then
    echo "📦 应用位置: $APP_PATH"
    echo ""

    # 复制到桌面
    DESKTOP_APP="$HOME/Desktop/${PROJECT_NAME}.app"
    cp -R "$APP_PATH" "$DESKTOP_APP"
    echo "✅ 已复制到桌面: $DESKTOP_APP"
    echo ""

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "🎉 构建成功！"
    echo ""
    echo "您现在可以:"
    echo "  1. 在桌面找到 ClipMaster.app"
    echo "  2. 双击运行应用"
    echo "  3. 首次运行时需要授予辅助功能权限"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
else
    echo "⚠️  未找到构建的应用"
    echo "请检查构建输出以了解详情。"
fi

echo ""
echo "脚本执行完成。"
