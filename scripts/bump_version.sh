#!/bin/bash

# 版本号自动升级脚本
# 用法: ./scripts/bump_version.sh [major|minor|patch]

set -e

BUMP_TYPE=${1:-patch}

# 读取当前版本
if [ ! -f VERSION ]; then
    echo "❌ 错误: VERSION 文件不存在"
    exit 1
fi

CURRENT_VERSION=$(cat VERSION | tr -d 'VERSION="')

# 分解版本号
IFS='.' read -ra PARTS <<< "$CURRENT_VERSION"
MAJOR=${PARTS[0]}
MINOR=${PARTS[1]}
PATCH=${PARTS[2]}

# 根据类型升级
case $BUMP_TYPE in
    major)
        MAJOR=$((MAJOR + 1))
        MINOR=0
        PATCH=0
        ;;
    minor)
        MINOR=$((MINOR + 1))
        PATCH=0
        ;;
    patch)
        PATCH=$((PATCH + 1))
        ;;
    *)
        echo "❌ 错误: 无效的升级类型 '$BUMP_TYPE'"
        echo "用法: $0 [major|minor|patch]"
        exit 1
        ;;
esac

NEW_VERSION="$MAJOR.$MINOR.$PATCH"

echo "📌 当前版本: $CURRENT_VERSION"
echo "➡️  升级类型: $BUMP_TYPE"
echo "✨ 新版本: $NEW_VERSION"

# 更新 VERSION 文件
echo "VERSION=\"$NEW_VERSION\"" > VERSION

echo "✅ VERSION 文件已更新"
echo ""
echo "下一步："
echo "  git add VERSION"
echo "  git commit -m 'chore: bump version to $NEW_VERSION'"
echo "  ./scripts/release.sh $NEW_VERSION"
