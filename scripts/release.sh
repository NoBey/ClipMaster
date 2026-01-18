#!/bin/bash

# 发布辅助脚本
# 用法: ./scripts/release.sh <版本号>

set -e

if [ -z "$1" ]; then
    echo "❌ 错误: 缺少版本号参数"
    echo "用法: $0 <版本号>"
    echo "示例: $0 1.1.0"
    exit 1
fi

VERSION=$1

# 检查版本号格式
if ! [[ $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "❌ 错误: 版本号格式不正确"
    echo "正确格式: MAJOR.MINOR.PATCH (例如: 1.0.0)"
    exit 1
fi

echo "🚀 准备发布版本 v$VERSION"

# 检查是否在 main 分支
BRANCH=$(git branch --show-current)
if [ "$BRANCH" != "main" ]; then
    echo "⚠️  警告: 当前不在 main 分支（当前: $BRANCH）"
    read -p "是否继续？(y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# 1. 更新 VERSION 文件
echo "📝 更新 VERSION 文件..."
echo "VERSION=\"$VERSION\"" > VERSION

# 2. 提交变更
echo "📦 提交变更..."
git add VERSION
git commit -m "chore: bump version to $VERSION"

# 3. 创建 Tag
echo "🏷️  创建 Git Tag v$VERSION..."
git tag -a "v$VERSION" -m "Release version $VERSION"

# 4. 推送到远程
echo "📤 推送到 GitHub..."
git push origin main
git push origin "v$VERSION"

echo ""
echo "✅ 发布完成！"
echo "🔗 GitHub Actions 将自动构建并创建 Release"
echo "📍 查看进度: https://github.com/<your-username>/ClipMaster/actions"
