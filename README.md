# dotfiles

这个仓库最初只用于管理我使用的点文件，但现在已经开始越来越多的承担新的功能：[环境记录与恢复](#环境记录与恢复)。

如果你只需要参考几个工具的配置，那么到 [工具列表](#工具列表) 中找到你需要的工具，然后进入目录浏览文件即可。

## 工具列表

目前包含这些工具的配置

<!-- TOOL:BEGIN -->
* [agents](./agents)
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

本仓库使用 [dotter](https://github.com/SuperCuber/dotter) 管理点文件，使用 [just](https://github.com/casey/just) 运行任务。

参考下面的方法把仓库中的点文件部署到本机的对应位置：

1. 克隆仓库

    ```sh
    git clone https://github.com/Juemuren/.dotfiles
    cd .dotfiles
    ```

2. 复制配置示例（可以任选一个 `.dotter/local.*.toml` 作为示例文件）

    ```sh
    cp .dotter/local.windows.toml .dotter/local.toml
    ```

3. 根据需要修改 `.dotter/local.toml`

    ```sh
    vim .dotter/local.toml
    ```

4. 预览部署结果

    ```sh
   just preview
    ```

5. 如果部署失败，显示 `ERROR`，那么通常是一些文件的目标路径需要动态获取。请在 `.local/xxx.env` 中填写对应的变量，或者运行 `just yyy::xxx::bootstrap` 来自动填写变量。目前这类软件、对应的 `*.env` 文件以及自动填写的命令分别为

    - vscode - `.local/vscode.env` - `just common::vscode::bootstrap`

6. （可选）如果显示 `WARN`，那么通常是目标位置已经存在文件。建议进行备份，因为下一步原位置的文件将被删除。

7. 部署点文件

    ```sh
    just deploy
    ```
