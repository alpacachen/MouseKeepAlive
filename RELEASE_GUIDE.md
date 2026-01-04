# 发布指南

本指南介绍如何发布 MouseKeepAlive 的新版本。

## 📋 发布前检查清单

### 代码准备
- [ ] 所有功能已完成并测试
- [ ] 代码已合并到 main 分支
- [ ] 所有 CI 检查通过
- [ ] 更新了 README.md（如有新功能）
- [ ] 更新了 DEBUG.md（如有新的排查方法）

### 版本信息
- [ ] 确定版本号（遵循 [语义化版本](https://semver.org/lang/zh-CN/)）
  - 重大变更：v2.0.0
  - 新功能：v1.1.0
  - Bug 修复：v1.0.1
- [ ] 准备好更新日志（Changelog）

## 🚀 发布步骤

### 方式一：手动发布（推荐用于首次发布）

#### 1. 本地构建

```bash
# 清理并构建
./build_release.sh

# 测试构建的应用
open build/Release/MouseKeepAlive.app

# 验证功能
# - 权限请求正常
# - 鼠标/键盘监听正常
# - 配置保存正常
# - 菜单栏交互正常
```

#### 2. 创建 Git Tag

```bash
# 确保在 main 分支
git checkout main
git pull origin main

# 创建并推送 tag
VERSION="v1.0.0"  # 修改为实际版本号
git tag -a ${VERSION} -m "Release ${VERSION}"
git push origin ${VERSION}
```

#### 3. 创建 GitHub Release

使用 GitHub CLI（推荐）：

```bash
VERSION="v1.0.0"

gh release create ${VERSION} \
  build/Release/MouseKeepAlive.app.zip \
  build/Release/MouseKeepAlive.app.zip.sha256 \
  --title "MouseKeepAlive ${VERSION}" \
  --notes-file .github/RELEASE_TEMPLATE.md
```

或者手动操作：

1. 访问 https://github.com/yourusername/MouseKeepAlive/releases/new
2. 选择刚才创建的 tag
3. 填写发布标题和说明
4. 上传文件：
   - `MouseKeepAlive.app.zip`
   - `MouseKeepAlive.app.zip.sha256`
5. 点击「Publish release」

### 方式二：自动发布（使用 GitHub Actions）

当你推送带有 `v*` 格式的 tag 时，GitHub Actions 会自动构建并发布：

```bash
# 创建并推送 tag
git tag v1.0.0
git push origin v1.0.0

# GitHub Actions 会自动：
# 1. 构建应用
# 2. 创建 ZIP 压缩包
# 3. 计算校验和
# 4. 创建 GitHub Release
# 5. 上传文件
```

## 📝 发布说明模板

```markdown
## 🎉 主要更新

- **新功能**: 描述新功能
- **改进**: 描述改进点
- **修复**: 描述修复的 Bug

## 📦 下载

- [MouseKeepAlive.app.zip](链接)
- [SHA256 校验和](链接)

### 安装方法

1. 下载 ZIP 文件
2. 解压缩
3. 拖入「应用程序」文件夹
4. 首次打开需要右键点击 → 打开

## ⚠️ 重要提示

- 需要 macOS 13.0+
- 需要辅助功能权限

## 🔄 从旧版本升级

直接替换应用即可，配置会自动保留。

## 🐛 已知问题

列出已知问题（如果有）
```

## 📱 发布后

### 1. 验证发布

- [ ] 下载发布的 ZIP 文件
- [ ] 验证 SHA256 校验和
- [ ] 在干净的 macOS 环境测试安装
- [ ] 确认所有功能正常

### 2. 更新文档

- [ ] 更新 README.md 中的版本号引用
- [ ] 更新徽章（如果显示版本号）

### 3. 宣传

- [ ] 在项目 README 顶部添加最新版本链接
- [ ] 社交媒体宣传（可选）
- [ ] 更新相关文档/博客（可选）

## 🔄 回滚发布

如果发现严重问题需要回滚：

1. 在 GitHub Releases 页面删除有问题的版本
2. 删除对应的 Git tag：
   ```bash
   git tag -d v1.0.0
   git push origin :refs/tags/v1.0.0
   ```
3. 修复问题后重新发布

## 📊 版本管理

### 版本号规则

遵循语义化版本 (SemVer)：`MAJOR.MINOR.PATCH`

- **MAJOR**: 不兼容的 API 修改
- **MINOR**: 向下兼容的功能性新增
- **PATCH**: 向下兼容的问题修正

### 示例

- `v1.0.0` - 首次正式发布
- `v1.0.1` - Bug 修复
- `v1.1.0` - 新增功能
- `v2.0.0` - 重大更新

## 🛠️ 故障排查

### 构建失败

```bash
# 清理 Xcode 缓存
rm -rf ~/Library/Developer/Xcode/DerivedData

# 清理项目构建
xcodebuild clean

# 重新构建
./build_release.sh
```

### GitHub Actions 失败

1. 检查 Actions 页面的日志
2. 常见问题：
   - Xcode 版本不匹配
   - 权限问题
   - 构建配置错误

## 📞 获取帮助

遇到问题？

- 查看 GitHub Actions 日志
- 检查 [GitHub Discussions](链接)
- 提交 [Issue](链接)
