#!/bin/bash

# ClipMaster 快速设置脚本
# 此脚本会自动打开 Xcode 并引导您创建项目

set -e

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                                                                ║"
echo "║              ClipMaster 快速设置向导                            ║"
echo "║                                                                ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

PROJECT_DIR="/Users/yaoo13/ai/ClipMaster"
PROJECT_NAME="ClipMaster"
BUNDLE_ID="com.example.ClipMaster"

# 检查源文件
if [ ! -d "$PROJECT_DIR/ClipMaster" ]; then
    echo "❌ 错误: 未找到源文件目录"
    exit 1
fi

echo "✅ 源文件已就绪"
echo ""

# 创建临时目录用于项目
TEMP_DIR="$PROJECT_DIR/XcodeProjectTemp"
mkdir -p "$TEMP_DIR"

echo "📝 准备项目文件..."
echo ""

# 创建项目模板目录结构
mkdir -p "$TEMP_DIR/$PROJECT_NAME"

# 创建符号链接到源文件
ln -sf "$PROJECT_DIR/ClipMaster" "$TEMP_DIR/$PROJECT_NAME/Source"

# 创建 Info.plist
cat > "$TEMP_DIR/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>zh_CN</string>
    <key>CFBundleExecutable</key>
    <string>$(EXECUTABLE_NAME)</string>
    <key>CFBundleIdentifier</key>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>$(PRODUCT_NAME)</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>12.0</string>
    <key>NSAccessibilityUsageDescription</key>
    <string>需要辅助功能权限以获取前台应用信息,实现隐私保护功能</string>
    <key>NSAppleEventsUsageDescription</key>
    <string>需要脚本权限以检测前台应用</string>
    <key>NSHumanReadableCopyright</key>
    <string>Copyright © 2025. All rights reserved.</string>
    <key>NSSupportsAutomaticTermination</key>
    <false/>
    <key>NSSupportsSuddenTermination</key>
    <false/>
</dict>
</plist>
EOF

# 创建 README 用于在 Xcode 中查看
cat > "$TEMP_DIR/README_XCODE_SETUP.txt" << 'EOF'
ClipMaster Xcode 项目设置指南
================================

此目录包含项目模板文件。请按照以下步骤操作:

1. 在 Xcode 中创建新项目:
   - File > New > Project
   - macOS > App
   - Product Name: ClipMaster
   - Bundle ID: com.example.ClipMaster
   - Interface: SwiftUI
   - Language: Swift

2. 将源文件导入项目:
   - 导航到 /Users/yaoo13/ai/ClipMaster/ClipMaster/
   - 将所有文件夹和文件拖入 Xcode 项目
   - 勾选 "Copy items if needed"

3. 配置项目:
   - 设置 Deployment Target 为 macOS 12.0
   - Info.plist 中已包含权限配置

4. 构建并运行:
   - 按 ⌘+R 运行项目

详细说明请查看:
- /Users/yaoo13/ai/ClipMaster/QUICKSTART.md
- /Users/yaoo13/ai/ClipMaster/PROJECT_SUMMARY.md
EOF

echo "✅ 项目模板已创建在: $TEMP_DIR"
echo ""

# 尝试打开 Xcode
if [ -d "/Applications/Xcode.app" ]; then
    echo "🚀 正在打开 Xcode..."
    echo ""

    # 打开 Xcode
    open -a Xcode

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "✅ Xcode 已打开"
    echo ""
    echo "请在 Xcode 中按照以下步骤操作:"
    echo ""
    echo "  1️⃣  创建新项目 (File > New > Project > macOS App)"
    echo "      • Product Name: ClipMaster"
    echo "      • Bundle ID: com.example.ClipMaster"
    echo "      • Interface: SwiftUI"
    echo ""
    echo "  2️⃣  导入源文件"
    echo "      • 将以下文件夹拖入项目:"
    echo "        - Models, Database, Services, Managers"
    echo "        - ViewModels, Views, Utilities"
    echo "        - ClipMasterApp.swift, AppDelegate.swift"
    echo ""
    echo "  3️⃣  配置权限"
    echo "      • 在 Info.plist 中添加:"
    echo "        - NSAccessibilityUsageDescription"
    echo "        - NSAppleEventsUsageDescription"
    echo ""
    echo "  4️⃣  构建运行 (⌘+R)"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📖 详细指南: /Users/yaoo13/ai/ClipMaster/QUICKSTART.md"
    echo ""

else
    echo "⚠️  未找到 Xcode.app"
    echo ""
    echo "请先从 App Store 安装 Xcode，然后重新运行此脚本。"
    echo ""
fi
