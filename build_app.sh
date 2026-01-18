#!/bin/bash

# ClipMaster 命令行打包脚本
# 此脚本会创建一个临时的 Xcode 项目并构建应用

set -e

PROJECT_DIR="$(pwd)"
PROJECT_NAME="ClipMaster"
BUILD_DIR="$PROJECT_DIR/build"
APP_NAME="$PROJECT_NAME.app"

echo "=========================================="
echo "  ClipMaster 命令行打包工具"
echo "=========================================="
echo ""

# 清理旧的构建
echo "🧹 清理旧的构建..."
rm -rf "$BUILD_DIR"

# 创建构建目录
mkdir -p "$BUILD_DIR"

# 编译 Swift 代码
echo "🔨 编译 Swift 代码..."
cd "$PROJECT_DIR"

# 查找所有 Swift 源文件
SWIFT_SOURCES=$(find ClipMaster -name "*.swift" -type f | tr '\n' ' ')

# 编译参数
TARGET="arm64-apple-macos13.0"
SDK_PATH=$(xcrun --sdk macosx --show-sdk-path)
MIN_VERSION="-target $TARGET"
LINK_FLAGS="-framework AppKit -framework SwiftUI -framework Foundation -framework Cocoa -lsqlite3"

echo "📦 正在构建..."

# 编译所有 Swift 文件
swiftc \
    -sdk "$SDK_PATH" \
    $MIN_VERSION \
    -O \
    -parse-as-library \
    -import-objc-header "$PROJECT_DIR/ClipMaster-Bridging-Header.h" \
    $SWIFT_SOURCES \
    -o "$BUILD_DIR/$PROJECT_NAME" \
    $LINK_FLAGS \
    -I "$BUILD_DIR" \
    -Xlinker -rpath -Xlinker @executable_path/../Frameworks \
    2>&1 | tee build.log

if [ ${PIPESTATUS[0]} -ne 0 ]; then
    echo "❌ 编译失败！请查看 build.log"
    exit 1
fi

echo "✅ 编译成功！"

# 创建 .app 包结构
echo "📦 创建应用包..."
APP_PATH="$BUILD_DIR/$APP_NAME"
rm -rf "$APP_PATH"
mkdir -p "$APP_PATH/Contents/MacOS"
mkdir -p "$APP_PATH/Contents/Resources"

# 复制可执行文件
cp "$BUILD_DIR/$PROJECT_NAME" "$APP_PATH/Contents/MacOS/"

# 创建 Info.plist
cat > "$APP_PATH/Contents/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>ClipMaster</string>
    <key>CFBundleIdentifier</key>
    <string>com.example.ClipMaster</string>
    <key>CFBundleName</key>
    <string>ClipMaster</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSAppleEventsUsageDescription</key>
    <string>需要访问系统事件以检测前台应用</string>
    <key>com.apple.security.automation.apple-events</key>
    <true/>
    <key>com.apple.security.files.user-selected.read-write</key>
    <true/>
</dict>
</plist>
EOF

echo "✅ 应用包创建成功！"
echo ""
echo "📂 应用位置: $APP_PATH"
echo ""
echo "🚀 运行应用: open \"$APP_PATH\""
