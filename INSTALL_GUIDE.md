# ClipMaster 安装指南

## 方法一: 快速安装 (推荐)

### 前置条件

您需要安装 Xcode:
```bash
# 检查 Xcode 是否已安装
xcodebuild -version

# 如果未安装,从 App Store 安装 Xcode
open "macappstore://apps.apple.com/app/xcode/id497799835"
```

### 自动化安装步骤

1. **打开自动化脚本**:
   ```bash
   cd /Users/yaoo13/ai/ClipMaster
   ./quick_setup.sh
   ```

2. **在 Xcode 中创建项目**:
   - 选择 `File > New > Project`
   - 选择 `macOS > App`
   - 填写项目信息:
     - Product Name: **ClipMaster**
     - Bundle ID: **com.example.ClipMaster**
     - Interface: **SwiftUI**
     - Language: **Swift**

3. **导入源文件**:
   - 在 Finder 中打开 `/Users/yaoo13/ai/ClipMaster/ClipMaster/`
   - 将所有文件夹和 `.swift` 文件拖入 Xcode 项目导航器
   - 勾选 "Copy items if needed"
   - 确保选中 "ClipMaster" target

4. **配置权限**:
   - 选择项目 > Target > Info
   - 添加以下键值:
     ```
     NSAccessibilityUsageDescription:
     需要辅助功能权限以获取前台应用信息,实现隐私保护功能

     NSAppleEventsUsageDescription:
     需要脚本权限以检测前台应用
     ```

5. **构建运行**:
   - 按 `⌘+R` 或点击 Run 按钮

---

## 方法二: 完全手动安装

如果自动化脚本无法使用,请按照以下详细步骤操作:

### 步骤 1: 安装 Xcode

1. 从 App Store 搜索并安装 "Xcode"
2. 打开 Xcode 并同意许可协议
3. 安装额外组件:
   ```bash
   xcode-select --install
   ```

### 步骤 2: 创建 Xcode 项目

1. 打开 Xcode
2. 选择 `File > New > Project`
3. 选择 `macOS` 标签
4. 选择 `App` 模板
5. 点击 `Next`

### 步骤 3: 配置项目

填写以下信息:

| 字段 | 值 |
|------|-----|
| Product Name | ClipMaster |
| Team | 选择您的团队 (或 None) |
| Organization Identifier | com.example |
| Bundle Identifier | com.example.ClipMaster |
| Interface | SwiftUI |
| Language | Swift |
| Use Core Data | ❌ 取消勾选 |

点击 `Next`,保存位置选择 `/Users/yaoo13/ai/ClipMaster`

### 步骤 4: 删除默认文件

在项目导航器中:
1. 找到 `ClipMasterView.swift`
2. 右键点击 > Delete
3. 选择 "Move to Trash"

### 步骤 5: 导入源文件

在 Finder 中打开 `/Users/yaoo13/ai/ClipMaster/ClipMaster/`

将以下文件夹拖入 Xcode 项目导航器:
```
✓ Models/
✓ Database/
✓ Services/
✓ Managers/
✓ ViewModels/
✓ Views/
✓ Utilities/
✓ ClipMasterApp.swift
✓ AppDelegate.swift
```

在弹出的对话框中:
- ✅ 勾选 "Copy items if needed"
- 选择 "Create groups"
- 确保 "ClipMaster" target 被选中
- 点击 "Finish"

### 步骤 6: 配置 Info.plist

1. 选择项目文件 (导航器最顶部)
2. 选择 Target > ClipMaster > Info 标签
3. 点击 "+" 按钮,添加以下内容:

**添加第 1 项**:
- Key: `NSAccessibilityUsageDescription`
- Type: `String`
- Value: `需要辅助功能权限以获取前台应用信息,实现隐私保护功能`

**添加第 2 项**:
- Key: `NSAppleEventsUsageDescription`
- Type: `String`
- Value: `需要脚本权限以检测前台应用`

### 步骤 7: 设置部署目标

1. 选择项目文件
2. 在 "Deployment" 部分
3. 设置 "Minimum Deployments" 为: **macOS 12.0**

### 步骤 8: 构建和运行

1. 选择 "My Mac" 作为运行目标
2. 按 `⌘+R` 或点击播放按钮
3. 应用会编译并运行

