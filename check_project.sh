#!/bin/bash

# ClipMaster 项目检查脚本

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                                                                ║"
echo "║              ClipMaster 项目检查工具                            ║"
echo "║                                                                ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

PROJECT_DIR="/Users/yaoo13/ai/ClipMaster"
ERRORS=0
WARNINGS=0

# 检查函数
check_item() {
    local item=$1
    local type=$2
    local required=$3

    if [ "$type" = "file" ]; then
        if [ -f "$item" ]; then
            echo "✅ $item"
            return 0
        else
            if [ "$required" = "yes" ]; then
                echo "❌ $item (缺失)"
                ((ERRORS++))
            else
                echo "⚠️  $item (可选,未找到)"
                ((WARNINGS++))
            fi
            return 1
        fi
    elif [ "$type" = "dir" ]; then
        if [ -d "$item" ]; then
            echo "✅ $item"
            return 0
        else
            if [ "$required" = "yes" ]; then
                echo "❌ $item (缺失)"
                ((ERRORS++))
            else
                echo "⚠️  $item (可选,未找到)"
                ((WARNINGS++))
            fi
            return 1
        fi
    elif [ "$type" = "command" ]; then
        if command -v "$item" &> /dev/null; then
            echo "✅ $item"
            return 0
        else
            if [ "$required" = "yes" ]; then
                echo "❌ $item (未安装)"
                ((ERRORS++))
            else
                echo "⚠️  $item (可选,未安装)"
                ((WARNINGS++))
            fi
            return 1
        fi
    fi
}

echo "📋 检查项目文件..."
echo ""

# 检查源文件目录
check_item "$PROJECT_DIR/ClipMaster" "dir" "yes"

# 检查源文件
echo ""
echo "📝 源文件:"
check_item "$PROJECT_DIR/ClipMaster/ClipMasterApp.swift" "file" "yes"
check_item "$PROJECT_DIR/ClipMaster/AppDelegate.swift" "file" "yes"

# 检查 Models
echo ""
echo "📦 Models:"
check_item "$PROJECT_DIR/ClipMaster/Models" "dir" "yes"
check_item "$PROJECT_DIR/ClipMaster/Models/ClipType.swift" "file" "yes"
check_item "$PROJECT_DIR/ClipMaster/Models/ClipItem.swift" "file" "yes"
check_item "$PROJECT_DIR/ClipMaster/Models/BlacklistApp.swift" "file" "yes"

# 检查 Database
echo ""
echo "💾 Database:"
check_item "$PROJECT_DIR/ClipMaster/Database" "dir" "yes"
check_item "$PROJECT_DIR/ClipMaster/Database/DatabaseManager.swift" "file" "yes"
check_item "$PROJECT_DIR/ClipMaster/Database/ClipItemDAO.swift" "file" "yes"

# 检查 Services
echo ""
echo "⚙️  Services:"
check_item "$PROJECT_DIR/ClipMaster/Services" "dir" "yes"
check_item "$PROJECT_DIR/ClipMaster/Services/ClipboardMonitor.swift" "file" "yes"
check_item "$PROJECT_DIR/ClipMaster/Services/PasteboardService.swift" "file" "yes"

# 检查 Managers
echo ""
echo "🎛️  Managers:"
check_item "$PROJECT_DIR/ClipMaster/Managers" "dir" "yes"
check_item "$PROJECT_DIR/ClipMaster/Managers/StatusBarManager.swift" "file" "yes"
check_item "$PROJECT_DIR/ClipMaster/Managers/PopoverManager.swift" "file" "yes"

# 检查 Views
echo ""
echo "🎨 Views:"
check_item "$PROJECT_DIR/ClipMaster/Views" "dir" "yes"
check_item "$PROJECT_DIR/ClipMaster/Views/MainPopoverView.swift" "file" "yes"
check_item "$PROJECT_DIR/ClipMaster/Views/SearchBarView.swift" "file" "yes"

