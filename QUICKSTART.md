# ClipMaster 快速开始指南

## 项目状态

✅ 核心代码已完成,需要在 Xcode 中创建项目并导入源文件。

## 快速开始步骤

### 1. 在 Xcode 中创建项目

1. 打开 Xcode
2. 选择 **File > New > Project**
3. 选择 **macOS > App**
4. 填写项目信息:
   - **Product Name**: `ClipMaster`
   - **Team**: 选择你的开发团队
   - **Organization Identifier**: `com.example`
   - **Interface**: SwiftUI
   - **Language**: Swift
   - 取消勾选 "Use Core Data"
5. 选择保存位置: `/Users/yaoo13/ai/ClipMaster`
6. 点击 **Create**

### 2. 配置项目权限

在 Xcode 项目中:

1. 选择 `ClipMaster` target
2. 选择 **Info** 标签
3. 添加以下权限:

```xml
<key>NSAccessibilityUsageDescription</key>
<string>需要辅助功能权限以获取前台应用信息,实现隐私保护功能</string>

<key>NSAppleEventsUsageDescription</key>
<string>需要脚本权限以检测前台应用</string>
```

或者直接将 `Info.plist.example` 的内容复制到 Info.plist。

### 3. 导入源文件

将以下目录中的文件拖入 Xcode 项目 (在项目导航器中):

```
ClipMaster/
├── Models/
├── Services/
├── Managers/
├── Views/
├── ViewModels/
├── Database/
└── Utilities/
```

**重要提示**:
- 确保勾选 **"Copy items if needed"**
- 确保选中 **"ClipMaster" target**
- 选择 **"Create groups"**

### 4. 删除默认文件

删除 Xcode 自动创建的以下文件:
- `ClipMasterView.swift` (我们有自己的 MainPopoverView)

### 5. 配置项目设置

1. 选择项目文件 (最顶部的 ClipMaster)
2. 在 **Deployment Target** 中设置: **macOS 12.0**

### 6. 构建并运行

1. 选择 **My Mac** 作为运行目标
2. 点击 Run 按钮 (⌘+R)

## 首次运行

### 授权辅助功能权限

首次运行时,应用会请求辅助功能权限:

1. 点击对话框中的 **"好"**
2. 系统会打开 **系统偏好设置**
3. 在 **隐私与安全性 > 辅助功能** 中找到 **ClipMaster**
4. 勾选 ClipMaster 旁边的开关
5. 重启 ClipMaster

### 使用应用

1. 应用启动后会在状态栏显示一个剪切板图标 📋
2. 点击图标可以打开剪切板历史记录
3. 复制任何内容后会自动记录
4. 点击列表项可以快速复制
5. 使用搜索框和类型标签过滤历史记录

## 项目结构说明

```
ClipMaster/
├── Models/                    # 数据模型
│   ├── ClipType.swift        # 剪切板类型枚举
│   ├── ClipItem.swift        # 剪切板项目模型
│   └── BlacklistApp.swift    # 黑名单应用模型
│
├── Database/                  # 数据库层
│   ├── DatabaseManager.swift # SQLite 连接管理
│   ├── DatabaseSetup.swift   # 数据库初始化
│   ├── ClipItemDAO.swift     # 剪切板数据访问
│   └── BlacklistDAO.swift    # 黑名单数据访问
│
├── Services/                  # 核心服务
│   ├── PasteboardService.swift    # 剪切板操作
│   ├── ClipboardMonitor.swift     # 剪切板监听
│   └── AppDetectionService.swift  # 前台应用检测
│
├── Managers/                  # 管理器
│   ├── StatusBarManager.swift     # 状态栏管理
│   ├── PopoverManager.swift       # 弹出窗口管理
│   └── EventMonitor.swift         # 事件监听
│
├── ViewModels/               # 视图模型
│   └── ClipListViewModel.swift    # 列表视图模型
│
├── Views/                    # SwiftUI 视图
│   ├── MainPopoverView.swift     # 主界面
│   ├── SearchBarView.swift       # 搜索栏
│   ├── FilterTabView.swift       # 过滤标签
│   ├── ClipListView.swift        # 列表视图
│   ├── ClipListRow.swift         # 列表行
│   └── SettingsView.swift        # 设置界面
│
├── Utilities/                # 工具类
│   ├── ContentTypeDetector.swift # 内容类型识别
│   └── Constants.swift          # 常量定义
│
├── ClipMasterApp.swift       # 应用入口
└── AppDelegate.swift         # 应用生命周期
```

## 常见问题

### Q: 编译错误 "Cannot find type 'NSPasteboard' in scope"

A: 确保在文件顶部添加了 `import AppKit`

### Q: 应用启动后状态栏没有图标

A: 检查 `AppDelegate.swift` 中的 `setupAsAgentApp()` 方法,确保应用设置为代理模式

### Q: 无法获取前台应用信息

A: 确保已授予辅助功能权限,并重启应用

### Q: 数据库连接失败

A: 检查 Application Support 目录的权限,确保应用有读写权限

## 下一步

- [ ] 添加全局快捷键支持
- [ ] 实现云同步功能
- [ ] 添加更多数据类型支持
- [ ] 优化性能和内存使用

## 技术支持

如有问题,请查看:
- 项目 README.md
- CLAUDE.md (项目设计文档)
- 实施计划: `/Users/yaoo13/.claude/plans/calm-napping-narwhal.md`
