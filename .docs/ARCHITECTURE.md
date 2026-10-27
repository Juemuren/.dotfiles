# 架构

本文讨论仓库的架构，包含自动化脚本和映射配置两个主要部分。

## 目录结构

在根目录中

```txt
.
├── .docs             # 跨模块共用的文档
├── .scripts          # 跨模块共用的脚本
├── app               # 各模块的目录
├── mise.local.toml   # 启用的模块
├── mise.toml         # 各模块顶层目录的映射
└── Justfile          # 编排命令
```

在每个模块的目录中

```txt
app
├── automation        # 自动化脚本
├── mod.just          # 自动化脚本入口
├── mise.local.toml   # 变量或机器相关的映射
├── mise.os.toml      # 各系统专有的映射
└── mise.toml         # 跨系统共用的映射
```

## 自动化脚本

### 自动化脚本的目录结构

自动化脚本包含各模块专用的脚本和跨模块共用的脚本

- 各模块专用的脚本保存在每个模块的 `automation` 下
- 跨模块共用的脚本保存在根目录的 `.scripts` 下
- 根目录的 `Justfile` 编排命令

自动化脚本的目录结构为

```txt
.
├── .scripts          # 跨模块共用的脚本
│   └── class
│       └── mod.just  # 各类脚本的入口
├── app
│   ├── automation    # 各模块专用的脚本
│   │   ├── install                # 安装脚本
│   │   ├── configure-machine-env  # 机器环境配置脚本
│   │   ├── generate-path-mappings # 路径映射生成脚本
│   │   ├── record                 # 环境记录脚本
│   │   └── restore                # 环境恢复脚本
│   └── mod.just      # 各模块脚本的入口
└── Justfile          # 编排命令
```

### 自动化脚本的入口规范

对于各模块专用的脚本

- 各模块按需提供命令，并用 `mod.just` 进行封装
- 如果脚本较为简单，可以直接写在 `*.sh` / `*.ps1` 中；如果脚本较为复杂，拆分后放在 `*` 目录下，并由 `*/index.sh` / `*/index.ps1` 进行调用
- 根目录 `Justfile` 只编排模块 `mod.just` 暴露的命令，不要侵入各模块的内部实现

对于跨模块共用的脚本

- 脚本按用途进行分类；如果类中的脚本较多，可以再拆分子类。各子类用 `mod.just` 封装命令，父类用 `mod.just` 组合子类的命令
- 根目录 `Justfile` 只编排顶级类 `mod.just` 暴露的命令，不要侵入各类的内部实现

对于各模块专用的脚本和跨模块共用的脚本

- 脚本只能在子目录中定位文件；如果需要在父目录中定位文件，那么由 `mod.just` 通过参数传入目标路径
- `*.sh` 脚本开头要写上 `shebang`，`*.ps1` 脚本开头要写上 `#Requires`
- 外部调用的命令只能使用根目录 `Justfile` 提供的入口，不要侵入各类或各模块的内部实现

### 自动化脚本的行为规范

脚本按名称区分行为

- `install` 是安装脚本
- `configure-machine-env` 是机器环境配置脚本
- `generate-path-mappings` 是路径映射生成脚本
- `record` 是环境记录脚本
- `restore` 是环境恢复脚本

对于环境记录脚本和环境恢复脚本

- **记录不保存环境的完整状态。** 所有记录的变更都应该能通过 `git diff` 清晰地查看，而软件版本、软件安装时间、软件状态等频繁变化的信息会引入大量不必要的变更。且对于个人开发环境，这类信息并不重要。
- **恢复不保证软件版本完全相同。** 优先使用最新稳定版的软件，因此恢复时出现版本漂移是预期行为。
- **记录与恢复分别维护。** 记录脚本把当前软件写入清单，恢复脚本根据清单恢复软件。可以单独记录，也可以单独恢复，不强制同步。

对于安装脚本、机器环境配置脚本和路径映射生成脚本

