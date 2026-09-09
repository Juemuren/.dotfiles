## Core

- [ ] scoop: 编写脚本记录 bucket 名称与来源（包括自己的 bucket 仓库），以及另一个根据记录重新添加 bucket 的脚本。
- [ ] tex: 编写包安装脚本，读取 `tex/*/packages.txt` 并使用 tlmgr 安装。
- [ ] vscode: 编写扩展安装脚本，读取 `vscode/*/extensions.jsonc` 通过 `code --install-extension extension-id --profile profile` 安装扩展。
- [ ] vscode: 完善 profile 记录脚本，通过 CLI 导出 `*.code-profile`，不再需要手动操作。目前 `code` 似乎并不支持这个功能，也许有一些比较 hack 的方法。
- [ ] vscode: 编写 profile 映射脚本。获取 profile 路径，修改 `.dotter/local.toml` 中的配置目录映射，从而自动消除 `*_hash` 占位。不太清楚能否实现，目前的手动方案尚可接受。
- [ ] windows：补充把 `~/.local/bin` 添加到 PATH 中的脚本，需要注意重复执行的问题，必须保持幂等性。可以追加到 `windows/env.ps1` 里。
- [ ] windows: 编写安装 Scoop 的脚本，允许用参数指定安装目录。配置 `SCOOP_HOME` 环境变量，可以顺便修改 `.dotter/local.toml` 中的变量。注意幂等性。
- [ ] windows：分别编写安装 PowerShell 7、MSVC/SDK 的脚本（使用 winget）。注意幂等性。
- [ ] windows：编写安装 WSL 的脚本，并记录发行版。注意幂等性。
- [ ] windows: 编写新系统的初始化脚本，放入 `scripts/windows` 下，并在 just 的 windows 模块中调用。
- [ ] unix: 编写新系统的初始化脚本，放入 `scripts/unix` 下，并在 just 的 unix 模块中调用。

## Skils

- [ ] transform-media-with-ffmpeg: 名称太泛了，考虑修改一下。主要用途是使用 FFmpeg 将 MP4 视频转为 WebP，以便在 GitHub 等网站的 README 中展示。需要说明一下个人审美。

- [ ] create-scoop-manifest: 说明如何使用 scoop search 软件，并在缺失软件时让 agent 给我的 scoop bucket 添加一个 manifest。需要说明一下审美：能不写脚本就不写脚本；即使要写，也不要在 JSON 里直接编写转义的 pwsh 脚本，而是把脚本放到 scripts 目录下，JSON 里直接运行文件；同时 _common 目录用于存放通用脚本或者辅助脚本。不过这些要求可能放到 bucket repo 的 agents.md 里更好，skill 里引用 agents.md 就行。

- [ ] build-documents-with-pandoc: 使用 Pandoc 将 Markdown 转为 PDF，并提供模板。优先考虑通过 typst，其次 latex (引擎为 tectonic / xelatex)，最后 html (引擎为 weasyprint / headless chrome)。

- [ ] making-braille-ascii: 使用 ImageMagick 和 chafa 将动漫图片转为盲文 ASCII，以便在 fastfetch 里显示。需要声明一下个人审美，并给出命令示例。~~也许还可以让 agent 自己去 pixiv 等网站找图~~。
  ```sh
  chafa -f symbols --symbols braille -c none input.jpg > ouput.txt
  ```

- [ ] process-pdf: 也许应该修改一下名称。我的实际用途就是修改 zlib 上下载到的电子书，去掉扉页、版权页、出版商的话、封底等影响阅读体验的东西，然后根据目录页补全 PDF 目录，最后补上可能缺失的封面（可以去豆瓣找，不过豆瓣的反爬有点难处理）和 OCR。
  工具集大概如下，有点多，可能还要筛选一下。
  - 常规 PDF 操作优先使用以下工具
    - qpdf：页面选择、拆分、合并、重排、结构性修改
    - Poppler utils：文本提取、搜索、元数据检查、页面渲染
    - MuPDF（mutool）：PDF 检查、文本提取、搜索、页面渲染及通用处理
  - 需要 OCR 时使用 OCRmyPDF。
  - 上述工具不方便完成的高级 PDF 操作可使用 pdfcpu。
  - Ghostscript 仅作为最后选择，用于其它工具无法处理的异常 PDF。

