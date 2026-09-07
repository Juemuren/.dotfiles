---
name: develop-automation-scripts
description: 创建、修改、测试、检查并格式化可复用的 POSIX shell、Bash、PowerShell、Pwsh 或 Python 自动化脚本。当要求创建或修改这些语言的自动化脚本时使用；不用于一般 Python 应用或库的开发。
---

# 开发自动化脚本

## 选择语言

- 尊重用户指定的语言和项目约定；修改现有脚本时优先沿用原语言；新脚本结合目标环境、运行时可用性和维护成本选择语言。
- **POSIX shell / Bash**：主要工作是调用命令、连接管道和重定向时优先选择。需要跨 Unix 环境且无需 Bash 特性时使用 POSIX shell；需要数组等 Bash 特性时使用 Bash。
- **PowerShell / Pwsh**：主要工作依赖 Windows 管理接口、PowerShell cmdlet、对象管道或 .NET 时优先选择；可以大胆使用新版 PowerShell 专有的语法；只有当任务明确要求需要运行在只有旧版 Powershell 的 Windows 平台上时，才考虑兼容旧版 Powershell。
- **Python**：主要工作涉及结构化数据解析与转换、复杂控制流，或需要在 Windows / Unix 上复用同一套逻辑时优先选择。仅编排少量外部命令时通常无需引入 Python。

## 创建或修改脚本

### Shell / Pwsh 脚本

- 除非任务要求最大的兼容性，否则当使用外部程序实现功能比内置命令更方便时，优先使用外部程序。
- 对于脚本中出现的退出状态码、文件描述符、ASCII 转义序列、复杂正则或 DSL 等 Magic Number 和 Magic String，请用合适的变量表明其含义，或在注释中说明用途。

### Python 脚本

- 优先使用标准库和项目现有依赖。
- 当标准库能力不足时，且项目中不存在任何依赖时，优先考虑通过子进程调用合适的工具，而不是自己造轮子。
- 为函数参数和返回值添加有意义的类型标注，便于类型检查。

### 函数式风格

- 复杂脚本尽量遵守 **functional core, imperative shell** 的原则，将流程编排和副作用留在程序边界的命令式外壳中，而数据转换作为函数式内核应保持为纯计算；简单脚本不需要过度抽象。
- 如果问题能用一条清晰的管道解决，就不引入额外控制流或中间状态。

### 避免防御性编程

- 优先选择最小、直接、可读的修改，并保持现有脚本的抽象层级。
- 未经明确要求，不新增依赖探测、回退逻辑、兼容层等过度工程化的代码。
- 禁止为不在任务范围内的假设故障增加防御性代码；但仍应处理可能导致数据损坏或安全风险的明显故障。

## 测试

- 使用安全且有代表性的案例进行测试，确认它能复现已完成任务中的可复用部分。
- 仅当脚本已有明确的输入契约时，才测试能否让无效输入明确地失败。
- 验证时避免使用真实凭据或生产数据。底层工具支持时，先预览文件系统变更。
- 如果仓库提供针对性测试或任务运行器配方，则运行它们。

## 检查

- 对于 POSIX shell 和 Bash 脚本，使用 `sh -n` 进行语法检查，使用 `shellcheck` 进行静态检查。
- 对于 PowerShell 和 Pwsh 脚本，使用 `Invoke-ScriptAnalyzer` 进行静态检查。优先直接运行 PATH 中封装好的脚本 `Run-Lint.ps1 example.ps1`。`Run-Lint` 可以指定多个文件 `Run-Lint.ps1 -Path a.ps1, b.ps1`，同时支持管道 `fd -e ps1 -e psm1 | Run-Lint.ps1`。获取 `Run-Lint` 的完整说明请使用 `Get-Help Run-Lint.ps1 -Full`。
- 对于 Python 脚本，使用 `ruff check` 进行静态检查，使用 `ty check` 进行类型检查。

## 格式化

- 对于 POSIX shell 和 Bash 脚本，使用 `shfmt` 进行格式化。当不存在项目级的格式化要求时，使用 `-i 4 -ci -sr` 格式。
- 对于 PowerShell 和 Pwsh 脚本，使用 `Invoke-Formatter` 进行格式化。优先直接运行 PATH 中封装好的脚本 `Run-Format.ps1 example.ps1`；仅验证格式、不写入时使用 `Run-Format.ps1 example.ps1 -Check`。`Run-Format` 可以指定多个文件 `Run-Format.ps1 -Path a.ps1, b.ps1`，同时支持管道 `fd -e ps1 -e psm1 | Run-Format.ps1`。获取 `Run-Format` 的完整说明请使用 `Get-Help Run-Format.ps1 -Full`。
- 对于 Python 脚本，使用 `ruff format` 进行格式化；仅验证格式时使用 `ruff format --check`。

## 报告结果

- 报告已持久化的可复用工作、脚本路径和接口，以及它与原始任务的关系。
- 如果存在缺失的工具、未消除的检查警告、新增的抑制规则、兼容性问题或未经测试的副作用，请进行说明。
