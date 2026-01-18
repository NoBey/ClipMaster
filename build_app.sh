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

# 获取版本号（优先使用环境变量，其次是 VERSION 文件）
if [ -n "$VERSION" ]; then
    APP_VERSION="$VERSION"
elif [ -f "$PROJECT_DIR/VERSION" ]; then
    APP_VERSION=$(cat "$PROJECT_DIR/VERSION" | tr -d 'VERSION="')
else
    APP_VERSION="1.0.0"
fi

# 获取构建版本（使用 Git commit hash）
if command -v git &> /dev/null; then
    BUILD_VERSION=$(git rev-parse --short HEAD 2>/dev/null || echo "1")
else
    BUILD_VERSION="1"
fi

echo "📌 App Version: $APP_VERSION"
echo "🔖 Build Version: $BUILD_VERSION"
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

# 编译并复制 Assets.xcassets
echo "📦 处理应用图标..."
ASSETS_PATH="$PROJECT_DIR/ClipMaster/Resources/Assets.xcassets"
APPICONSET="$ASSETS_PATH/AppIcon.appiconset"

if [ -d "$APPICONSET" ]; then
    # 创建临时 iconset 目录
    TEMP_ICONSET="$BUILD_DIR/AppIcon.iconset"
    rm -rf "$TEMP_ICONSET"
    mkdir -p "$TEMP_ICONSET"

    # 复制并重命名图标文件为 macOS iconset 格式
    cd "$APPICONSET"
    cp 16.png "$TEMP_ICONSET/icon_16x16.png" 2>/dev/null
    cp 32.png "$TEMP_ICONSET/icon_16x16@2x.png" 2>/dev/null
    cp 32.png "$TEMP_ICONSET/icon_32x32.png" 2>/dev/null
    cp 64.png "$TEMP_ICONSET/icon_32x32@2x.png" 2>/dev/null
    cp 128.png "$TEMP_ICONSET/icon_128x128.png" 2>/dev/null
    cp 256.png "$TEMP_ICONSET/icon_128x128@2x.png" 2>/dev/null
    cp 256.png "$TEMP_ICONSET/icon_256x256.png" 2>/dev/null
    cp 512.png "$TEMP_ICONSET/icon_256x256@2x.png" 2>/dev/null
    cp 512.png "$TEMP_ICONSET/icon_512x512.png" 2>/dev/null
    cp 1024.png "$TEMP_ICONSET/icon_512x512@2x.png" 2>/dev/null

    # 使用 iconutil 生成 .icns 文件
    iconutil -c icns "$TEMP_ICONSET" -o "$BUILD_DIR/AppIcon.icns" 2>/dev/null

    if [ -f "$BUILD_DIR/AppIcon.icns" ]; then
        cp "$BUILD_DIR/AppIcon.icns" "$APP_PATH/Contents/Resources/"
        echo "✅ 图标资源已添加 (AppIcon.icns)"
    else
        echo "⚠️  警告: AppIcon.icns 未生成"
    fi
else
    echo "⚠️  警告: 未找到 AppIcon.appiconset"
fi

# 创建 Info.plist
cat > "$APP_PATH/Contents/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>ClipMaster</string>
    <key>CFBundleIdentifier</key>
    <string>com.yaoo13.ClipMaster</string>
    <key>CFBundleName</key>
    <string>ClipMaster</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>$APP_VERSION</string>
    <key>CFBundleVersion</key>
    <string>$BUILD_VERSION</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>CFBundleIconName</key>
    <string>AppIcon</string>
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