---

## 首次运行设置

### 授予辅助功能权限

应用首次运行时会提示需要辅助功能权限:

1. 点击对话框中的 "好"
2. 系统会打开 "系统偏好设置"
3. 进入 **隐私与安全性 > 辅助功能**
4. 找到 "ClipMaster" 并勾选
5. 重启 ClipMaster

**或者手动设置**:
1. 打开 "系统偏好设置"
2. 进入 "隐私与安全性 > 辅助功能"
3. 点击左下角的锁图标解锁
4. 点击 "+" 按钮
5. 选择 "ClipMaster.app"
6. 勾选 ClipMaster

### 开始使用

1. 应用启动后会在状态栏显示剪切板图标 📋
2. 点击图标打开剪切板历史
3. 复制任何内容后会自动记录
4. 点击列表项可快速复制

---

## 构建发布版本

### 开发版本

在 Xcode 中:
1. 选择 `Product > Build` (⌘+B)
2. 构建产物位于: `~/Library/Developer/Xcode/DerivedData/ClipMaster-*/Build/Products/Debug/ClipMaster.app`

### 发布版本

1. 选择 `Product > Scheme > Edit Scheme`
2. 选择 "Run" > "Build Configuration"
3. 选择 "Release"
4. 关闭对话框
5. 选择 `Product > Build` (⌘+B)

发布版本位于: `~/Library/Developer/Xcode/DerivedData/ClipMaster-*/Build/Products/Release/ClipMaster.app`

### 归档应用

1. 选择 `Product > Archive`
2. 在 Organizer 窗口中:
   - 选择归档
   - 点击 "Distribute App"
   - 选择 "Copy" (用于本地分发)
   - 点击 "Distribute"

---

## 常见问题

### Q1: 编译错误 "Cannot find type 'NSPasteboard' in scope"

**解决方案**:
- 确保文件顶部有 `import AppKit`
- 如果仍有问题,清理项目 (`Product > Clean Build Folder`)

### Q2: 应用启动后状态栏没有图标

**解决方案**:
- 检查 `AppDelegate.swift` 中的 `setupAsAgentApp()` 方法
- 确保应用激活策略设置为 `.accessory`

### Q3: 无法获取前台应用信息

**解决方案**:
- 确保已授予辅助功能权限
- 重启应用
- 如果问题持续,检查系统偏好设置中的权限

### Q4: 数据库连接失败

**解决方案**:
- 检查 Application Support 目录权限
- 确保应用有读写权限:
  ```bash
  ls -la ~/Library/Application\ Support/ClipMaster/
  ```

### Q5: Xcode 要求开发团队

**解决方案**:
- 对于本地开发,可以选择 "None"
- 或者在 Xcode > Preferences > Accounts 中添加 Apple ID

---

## 分发应用

### 方法 1: 直接拷贝

构建后的应用可以直接拷贝到其他 Mac:

1. 在 Xcode 中构建 Release 版本
2. 找到 `ClipMaster.app`
3. 拷贝到 U 盘或其他存储设备
4. 在目标 Mac 上双击运行

**注意**: 首次运行可能需要右键点击 > "打开" (绕过 Gatekeeper)

### 方法 2: 创建 DMG 安装包

```bash
# 使用 hdiutil 创建 DMG
hdiutil create -volname "ClipMaster" -srcfolder ClipMaster.app -ov -format UDZO ClipMaster.dmg
```

### 方法 3: App Store 发布

1. 注册 Apple Developer Program
2. 在 Xcode 中配置代码签名
3. 上传到 App Store Connect
4. 提交审核

---

## 卸载

1. 退出 ClipMaster 应用
2. 删除应用: `ClipMaster.app`
3. 删除数据:
   ```bash
   rm -rf ~/Library/Application\ Support/ClipMaster
   rm -rf ~/Library/Preferences/com.example.ClipMaster.plist
   ```

---

## 下一步

- [ ] 自定义应用图标
- [ ] 添加全局快捷键
- [ ] 实现云同步功能
- [ ] 提交到 App Store

---

## 获取帮助

- 查看项目文档: `QUICKSTART.md`
- 查看项目总结: `PROJECT_SUMMARY.md`
- 查看文件清单: `FILE_LIST.md`

---

*最后更新: 2025-01-18*
