# ScriptRunner

在 PowerShell 中根据 shebang 选择解释器运行脚本，支持本地脚本名补全和 fzf 选择。

## 加载模块

```powershell
Import-Module ScriptRunner
```

加载后即可使用 `runs`（`Invoke-LocalScript` 的别名）运行脚本并获取脚本名补全。

[fzf 选择器](#fzf-选择器) 需另外启用，详见下文。

## 运行脚本

### 用法

```powershell
runs <script> [args]
```

- `script` 必填。接受相对路径、绝对路径和裸文件名，其中裸文件名会在 `~/.local/bin` 中查找。
- `args` 可选。将被传给目标脚本。

### 示例

```powershell
runs git-push.sh
runs D:\backup.sh --target 'D:\My Backups'
runs ./tools/example.py --help
```

### 执行行为

- 保持当前工作目录，不切换到脚本所在目录。
- 保留脚本的标准输出和标准错误，不捕获为额外的结果对象。
- 外部程序的退出码保存在 `$LASTEXITCODE` 中。

## 补全与选择

### 脚本名补全

`runs` 对裸文件名提供了补全。

输入 `runs git-p` 后按 Tab，可以补全为 `runs 'git-push.sh'`。候选项来自 `~/.local/bin` 顶层目录中的 `.ps1` 文件和有 shebang 的文件。

可以运行 `Get-LocalScript` 查看候选文件。

### fzf 选择器

选择器依赖 fzf 和 PSReadLine，启用此功能需执行：

```powershell
Enable-ScriptPicker
```

使用 **Alt+s** 打开脚本列表，输入名称筛选，按下回车选择。

对于用户输入缓冲区的各种状态，选择后会有不同的行为：

| 当前输入状态 | 选择后的行为             |
| ------------ | ------------------------ |
| 空命令行     | 填入 `runs '<script>' `  |
| 已有命令行   | 在光标处插入 `<script> ` |
| 取消选择     | 保持原有输入             |

## 解释器选择

优先读取脚本的 shebang，支持以下形式：

| shebang 示例                  | 解释器与参数                              |
| ----------------------------- | ----------------------------------------- |
| `#!/bin/sh`                   | PATH 中的 `sh`                            |
| `#!/opt/venv/bin/python -u`   | PATH 中的 `python`，附加 `-u` 参数        |
| `#!/usr/bin/env python`       | PATH 中的 `env`，附加 `python` 参数       |
| `#!/usr/bin/env -S python -u` | PATH 中的 `env`，附加 `-S python -u` 参数 |

- 解释器部分，只获取路径中最后一个 `/` 后面的值作为解释器
- 参数部分，会完整传递，不自动拆分，也不解析其中的引号和转义。

没有 shebang 的 `.ps1` 使用 `pwsh -NoProfile -File` 执行；其他无 shebang 文件报错。

可以运行 `Get-ScriptInterpreter example.py` 查看解析结果。