# 检查 ViewModels
echo ""
echo "📊 ViewModels:"
check_item "$PROJECT_DIR/ClipMaster/ViewModels" "dir" "yes"
check_item "$PROJECT_DIR/ClipMaster/ViewModels/ClipListViewModel.swift" "file" "yes"

# 检查 Utilities
echo ""
echo "🛠️  Utilities:"
check_item "$PROJECT_DIR/ClipMaster/Utilities" "dir" "yes"
check_item "$PROJECT_DIR/ClipMaster/Utilities/Constants.swift" "file" "yes"
check_item "$PROJECT_DIR/ClipMaster/Utilities/ContentTypeDetector.swift" "file" "yes"

# 检查文档
echo ""
echo "📚 文档:"
check_item "$PROJECT_DIR/GET_STARTED.md" "file" "yes"
check_item "$PROJECT_DIR/QUICKSTART.md" "file" "yes"
check_item "$PROJECT_DIR/INSTALL_GUIDE.md" "file" "yes"
check_item "$PROJECT_DIR/README.md" "file" "yes"
check_item "$PROJECT_DIR/PROJECT_SUMMARY.md" "file" "yes"

# 检查脚本
echo ""
echo "🔧 脚本:"
check_item "$PROJECT_DIR/quick_setup.sh" "file" "yes"
check_item "$PROJECT_DIR/setup_and_build.sh" "file" "yes"

# 检查工具
echo ""
echo "🛠️  系统工具:"
check_item "xcodebuild" "command" "no"
check_item "xcode-select" "command" "no"

# 检查 Xcode
echo ""
if [ -d "/Applications/Xcode.app" ]; then
    echo "✅ Xcode 已安装"
    if command -v xcodebuild &> /dev/null; then
        echo "   版本: $(xcodebuild -version | head -n 1)"
    fi
else
    echo "⚠️  Xcode 未安装"
    echo "   请从 App Store 安装 Xcode"
    ((WARNINGS++))
fi

# 统计文件
echo ""
echo "📊 文件统计:"
SWIFT_COUNT=$(find "$PROJECT_DIR/ClipMaster" -name "*.swift" -type f 2>/dev/null | wc -l)
echo "   Swift 文件: $SWIFT_COUNT"

LINE_COUNT=$(find "$PROJECT_DIR/ClipMaster" -name "*.swift" -type f -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}')
echo "   代码行数: $LINE_COUNT"

# 总结
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo "✅ 所有检查通过! 项目已准备就绪。"
    echo ""
    echo "下一步:"
    echo ""
    if [ -d "/Applications/Xcode.app" ]; then
        echo "1. 运行自动化脚本:"
        echo "   cd $PROJECT_DIR"
        echo "   ./quick_setup.sh"
        echo ""
        echo "2. 或手动在 Xcode 中创建项目:"
        echo "   open -a Xcode"
        echo ""
    else
        echo "1. 安装 Xcode:"
        echo "   open \"macappstore://apps.apple.com/app/xcode/id497799835\""
        echo ""
        echo "2. 然后运行:"
        echo "   cd $PROJECT_DIR"
        echo "   ./quick_setup.sh"
        echo ""
    fi
    echo "📖 详细说明: $PROJECT_DIR/GET_STARTED.md"
    echo ""
elif [ $ERRORS -eq 0 ]; then
    echo "⚠️  项目基本就绪,但有 $WARNINGS 个警告"
    echo ""
    echo "主要问题是 Xcode 未安装。请先安装 Xcode,然后:"
    echo "  cd $PROJECT_DIR"
    echo "  ./quick_setup.sh"
    echo ""
else
    echo "❌ 发现 $ERRORS 个错误,$WARNINGS 个警告"
    echo ""
    echo "请检查缺失的文件。如果源文件不完整,请重新生成项目。"
    echo ""
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

exit $ERRORS
