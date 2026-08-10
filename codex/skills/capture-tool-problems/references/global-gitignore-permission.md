---
title: Git 访问全局 ignore 文件失败
source: "Codex shell_command: git status"
completed: true
---

## 复现方式

在沙箱内运行 `git status` 时出现如下警告：

```log
warning: unable to access 'C:\Users\user/.config/git/ignore': Permission denied
```

## 问题分析

Git 执行 `git status` 时尝试访问 `~/.config/git/ignore` 文件，而当前沙箱无法访问该文件。

## 修复建议

### 方法一：修改 Git 全局配置

#### 修复流程

在 Shell 中运行如下命令：

```sh
git config --global core.excludesFile ""
```

#### 修复原理

将 Git 的 `core.excludesFile` 设置为空，可以禁止 Git 使用全局 ignore 文件，这样 `git status` 就不会尝试访问 `~/.config/git/ignore`。

参考：https://git-scm.com/docs/git-config#Documentation/git-config.txt-coreexcludesFile

#### 修复适用情况

如果需要让 Git 使用全局 ignore 文件，则不适用此方法。

### 方法二：修改 Codex 会话的沙箱权限

#### 修复流程

在 Codex CLI 中执行如下命令：

```console
/sandbox-add-read-dir C:\Users\user\.config\git
```

#### 修复原理

Codex 提供的 `/sandbox-add-read-dir` 命令用于给 Windows Codex 沙箱增加某个目录的读取权限。

参考：https://learn.chatgpt.com/docs/windows/windows-sandbox#grant-sandbox-read-access

#### 修复适用情况

读取权限仅在当前会话中生效，如需永久修复则不适用此方法。

### 方法三：修改 Codex 全局配置

#### 修复流程

在 `~/.codex/config.toml` 文件中添加如下内容：

```toml
default_permissions = "workspace-with-git-config"

[permissions.workspace-with-git-config]
extends = ":workspace"

[permissions.workspace-with-git-config.filesystem]
"~/.config/git" = "read"
```

然后删除 `sandbox_mode` 和 `sandbox_workspace_write` 相关配置。

#### 修复原理

较新的 Codex 支持 permission profile，可以基于 `:workspace` 增加对某个目录的只读权限。

但该配置与旧的 `sandbox_mode` 和 `sandbox_workspace_write` 组合冲突，不能同时使用两者。

参考：

- https://learn.chatgpt.com/docs/permissions#filesystem-permissions
- https://learn.chatgpt.com/docs/permissions#migrate-from-older-sandbox-settings

#### 修复适用情况

该方法需要较新的 Codex 版本，且和旧的沙箱配置冲突，需要一些迁移时间。
