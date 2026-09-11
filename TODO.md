# TODO

## 系统初始化与软件恢复

- [ ] Scoop：编写 bucket 记录与恢复脚本，记录 bucket 名称与来源，包括我自己的 bucket 仓库。
- [ ] Windows：编写新系统初始化脚本，放入 `scripts/windows`，并在 just 的 windows 模块中调用。
- [ ] Unix：编写新系统初始化脚本，放入 `scripts/unix`，并在 just 的 unix 模块中调用。
- [ ] 用 Scoop 管理 VSCode 安装。我自己的 bucket 在另一个仓库中，可以考虑把 manifest 符号链接进来。
- [ ] 配置 Windows 开发卷，并研究一下有没有可自动化的方法。

## 配置部署与机器差异

- [ ] 改善从本地配置示例到可用机器配置的流程（machine-special）。
  - [ ] 自动填写 VSCode profiles 的文件映射。目前已经可以提取 `profile_id`，可以考虑用脚本自动修改 `.dotter/local.toml` 中的 `files`。
  - [ ] 自动识别并填写部分机器相关变量。
  - [ ] 评估并实现机器相关变量的唯一权威源，让配置与自动化脚本共享变量。

### 方案草稿：机器变量的唯一权威源

目前 `.dotter/local.toml` 中的 `variables` 只有配置能读，要运行的脚本不能读；变量还需要在 `global.toml`、`os.toml`、`local.example.toml`、`local.toml` 中重复维护。

考虑使用外部 `*.env` 文件作为 machine-special 权威源，方便脚本读取和修改；配置通过 `dotter --patch` 读取这些内容。

例如，将权威源文件放在 `.local/env`：

```env
scoop_root="path/to/scoop"
```

通过 just 加载，让脚本可以读取：

```just
set dotenv-path := ".local/env"
```

转换为 dotter patch，目前的想法是添加 `[variables]` 头（需验证 dotenv 与 TOML 的语法兼容性）：

```sh
printf '[variables]\n'
cat .local/env
```

```pwsh
"[variables]`n$(Get-Content -Raw .local/env)"
```

更好的解决方案是让 dotter 可以直接在配置中声明读取哪些 `.env` 文件。相关 PR 已提交 [issue #228](https://github.com/SuperCuber/dotter/issues/228)。

方案验证并完成迁移后，再删除各层 dotter 配置中重复的 `[variables]`。

## 命令入口

- [ ] 更改命令入口，根据记录、恢复、部署与初始化等划分子模块。

### 方案草稿：命令入口

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

## Agent Skills

- [ ] `transform-media-with-ffmpeg`：考虑重命名。主要用于将 MP4 视频转为 WebP，以便在 GitHub 等网站的 README 中展示；需要补充个人审美要求。
- [ ] `create-scoop-manifest`：说明如何使用 `scoop search` 查找软件，并在缺失时向自己的 bucket 添加 manifest。
- [ ] `build-documents-with-pandoc`：使用 Pandoc 将 Markdown 转为 PDF，并提供模板。
- [ ] `making-braille-ascii`：使用 ImageMagick 和 chafa 将动漫图片转为盲文 ASCII，用于 fastfetch；需要补充个人审美要求。
- [ ] `process-pdf`：考虑重命名。需要明确验收要求，有待筛选更精简的工具集。
- [ ] `data-wrangling`：明确适用场景并筛选工具，优先使用现成工具，减少用 Python / shell 重复实现已有功能。

### 设计备注：create-scoop-manifest

个人偏好：

- 能不写脚本就不写脚本。
- 需要脚本时，放到 `scripts` 目录，在 JSON 中调用文件，避免内嵌转义的 Pwsh 脚本。
- `_common` 目录用于通用脚本或辅助脚本。

这些要求可能更适合放到 bucket 仓库的 `AGENTS.md` 中，skill 引用即可。

### 设计备注：build-documents-with-pandoc

PDF 生成路径的优先顺序：

1. Typst。
2. LaTeX（tectonic / xelatex）。
3. HTML（weasyprint / headless chrome）。

### 设计备注：making-braille-ascii

命令示例：

```sh
chafa -f symbols --symbols braille -c none input.jpg > output.txt
```

考虑是否要让 agent 自己去 Pixiv 等网站找图。

### 设计备注：process-pdf

实际用途是整理从 zlib 下载的电子书：去掉扉页、版权页、出版商的话、封底等影响阅读体验的页面，根据目录页补全 PDF 目录，补齐可能缺失的封面，并实现全书 OCR。封面可考虑从豆瓣查找，但反爬可能较难处理。

候选工具较多，还需筛选：

| 用途 | 候选工具 |
| --- | --- |
| 页面选择、拆分、合并、重排、结构性修改 | qpdf |
| 文本提取、搜索、元数据检查、页面渲染 | Poppler utils |
| PDF 检查、文本提取、搜索、页面渲染及通用处理 | MuPDF（mutool） |
| OCR | OCRmyPDF |
| 上述工具不方便完成的高级操作（Bug 有点多，待考虑） | pdfcpu |
| 其它工具无法处理的异常 PDF，作为最后选择 | Ghostscript |

### 设计备注：data-wrangling

虽然经常使用这些工具，但尚无明确、单一的用途。Agent 大概率已经掌握相关知识，重点是表达工具选择偏好。

以下候选工具仍需精简：

| 定位 | 数据或场景 | 工具 |
| --- | --- | --- |
| 默认 | JSON / 简单 JSONL | jq |
| 默认 | YAML / TOML / XML / 配置文件 | yq |
| 默认 | CSV / TSV / 复杂 JSONL / Parquet / 关系型数据 | DuckDB |
| 专项 | 流式或逐记录转换（没实际用过） | Miller |
| 专项 | 高级 CSV 操作（没实际用过） | qsv |
| 兜底 | 复杂、自定义、多步骤或需要专用库的数据处理 | Python |
| 受限使用 | 简单纯文本处理 | awk |

## 探索与评估

- [ ] 把更多工作迁移到 Neovim 上，并尝试从零开始编写自己的配置。可以先在 VSCode 里使用 Neovim 后端以熟练命令。
- [ ] 尝试在 WSL 中使用 Nix。
- [ ] 评估迁移到 chezmoi。

## 日用脚本编写

- [ ] 查询 Codex 会话内容，可以使用 duckdb、fd、rg、jq 等工具
  - [ ] 查询在指定日期区间内的所有会话，列出日期、标题和 id
  - [ ] 找最长 prompt
  - [ ] 查询单个会话中的所有用户问题，需要指定 id
  - [ ] 查询单个会话中包含指定关键词的消息
  - [ ] 统计 token，可以是单个会话或多个会话
  - [ ] 统计每天会话数
  - [ ] 找含错误信息的 assistant 回复
