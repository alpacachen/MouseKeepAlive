# 贡献指南

感谢你对 MouseKeepAlive 项目的关注！我们欢迎各种形式的贡献。

## 🎯 如何贡献

### 报告 Bug

如果你发现了 bug，请通过 GitHub Issues 报告：

1. 检查是否已有类似的 issue
2. 使用 Bug Report 模板创建新 issue
3. 提供详细的复现步骤和环境信息
4. 附上相关日志或截图

### 提出功能建议

我们欢迎新功能的建议：

1. 通过 GitHub Issues 提交
2. 描述功能的用途和使用场景
3. 说明为什么需要这个功能
4. 如果可能，提供实现思路

### 提交代码

#### 准备工作

1. Fork 本仓库到你的账号
2. 克隆 forked 仓库到本地
   ```bash
   git clone https://github.com/YOUR_USERNAME/MouseKeepAlive.git
   ```
3. 添加上游仓库
   ```bash
   git remote add upstream https://github.com/ORIGINAL_OWNER/MouseKeepAlive.git
   ```

#### 开发流程

1. **创建分支**
   ```bash
   git checkout -b feature/your-feature-name
   # 或
   git checkout -b fix/your-bug-fix
   ```

2. **进行开发**
   - 遵循现有的代码风格
   - 添加必要的注释
   - 确保代码可以编译通过

3. **测试**
   - 在 macOS 13.0+ 上测试
   - 验证辅助功能权限流程
   - 测试键盘和鼠标监听功能

4. **提交更改**
   ```bash
   git add .
   git commit -m "feat: 添加新功能"
   # 或
   git commit -m "fix: 修复某个问题"
   ```

   **提交信息规范：**
   - `feat: 新功能`
   - `fix: Bug 修复`
   - `docs: 文档更新`
   - `style: 代码格式调整`
   - `refactor: 代码重构`
   - `test: 测试相关`
   - `chore: 构建/工具链相关`

5. **同步上游更改**
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

6. **推送到你的仓库**
   ```bash
   git push origin feature/your-feature-name
   ```

7. **创建 Pull Request**
   - 在 GitHub 上创建 PR
   - 填写 PR 模板
   - 描述清楚改动内容和原因
   - 关联相关的 issue（如果有）

## 📝 代码规范

### Swift 代码风格

- 使用 4 个空格缩进
- 类名使用大驼峰命名（PascalCase）
- 函数和变量使用小驼峰命名（camelCase）
- 常量使用小驼峰命名
- 适当添加注释，特别是复杂逻辑

### 项目结构

```
MouseKeepAlive/
├── MouseKeepAliveApp.swift    # 应用入口，保持简洁
├── AppDelegate.swift           # 菜单栏和 UI 相关
├── MouseMonitor.swift          # 核心监控逻辑
├── AppSettings.swift           # 配置管理
└── Info.plist                  # 应用配置
```

### 最佳实践

1. **职责分离**：每个文件保持单一职责
2. **错误处理**：适当使用 `guard` 和错误处理
3. **内存管理**：注意使用 `[weak self]` 避免循环引用
4. **日志输出**：使用 `print` 输出关键信息，便于调试
5. **权限检查**：所有涉及系统权限的操作都要检查权限状态

## 🧪 测试

在提交 PR 前，请确保：

- [ ] 应用可以正常编译
- [ ] 权限请求流程正常
- [ ] 鼠标监听功能正常
- [ ] 键盘监听功能正常
- [ ] 配置保存和读取正常
- [ ] 菜单栏交互正常

## 📚 文档

如果你的更改涉及到：

- 新功能：更新 README.md
- Bug 修复：在 DEBUG.md 中添加排查方法
- API 变更：更新相关文档

## ❓ 获取帮助

有问题？可以通过以下方式寻求帮助：

- 查看 [README.md](README.md)
- 查看 [DEBUG.md](DEBUG.md)
- 在 GitHub Issues 中提问
- 查看已有的 Pull Requests

## 🎉 成为贡献者

一旦你的 PR 被合并，你将：

- 在项目的贡献者列表中出现
- 获得我们的感谢和认可
- 成为开源社区的一员

感谢你为开源项目做出贡献！🙏
