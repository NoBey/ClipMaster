# ClipMaster 文件清单

## 项目目录结构

```
ClipMaster/
├── ClipMaster/                      # 主源文件目录
│   ├── Models/                      # 数据模型层 (3 个文件)
│   │   ├── ClipType.swift
│   │   ├── ClipItem.swift
│   │   └── BlacklistApp.swift
│   │
│   ├── Database/                    # 数据访问层 (4 个文件)
│   │   ├── DatabaseManager.swift
│   │   ├── DatabaseSetup.swift
│   │   ├── ClipItemDAO.swift
│   │   └── BlacklistDAO.swift
│   │
│   ├── Services/                    # 业务逻辑服务层 (3 个文件)
│   │   ├── PasteboardService.swift
│   │   ├── ClipboardMonitor.swift
│   │   └── AppDetectionService.swift
│   │
│   ├── Managers/                    # 管理器层 (3 个文件)
│   │   ├── StatusBarManager.swift
│   │   ├── PopoverManager.swift
│   │   └── EventMonitor.swift
│   │
│   ├── ViewModels/                  # MVVM 视图模型层 (1 个文件)
│   │   └── ClipListViewModel.swift
│   │
│   ├── Views/                       # SwiftUI 视图层 (7 个文件)
│   │   ├── MainPopoverView.swift
│   │   ├── SearchBarView.swift
│   │   ├── FilterTabView.swift
│   │   ├── ClipListView.swift
│   │   ├── ClipListRow.swift
│   │   └── SettingsView.swift
│   │
│   ├── Utilities/                   # 工具类 (2 个文件)
│   │   ├── ContentTypeDetector.swift
│   │   └── Constants.swift
│   │
│   ├── Resources/                   # 资源文件
│   │   └── Assets.xcassets/
│   │       └── AppIcon.appiconset/
│   │
│   ├── ClipMasterApp.swift          # 应用入口
│   └── AppDelegate.swift            # 应用生命周期管理
│
├── README.md                        # 项目说明
├── QUICKSTART.md                    # 快速开始指南
├── PROJECT_SUMMARY.md               # 项目完成总结
├── CLAUDE.md                        # 项目设计文档
├── Info.plist.example               # Info.plist 配置示例
└── .gitignore                       # Git 忽略配置
```

## 文件详细说明

### 应用入口 (2 个文件)

| 文件 | 说明 | 核心功能 |
|------|------|----------|
| ClipMasterApp.swift | 应用主入口 | 配置应用场景,设置 AppDelegate |
| AppDelegate.swift | 应用生命周期 | 启动监听器,权限请求,配置应用策略 |

### 数据模型层 (3 个文件)

| 文件 | 说明 | 核心功能 |
|------|------|----------|
| ClipType.swift | 剪切板类型枚举 | 定义 text/image/url/color 等类型 |
| ClipItem.swift | 剪切板项目模型 | 数据结构定义,Codable 支持 |
| BlacklistApp.swift | 黑名单应用模型 | 黑名单应用数据结构 |

### 数据库层 (4 个文件)

| 文件 | 说明 | 核心功能 |
|------|------|----------|
| DatabaseManager.swift | 数据库连接管理 | SQLite 连接,SQL 执行方法 |
| DatabaseSetup.swift | 数据库初始化 | 创建表结构,插入默认数据 |
| ClipItemDAO.swift | 剪切板数据访问 | CRUD 操作,搜索,过滤 |
| BlacklistDAO.swift | 黑名单数据访问 | 黑名单应用增删查 |

### 核心服务层 (3 个文件)

| 文件 | 说明 | 核心功能 |
|------|------|----------|
| PasteboardService.swift | 剪切板服务 | 封装 NSPasteboard API |
| ClipboardMonitor.swift | 剪切板监听器 | 轮询监听,数据提取,保存 |
| AppDetectionService.swift | 应用检测服务 | 获取前台应用,权限检查 |

### 管理器层 (3 个文件)

| 文件 | 说明 | 核心功能 |
|------|------|----------|
| StatusBarManager.swift | 状态栏管理 | 创建状态栏图标,处理点击 |
| PopoverManager.swift | Popover 管理 | 显示/隐藏弹出窗口 |
| EventMonitor.swift | 事件监听器 | 监听点击外部区域事件 |

### ViewModel 层 (1 个文件)

| 文件 | 说明 | 核心功能 |
|------|------|----------|
| ClipListViewModel.swift | 列表视图模型 | 数据管理,搜索过滤,操作处理 |

### 视图层 (7 个文件)

| 文件 | 说明 | 核心功能 |
|------|------|----------|
| MainPopoverView.swift | 主界面 | 整体布局,搜索栏,列表 |
| SearchBarView.swift | 搜索栏 | 搜索输入,清除按钮 |
| FilterTabView.swift | 过滤标签 | 类型标签选择 |
| ClipListView.swift | 列表视图 | 显示所有剪切板项目 |
| ClipListRow.swift | 列表行组件 | 单个项目显示,操作按钮 |
| SettingsView.swift | 设置界面 | 黑名单应用管理 |

### 工具类 (2 个文件)

| 文件 | 说明 | 核心功能 |
|------|------|----------|
| ContentTypeDetector.swift | 类型识别工具 | URL,颜色,文件路径检测 |
| Constants.swift | 常量定义 | 应用常量,通知名称 |

### 文档文件 (5 个文件)

| 文件 | 说明 |
|------|------|
| README.md | 项目说明和技术架构 |
| QUICKSTART.md | 快速开始指南 |
| PROJECT_SUMMARY.md | 项目完成总结 |
| CLAUDE.md | 项目设计文档 |
| Info.plist.example | Info.plist 配置示例 |
| .gitignore | Git 忽略配置 |

## 统计信息

- **Swift 源文件**: 24 个
- **代码行数**: 约 3000+ 行
- **文档文件**: 5 个
- **资源目录**: 1 个 (Assets.xcassets)
- **总文件数**: 约 30+ 个

## 文件依赖关系

```
ClipMasterApp.swift
    └── AppDelegate.swift
            ├── DatabaseManager.swift
            │       ├── ClipItemDAO.swift
            │       └── BlacklistDAO.swift
            ├── ClipboardMonitor.swift
            │       ├── PasteboardService.swift
            │       └── AppDetectionService.swift
            └── StatusBarManager.swift
                    └── PopoverManager.swift
                            └── MainPopoverView.swift
                                    ├── ClipListViewModel.swift
                                    │       ├── ClipItemDAO.swift
                                    │       └── PasteboardService.swift
                                    ├── SearchBarView.swift
                                    ├── FilterTabView.swift
                                    ├── ClipListView.swift
                                    │       └── ClipListRow.swift
                                    └── SettingsView.swift
```

## 下一步

1. 在 Xcode 中创建项目
2. 导入所有源文件
3. 配置 Info.plist 权限
4. 构建并运行

详细步骤请参考 [QUICKSTART.md](QUICKSTART.md)
