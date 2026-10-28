# dotfiles

这个仓库最初只用于管理我使用的点文件，但现在已经开始越来越多的承担新的功能：[机器初始化](#机器初始化)。

如果你只需要参考配置，那么到 [工具列表](#工具列表) 中找到你需要的工具，然后进入目录浏览文件即可。

## 工具列表

目前包含这些工具的配置

<!-- TOOL:BEGIN -->
* [agents](agents)
* [atuin](atuin)
* [bash](bash)
* [bat](bat)
* [brew](brew)
* [codex](codex)
* [conda](conda)
* [fastfetch](fastfetch)
* [git](git)
* [mise](mise)
* [msvc](msvc)
* [msys](msys)
* [neovim](neovim)
* [npm](npm)
* [pi](pi)
* [pixi](pixi)
* [pnpm](pnpm)
* [pwsh](pwsh)
* [scoop](scoop)
* [starship](starship)
* [tex](tex)
* [uv](uv)
* [vim](vim)
* [vscode](vscode)
* [winget](winget)
* [wsl](wsl)
* [wt](wt)
* [zsh](zsh)
<!-- TOOL:END -->

VSCode 包含以下 Profile

<!-- VSCODE-PROFILE:BEGIN -->
* [conf](vscode/profiles/conf)
* [doc](vscode/profiles/doc)
* [emb](vscode/profiles/emb)
* [game](vscode/profiles/game)
* [global](vscode/profiles/global)
* [sci](vscode/profiles/sci)
* [sys](vscode/profiles/sys)
* [web](vscode/profiles/web)
<!-- VSCODE-PROFILE:END -->

Agents 包含以下 Skill

<!-- AGENT-SKILL:BEGIN -->
* [benchmark-with-hyperfine](agents/skills/benchmark-with-hyperfine)
* [capture-tool-problems](agents/skills/capture-tool-problems)
* [data-wrangling](agents/skills/data-wrangling)
* [develop-automation-scripts](agents/skills/develop-automation-scripts)
* [discuss-before-edit](agents/skills/discuss-before-edit)
<!-- AGENT-SKILL:END -->

Pwsh 包含以下 Module

<!-- PWSH-MODULE:BEGIN -->
* [ScriptRunner](pwsh/modules/ScriptRunner)
<!-- PWSH-MODULE:END -->

## 机器初始化

本仓库使用 [just](https://just.systems/) + [mise](https://mise.jdx.dev/bootstrap.html) 以及 Bash / PowerShell 脚本实现机器初始化。

参考下面的方法完成机器的初始化。

### stage 0 完成自举

后续步骤需要 `git` 和 `mise`。

如果缺少工具，可以使用仓库提供的脚本进行安装。这些脚本会首先安装一个包管理器，而 stage 1 中仍然可以单独安装这个包管理器

- 在 Windows 上，通过 Scoop 安装 git + mise

  ```pwsh
  # 可选：自定义 Scoop 安装位置。默认为 ~/scoop
  # $env:SCOOP_ROOT = "D:\Scoop"
  irm https://raw.githubusercontent.com/Juemuren/.dotfiles/master/seed.ps1 | iex
  ```

- 在 Linux 上，通过 Homebrew 安装 mise。

  由于安装 Homebrew 需要 git，因此运行脚本前需要有 git

  ```sh
  # 可选：自定义 Homebrew 安装位置。默认为 /home/linuxbrew/.linuxbrew
  # export BREW_ROOT=/opt/brew
  curl -fsSL https://raw.githubusercontent.com/Juemuren/.dotfiles/master/seed.sh | bash
  ```

  安装后需根据提示配置 `brew shellenv`，然后重新打开终端。

### stage 1 安装工具

安装分为两阶段：

- 一阶段由 mise 进行安装
- 二阶段由系统包管理器进行安装

#### 1.1 克隆仓库

```sh
git clone https://github.com/Juemuren/.dotfiles ~/.dotfiles
cd ~/.dotfiles
mise trust
```

#### 1.2 一阶段安装

对于 mise 管理的工具，列表写在根目录 `mise.toml` 的 `tools` 中

```sh
mise bootstrap --only tools
```

#### 1.3 修改工具清单

对于系统管理的工具，分为必须安装的工具和可选安装的工具

- 必装的工具详见根目录下的 `mise.os.toml` 文件
- 可选的工具详见 [.mise](.mise) 目录下的文件

在根目录新建 `.miserc.local.toml`，然后填写需要的工具名

```toml
env = [
  "scoop",
  "pwsh",
  "vscode",
]
```

如果没填写 `env`，默认不安装可选的工具。

特别地

- 对于 `scoop`，可以通过环境变量 `SCOOP_ROOT` 修改要安装的路径。默认为 `~/scoop`
- 对于 `brew`，可以通过环境变量 `BREW_ROOT` 修改要安装的路径。默认为 `/home/linuxbrew/.linuxbrew`

#### 1.4 二阶段安装

选择完要安装的工具后，运行

```sh
mise bootstrap --only packages
```

安装完成后一些工具要求重新打开终端。部分工具还可能要求重启系统。

### stage 2 恢复环境

根据清单恢复部分工具声明的插件、扩展、宏包、组件等，以及恢复包管理器声明的软件包

- Windows 的可恢复模块及依赖关系见 [modules.json](.scripts/windows/modules.json)
- Unix 的可恢复模块及依赖关系见 [modules.json](.scripts/unix/modules.json)

在仓库根目录新建 `.restore.local.env`，填写需要恢复的模块

```env
RESTORE_MODULES=msys,tex
```

如果没填写 `RESTORE_MODULES`，默认不恢复任何模块。

准备完成后，运行

```sh
mise bootstrap --only task
```

配置的全局环境变量在新终端中生效。

### stage 3 部署点文件

部署分为两阶段：

- 一阶段部署，根目录 `mise.toml` 把各工具目录链接到 `~/.config/mise/conf.d/` 下。
- 二阶段部署，由各工具目录中的 `mise.toml` 和 `mise.os.toml` 声明点文件的位置。

#### 2.1 一阶段部署

一阶段部署可以选择需要链接的工具目录。在仓库根目录新建 `mise.local.toml`，然后填写需要的工具名

```toml
# mise.local.toml
[bootstrap]
dotfile_groups = [
  "git",
  "vscode",
  "zsh",
]
```

如果没填写 `dotfile_groups`，默认链接所有工具目录。

选择完需要的工具后，进行一阶段部署

```sh
mise dot apply
```

一阶段部署完成时，mise 会自动尝试进行二阶段部署。如果有需要填写的机器变量，那么二阶段部署会自动失败。

#### 2.2 填写机器变量

部分工具的点文件中存在机器相关的变量。目前这样的工具有

<!-- MACHINE-VARS:BEGIN -->
- git
- pi
- pnpm
- scoop
<!-- MACHINE-VARS:END -->

机器变量可以根据提示逐个填写

```sh
mise vars prompt
```

也可以直接编辑对应的 `mise.local.toml` 文件

```toml
# git/mise.local.toml
[vars]
git_name = "Your name"
git_email = "Your email"
```

后一种方式的优先级更高。

#### 2.3 生成路径映射

部分工具的路径映射需要动态生成。目前这样的工具有

<!-- PATH-MAPPINGS:BEGIN -->
- vscode
<!-- PATH-MAPPINGS:END -->

可以用仓库提供的 `just` 命令自动生成映射

```sh
just vscode::generate-path-mappings
```

也可以直接编辑对应的 `mise.local.toml` 文件

```toml
# vscode/mise.local.toml
[dotfiles."~/AppData/Roaming/Code/User/profiles/114514/settings.json"]
source = "profiles/web/settings.jsonc"
mode = "symlink"
```

这两种方式的效果相同。

#### 2.4 二阶段部署

填写完所有需要的机器变量后，可以进行二阶段部署

```sh
mise dot apply
```

如果部署时显示 `ERROR`，那么检查目标路径是否已有文件或目录。可以在备份后强制部署

```sh
mise dot apply --force
```

二阶段部署完成后，可以检查最终的状态

```sh
mise dot status
```

## 持续维护

### 重新记录或恢复软件清单

记录环境

```sh
just record scoop tex
```

恢复环境

```sh
just restore tex
```

此时不会根据 `modules.json` 自动展开依赖。默认的 `just record` 和 `just restore` 不会记录会恢复任何模块的环境。

### 重新部署点文件

修改工具的配置文件后，如果部署方式不是符号链接，那么可能需要再次部署。此时可以先查看差异，再进行部署。这是二阶段的重新部署

```sh
mise dot diff
mise dot apply
```

如果需要修改选择的工具，那么要进行一阶段的重新部署。在 `mise.local.toml` 中修改 `dotfile_groups` 后，进行一阶段的重新部署

```sh
mise dot apply --prune
```

由于添加了 `--prune` 参数，会自动删除 `dotfile_groups` 中已撤销的目录链接。但此时二阶段部署的文件仍然存在，只是指向了已删除的目录。

如果希望彻底清除死链接，那么请不要运行 `mise dot apply --prune`，而是取消部署后再重新完整地部署一次

```sh
mise dot unapply
mise dot apply
```

在 Windows 上，`mise dot unapply` 可能会遇到问题。可以使用仓库提供的 `just` 命令取消部署

```sh
just undeploy
```

## 开发文档

参考 [ARCHITECTURE.md](.docs/ARCHITECTURE.md)