- [ ] data-wrangling: 处理结构化数据。虽然天天用这些工具，但暂时没有非常明确的、单一的用途。这些知识 agent 大概率也懂，我只需要让它优先使用现成的工具，尽量少用 python / shell 反复造轮子就行。
  工具集大概如下，太多了，最好再筛选一下。
  - 默认：
    - JSON：jq
    - YAML / TOML / XML / 配置文件：yq
    - CSV / TSV / JSONL / Parquet / 关系型数据：DuckDB
  - 专项：
    - Miller：流式或逐记录转换
    - qsv：CSV 验证、修复、剖析、特殊采样或大型 CSV 专项操作
  - 兜底：
    - Python：复杂、自定义、多步骤或需要专用库的数据处理
    - awk：仅用于简单纯文本处理，不作为结构化数据的默认方案

## Chore

- [ ] 配置 Windows 开发卷
- [ ] 用 Scoop 管理 VSCode 安装。我的 bucket 在另一个仓库中，可以考虑把 manifest 符号链接进来。
- [ ] 多用用 neovim，并记录 neovim 配置
- [ ] 尝试一下在 WSL 里使用 Nix
- [ ] 考虑迁移到 chezmoi
- [ ] 改善从复制本地配置示例到创建实际需要的本地配置之间的这段体验，也就是改善配置 machine-special 的过程。一是 vscode 的 profiles 目前还需要手动寻找位置；二是变量需要手动填写（有部分确实必须手写，有部分可以在机器初始化时直接写入），且如果使用外部 `*.env` 权威源，那么可以按文件名拆分模块，不用挤在一个 toml 里，相对更易读。

## Refactor

- [ ] 修改仓库结构

考虑修改仓库结构，改为如下方案

```txt
.dotfiles
│
├── configs
│   ├── git/
│   ├── vscode/
│   ├── starship/
│   └── ...
│
├── manifests
│   ├── scoop/buckets/*.txt
│   ├── pwsh/modules.txt
│   ├── vscode/*/extensions.jsonc
│   └── ...
│
└── automation
    ├── record
    ├── restore
    └── bootstrap
```

然后 just 作为唯一入口

```sh
just record scoop
just record vscode
just record

just restore scoop
just restore pwsh
just restore

just deploy

just bootstrap
```

- [ ] 唯一权威源

`.dotter/local.toml` 中的 `variables` 只有配置能读，要运行的脚本不能读。

可以使用几个 `*.env` 文件作为 machine-special 权威源。自动化脚本可以从这里读取内容，配置通过 `dotter --patch` 也可以读取这些内容。

比如权威源文件 `.local/env` 可以这样写

```env
scoop_root="path/to/scoop"
```

然后通过 just 加载此文件，从而让脚本可以读取

```justfile
set dotenv-path := ".local/env"
```

转为 dotter 可接受的 patch 也只需添加一个 `[variables]` 头就行（我觉得可以给 dotter 提个 pr，能够直接在配置文件里写读取哪些 .env 文件。issues 已经提交 https://github.com/SuperCuber/dotter/issues/228 ）

```bash
# Bash
printf "[variables]\n$(cat .local.env)"
```

```pwsh
# Pwsh
echo "[variables]`n$(cat .local.env)"
```

完成之后所有 dotter 的 `[variables]` 字段都可以删了，不需要 `global.toml` / `os.toml` / `local.example.toml` / `local.toml` 各写一遍。

## Scripts

- [ ] 编写脚本，用 fzf 交互式更新 winget 软件
