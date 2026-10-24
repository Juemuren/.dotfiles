# dotfiles

这个仓库最初只用于管理我使用的点文件，但现在已经开始越来越多的承担新的功能：[环境记录与恢复](#环境记录与恢复)。

如果你只需要参考几个工具的配置，那么到 [工具列表](#工具列表) 中找到你需要的工具，然后进入目录浏览文件即可。

## 工具列表

目前包含这些工具的配置

<!-- TOOL:BEGIN -->
* [agents](./agents)
* [atuin](./atuin)
* [bash](./bash)
* [bat](./bat)
* [brew](./brew)
* [codex](./codex)
* [conda](./conda)
* [fastfetch](./fastfetch)
* [git](./git)
* [mise](./mise)
* [msys](./msys)
* [neovim](./neovim)
* [npm](./npm)
* [pi](./pi)
* [pixi](./pixi)
* [pnpm](./pnpm)
* [pwsh](./pwsh)
* [scoop](./scoop)
* [starship](./starship)
* [tex](./tex)
* [uv](./uv)
* [vim](./vim)
* [vscode](./vscode)
* [winget](./winget)
* [wt](./wt)
* [zsh](./zsh)
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

<!-- TODO ### 机器初始化

本仓库使用 [just](https://github.com/casey/just) 和一众 Bash / PowerShell 脚本来实现机器初始化。

-->

### 部署点文件

本仓库使用 [mise](https://mise.jdx.dev/dotfiles.html) 管理点文件。

参考下面的方法把仓库中的点文件部署到本机的对应位置。

#### 1. 克隆仓库

```sh
git clone https://github.com/Juemuren/.dotfiles ~/.dotfiles
cd ~/.dotfiles
mise trust
```

#### 2. 填写机器变量

机器变量分为两类：

- 手动填写的变量。目前包含手动填写变量的工具有

    - git
    - pnpm
    - scoop

- 自动填写的变量。目前包含自动填写变量的工具有

    - vscode

对于手动填写的变量，可以根据提示逐个填写

```sh
mise vars prompt
```

也可以直接编辑对应的 `mise.local.toml` 文件，这种方式的优先级更高

```sh
# 把 app 换成对应的工具名
vim app/mise.local.toml
```

对于自动填写的变量，可以用对应的 `just` 命令自动修改 `mise.local.toml` 文件

```sh
# 把 app 换成对应的工具名
just app::bootstrap
```

#### 3. 部署

部署分为两阶段：

- 在一阶段部署时，根目录 `mise.toml` 把各工具目录链接到 `~/.config/mise/conf.d/` 下。
- 在二阶段部署时，由各工具目录中的 `mise.toml` 和 `mise.os.toml` 声明点文件的位置。

预览并完成一阶段部署

```sh
mise dot apply --dry-run
mise dot apply
```

预览并完成二阶段部署

```sh
mise dot apply --dry-run
mise dot apply
```

如果部署时显示 `ERROR`，那么检查目标路径是否已有文件或目录。可以在备份后强制部署

```sh
mise dot apply --force
```

两阶段部署都完成后，可以检查最终状态

```sh
mise dot status
mise dot diff
```
