---
title: Pnpm 访问数据库文件失败
completed: true
---

## 复现方式

在沙箱内运行 `pnpm exec tsx scripts/grammars/fetch.ts jq` 和 `pnpm lint --fix` 均会产生如下错误：

```log
[ERROR] unable to open database file
```

## 问题分析

pnpm 运行任务前会尝试访问数据库文件，而当前沙箱没有访问这些文件的权限。

该问题会导致正常的 pnpm 命令失败。

## 修复建议

### 方法一：修改 Codex 配置

1. 确认 pnpm 实际使用的 store 路径。
2. 将对应目录加入 `~/.codex/config.toml` 的 `sandbox_workspace_write.writable_roots` 中。

### 方法二：沙箱外执行命令

让受信任的 `pnpm` 命令申请沙箱外执行权限，但这会触发额外的审批。
