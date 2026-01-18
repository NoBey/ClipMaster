# ClipMaster

一款 macOS 剪切板管理工具,核心价值为"无感记录、极速检索、一键回填"。

## 技术栈

- **开发语言**: Swift 5.x
- **UI 框架**: SwiftUI + AppKit
- **存储**: SQLite (原生)
- **架构**: MVVM

## 创建 Xcode 项目

由于 Xcode 项目文件(.xcodeproj)是复杂的 bundle 格式,需要通过 Xcode GUI 创建:

### 步骤 1: 在 Xcode 中创建项目

1. 打开 Xcode
2. 选择 File > New > Project
3. 选择 **macOS** > **App**
4. 填写项目信息:
   - Product Name: `ClipMaster`
   - Team: 选择你的开发团队
   - Organization Identifier: `com.example`
   - Bundle Identifier: `com.example.ClipMaster`
   - Interface: **SwiftUI**
   - Language: **Swift**
   - 取消勾选 "Use Core Data"
5. 保存位置选择: `/Users/yaoo13/ai/ClipMaster`
6. 点击 Create

### 步骤 2: 配置项目

1. 选择项目文件,设置 **Deployment Target**: macOS 12.0
2. 选择 `ClipMaster` target,添加以下权限到 `Info.plist`:

```xml
<key>NSAccessibilityUsageDescription</key>
<string>需要辅助功能权限以获取前台应用信息,实现隐私保护功能</string>
<key>NSAppleEventsUsageDescription</key>
<string>需要脚本权限以检测前台应用</string>
```

### 步骤 3: 导入现有源文件

项目创建后,将以下目录中的文件拖入 Xcode 项目:
- Models/
- Services/
- Managers/
- Views/
- ViewModels/
- Database/
- Utilities/

确保勾选 "Copy items if needed" 并选择正确的 Target。

## 项目结构

```
ClipMaster/
├── Models/              # 数据模型层
├── Services/            # 业务逻辑服务层
├── Managers/            # 管理器层
├── Views/               # SwiftUI 视图层
├── ViewModels/          # MVVM 视图模型层
├── Database/            # 数据访问层
└── Utilities/           # 工具类
```

## 核心功能

- ✅ 自动监听剪切板变化
- ✅ 支持文本、图片、链接、颜色代码等多种格式
- ✅ 实时搜索与类型过滤
- ✅ 置顶与收藏功能
- ✅ 隐私保护(应用黑名单)
- ✅ 菜单栏快速访问

## 构建与运行

1. 在 Xcode 中打开 `ClipMaster.xcodeproj`
2. 选择 **My Mac** 作为运行目标
3. 点击 Run (⌘+R) 或按 Play 按钮

## 权限要求

首次运行时,需要在 **系统偏好设置 > 隐私与安全性 > 辅助功能** 中授权 ClipMaster。

## 开发说明

项目使用 MVVM 架构模式:
- **Models**: 数据结构定义
- **Services**: 核心业务逻辑(剪切板监听、应用检测等)
- **Managers**: 系统级功能管理(状态栏、Popover 等)
- **Views**: SwiftUI 视图组件
- **ViewModels**: 视图数据与业务逻辑的桥梁
- **Database**: SQLite 数据持久化
- **Utilities**: 工具类和辅助功能
# ClipMaster

## CI/CD 测试

- ✅ GitHub Actions CI 已配置
- ✅ 自动构建和验证
- 📦 Releases 自动发布
