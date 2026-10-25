# dotfiles

这个仓库最初只用于管理我使用的点文件，但现在已经开始越来越多的承担新的功能：[环境记录与恢复](#环境记录与恢复)。

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
<!-- AGENT-SKILL:END -->

Pwsh 包含以下 Module

<!-- PWSH-MODULE:BEGIN -->
* [ScriptRunner](pwsh/modules/ScriptRunner)
<!-- PWSH-MODULE:END -->

## 环境记录与恢复

### 原则与审美

这个仓库不只是保存点文件，同时还记录了个人开发环境的软件选择与配置。

这种记录和恢复的原则与审美为

- **记录时不会保存环境的完整状态。** 因为我希望所有记录的变更都能通过 `git diff` 清晰地查看，而软件版本、软件安装时间、软件状态等频繁变化的信息会引入大量不必要的变更，导致 diff 难以审阅。且这类信息我并不关心，因此不会被记录。
- **恢复时保证配置完全相同，但不保证软件版本完全相同。** 如前所述，软件版本被刻意排除出记录。由于我喜欢使用最新稳定版的软件，因此恢复时出现版本漂移是预期行为。
- **记录与恢复分别维护。** 记录脚本把当前软件写入清单，恢复脚本根据清单恢复软件。可以单独记录，也可以单独恢复，不强制同步。

### 机器初始化

本仓库使用 [just](https://just.systems/) + [mise](https://mise.jdx.dev/bootstrap.html) 以及 Bash / PowerShell 脚本来实现机器初始化。

参考下面的方法完成机器的初始化。

#### 1 克隆仓库

在初始化前需要已有 `git` 和 `mise`

```sh
git clone https://github.com/Juemuren/.dotfiles ~/.dotfiles
cd ~/.dotfiles
mise trust
```

#### 2 安装工具

工具分为 mise 管理的工具和系统管理的工具。

安装 mise 管理的工具。这些工具写在根目录 `mise.toml` 的 `tools` 中

```sh
mise bootstrap --only tools
```

安装系统管理的工具

```sh
mise bootstrap --only packages
```

- 在 Linux 上要求已有 `curl` 和 `bash`，此时会安装 `brew`
- 在 Windows 上要求已有 `winget` 和 `powershell`，此时会安装 `scoop` / `pwsh` / `vscode`

#### 3 恢复软件环境

重新打开终端并进入仓库目录，确保新安装的工具进入了 PATH 环境变量，然后进行最终的环境恢复

```sh
mise bootstrap --only task
```

### 部署点文件

本仓库使用 [mise](https://mise.jdx.dev/dotfiles.html) 管理点文件。

参考下面的方法把仓库中的点文件部署到本机的对应位置。

#### 1 克隆仓库

如果已在机器初始化时完成此步骤，那么可以跳过

```sh
git clone https://github.com/Juemuren/.dotfiles ~/.dotfiles
cd ~/.dotfiles
mise trust
```

#### 2 一阶段部署

部署分为两阶段：

- 一阶段部署，根目录 `mise.toml` 把各工具目录链接到 `~/.config/mise/conf.d/` 下。
- 二阶段部署，由各工具目录中的 `mise.toml` 和 `mise.os.toml` 声明点文件的位置。

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

如果没填写 `dotfile_groups` 时，mise 会默认链接所有工具目录。

选择完需要的工具后，进行一阶段部署

```sh
mise dot apply
```

一阶段部署完成时，mise 会自动尝试进行二阶段部署。如果有需要填写的机器变量，那么二阶段部署会自动失败。

#### 3 填写机器变量

机器变量分为手动填写的变量和自动填写的变量。

对于手动填写的变量，可以根据提示逐个填写

```sh
mise vars prompt
```

也可以直接编辑对应的 `mise.local.toml` 文件，这种方式的优先级更高

```toml
# git/mise.local.toml
[vars]
git_name = "Your name"
git_email = "Your email"
```

目前包含手动填写变量的工具有

- git
- pnpm
- scoop

对于自动填写的变量，可以用仓库提供的 `just` 命令自动修改对应工具目录下的 `mise.local.toml` 文件

```sh
just vscode::bootstrap
```

目前包含自动填写变量的工具有

- vscode

#### 4 二阶段部署

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

#### 5 重新部署

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
