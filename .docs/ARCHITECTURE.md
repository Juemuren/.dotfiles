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
│   ├── bootstrap     # 初始化脚本
│   ├── record        # 环境记录脚本
│   └── restore       # 环境恢复脚本
├── mod.just          # 自动化脚本入口
├── mise.local.toml   # 变量或机器相关的映射
├── mise.os.toml      # 各系统专有的映射
└── mise.toml         # 跨系统共用的映射
```

## 自动化脚本

### 自动化脚本的目录结构

自动化脚本包含每个模块中 `automation` 下的脚本和根目录中 `.scripts` 下的脚本

- 每个模块中的 `automation` 下包含 `bootstrap` / `record` / `restore` 三类命令，由模块的 `mod.just` 封装命令
- `.scripts` 下的脚本按用途分类，每类还可以继续分子类。每个子类用 `mod.just` 封装命令，父类用 `mod.just` 组合子类的命令
- 根目录的 `Justfile` 编排命令

自动化脚本的目录结构为

```txt
.
├── .scripts          # 跨模块共用的脚本
│   └── class
│       └── mod.just  # 各类脚本的入口
├── app
│   ├── automation    # 各模块专用的脚本
│   │   ├── bootstrap # 初始化脚本
│   │   ├── record    # 环境记录脚本
│   │   └── restore   # 环境恢复脚本
│   └── mod.just      # 各模块脚本的入口
└── Justfile          # 编排命令
```

### 自动化脚本的入口规范

对于各模块专用的脚本

- 如果脚本较为简单，可以直接写在 `*.sh` 或 `*.ps1` 中；如果脚本较为复杂，拆分后放在 `*` 目录下，并在 `*/index.sh` 或 `*/index.ps1` 中统一调用。这里的 `*` 包含 `bootstrap` / `record` / `restore`
- `mod.just` 中封装模块的自动化脚本，对外提供 `bootstrap` / `record` / `restore` 三个命令，并在根目录 `Justfile` 中编排命令
- 外部调用的命令只能使用根目录 `Justfile` 提供的入口，不要侵入各模块的内部实现

对于跨模块共用的脚本

- 如果类中的脚本较多，可以再拆分子类。子类用 `mod.just` 封装命令，父类在 `mod.just` 组合命令子类提供的命令，根目录 `Justfile` 中编排父类的命令，不要跨越层级破坏封装
- 外部调用的命令只能使用根目录 `Justfile` 提供的入口，不要侵入各类的内部实现

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

  不过，通常这种情况都需要由 `bootstrap` 命令自动填写机器相关的映射

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
