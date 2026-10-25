## 目录结构

在根目录中

```txt
.
├── .docs             # 跨模块共用的文档
├── .scripts          # 跨模块共用的脚本
├── app               # 各模块的目录
├── mise.local.toml   # 启用的模块
└── mise.toml         # 各模块顶层目录的映射
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

每个模块中 `automation` 目录下的脚本是自动化脚本，`mod.just` 提供入口。整体的目录结构为

```txt
app
├── automation      # 自动化脚本
│   ├── bootstrap   # 初始化脚本
│   ├── record      # 环境记录脚本
│   └── restore     # 环境恢复脚本
└── mod.just        # 自动化脚本入口
```

对于这些脚本，请按如下规则提供入口

- 如果脚本较为简单，可以直接写在 `xxx.sh` 或 `xxx.ps1` 中；如果脚本较为复杂，拆分后放在 `xxx` 目录下，并在 `xxx/index.sh` 或 `xxx/index.ps1` 中统一调用。这里的 `xxx` 包含 `bootstrap` / `record` / `restore`
- `mod.just` 中封装模块的自动化脚本，对外提供 `bootstrap` / `record` / `restore` 三个命令

## 映射配置

每个模块中 `mise.toml` / `mise.os.toml` / `mise.local.toml` 定义文件或目录映射。整体的目录结构为

```txt
app
├── mise.local.toml   # 变量或机器相关的映射
├── mise.os.toml      # 各系统专有的映射
└── mise.toml         # 跨系统共用的映射
```

对于这些映射，请按如下规则编写配置

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

此外，请按照如下方式区分不同系统是否使用相同的源路径

- 如果文件名或目录名包含 `windows` / `linux`，那么这是各系统专用的源路径
- 如果文件名或目录名不含 `windows` / `linux`，那么这是跨系统共用的源路径

```txt
codex
├── rules
│   └── git.rules     # 跨系统共用的源路径
└── windows
    └── config.toml   # Windows 专用的源路径
```

请注意区分 `* + symlink` 和 `symlink-each` 这两种遍历方式

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