- **安装脚本用于接入机器初始化流程。**
- **机器环境配置脚本用于获取本机所需的环境变量并修改用户级环境变量设置。**
- **路径映射生成脚本用于根据本机状态生成映射并修改映射配置文件。**

## 映射配置

### 映射配置的目录结构

映射配置包含每个模块中的 `mise.toml` / `mise.os.toml` / `mise.local.toml` 文件。

映射配置的目录结构为

```txt
app
├── mise.local.toml   # 变量或机器相关的映射
├── mise.os.toml      # 各系统专有的映射
└── mise.toml         # 跨系统共用的映射
```

### 映射配置的文件职责

- 如果不同系统使用同一个源路径，那么映射写在 `mise.toml` 中。

  如果不同系统的目标路径不同，那么通过 `variants.os` / `variants.target` 进行区分

  ```toml
  [dotfiles.neovim]
  source = "nvim"
  mode = "symlink"
  variants = [
    { os = "windows", target = "~/AppData/Local/nvim" },
    { os = "linux", target = "~/.config/nvim" },
  ]
  ```

  如果不同系统的目标路径相同，那么通过 `variants.default = true` 表示

  ```toml
  [dotfiles.bash-scripts]
  source = "scripts"
  mode = "symlink-each"
  variants = [
    { default = true, target = "~/.local/bin" },
  ]
  ```

  或者直接把键名作为目标路径

  ```toml
  [dotfiles]
  "~/.atuin/config.toml" = { source = "config.toml", mode = "symlink" }
  ```

- 如果不同系统使用不同的源路径，那么映射写在 `mise.os.toml` 中

  ```toml
  # mise.windows.toml
  [dotfiles]
  "~/.codex/config.toml" = { source = "windows/config.toml", mode = "template" }
  "~/.codex/AGENTS.md" = { source = "windows/AGENTS.md", mode = "symlink" }
  # mise.linux.toml
  [dotfiles]
  "~/.codex/config.toml" = { source = "linux/config.toml", mode = "template" }
  "~/.codex/AGENTS.md" = { source = "linux/AGENTS.md", mode = "symlink" }
  ```

- 如果在系统相同的情况下不同机器仍然需要不同的目标路径，那么映射写在 `mise.local.toml` 中

  ```toml
  [dotfiles."~/AppData/Roaming/Code/User/profiles/114514/settings.json"]
  source = "profiles/web/settings.jsonc"
  mode = "symlink"
  ```

  如果目标路径可以从本机状态获取，那么由模块的 `generate-path-mappings` 命令生成这些映射

### 区分共用源路径和专用源路径

请按照如下方式区分不同系统是否使用相同的源路径

- 如果文件名或目录名包含 `windows` / `linux`，那么这是各系统专用的源路径
- 如果文件名或目录名不含 `windows` / `linux`，那么这是跨系统共用的源路径

```txt
codex
├── rules
│   └── git.rules     # 跨系统共用的源路径
└── windows
    └── config.toml   # Windows 专用的源路径
```

### 区分子目录链接和逐文件链接

请注意区分 `* + symlink` 和 `symlink-each` 这两种目录遍历方式

- `* + symlink` 只展开一层，不会对子目录继续递归，而是对整个子目录创建符号链接

  ```toml
  [dotfiles]
  "~/.agents/skills/*" = { source = "skills/*", mode = "symlink" }
  ```

- `symlink-each` 会进行深度遍历，对每个最底部的文件创建符号链接

  ```toml
  [dotfiles.fastfetch-logos]
  source = "logos"
  mode = "symlink-each"
  variants = [
    { default = true, target = "~/.local/share/fastfetch/logos" },
  ]
  ```

优先选择 `* + symlink` 作为目录遍历方式

- 如果子目录由仓库完整接管，那么使用子目录链接，即 `* + symlink`
- 如果目标目录需要合并来自多个源路径的映射，或者各个层级都可能混放非本仓库管理的文件，那么使用逐文件链接，即 `symlink-each`
