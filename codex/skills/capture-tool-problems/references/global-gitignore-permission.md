---
date: 2026-08-09T12:00:00+08:00
cwd: C:\work\repo
command: "git status"
completed: true
---

## 问题日志

```log
warning: unable to access 'C:\Users\user/.config/git/ignore': Permission denied
```

## 问题分析

`git status` 本身执行成功，退出码为 `0`。该问题没有影响命令的执行。

产生警告的原因是，Git 尝试访问 `C:\Users\user/.config/git/ignore` 文件，而当前沙箱无法访问该文件。

## 修复建议

### 方法一：修改 Git 全局配置

#### 修复流程

在 Shell 中运行

```sh
git config --global core.excludesFile ""
```

#### 修复原理

让 Git 不使用全局的 ignore 文件，这样 `git status` 就不会尝试访问 `~/.config/git/ignore`。

https://git-scm.com/docs/git-config/2.54.0

#### 适用情况

如果需要让 Git 使用全局 ignore 文件，则不适用此方法。

### 方法二：修改 Codex 会话的沙箱权限

#### 修复流程

在 Codex CLI 中运行

```console
/sandbox-add-read-dir C:\Users\user\.config\git
```

#### 修复原理

Codex 提供的 `/sandbox-add-read-dir` 命令用于给 Windows Codex 沙箱增加某个目录的读取权限。

https://developers.openai.com/codex/windows/windows-sandbox

#### 适用情况

读取权限仅在当前会话中生效，如需永久修复则不适用此方法。

### 方法三：修改 Codex 全局配置

#### 修复流程

修改 `~/.codex/config.toml` 文件，添加如下内容

```toml
default_permissions = "workspace-with-git-config"

[permissions.workspace-with-git-config]
extends = ":workspace"

[permissions.workspace-with-git-config.filesystem]
"~/.config/git" = "read"
```

然后删除 `sandbox_mode` 和 `sandbox_workspace_write` 相关配置。

#### 修复原理

较新的 Codex 支持 permission profile，可以基于 `:workspace` 增加对 Git 配置目录的只读权限。

但该配置与旧的 `sandbox_mode` 和 `sandbox_workspace_write` 组合冲突，不能同时使用两者。

https://learn.chatgpt.com/docs/permissions

#### 适用情况

该方法需要较新的 Codex 版本，且和旧的沙箱配置冲突，需要一些迁移时间。
