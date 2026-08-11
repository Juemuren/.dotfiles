---
title: Node.js 证书报错
completed: true
---

## 复现方式

Octokit 通过 Node.js 请求 GitHub API 时产生如下错误：

```log
Error: unable to verify the first certificate
code: 'UNABLE_TO_VERIFY_LEAF_SIGNATURE'
```

## 问题分析

Node.js 默认信任链没有包含当前网络环境使用的根证书。

## 修复建议

设置环境变量让 Node 使用系统 CA：

```env
NODE_USE_SYSTEM_CA=1
```

参考：https://nodejs.org/api/cli.html#node_use_system_ca1
