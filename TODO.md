# TODO

## 系统初始化与软件恢复

- [ ] Windows：编写新系统初始化脚本，放入 `.scripts/windows`，并在 just 的 windows 模块中调用。目前已经完成了部分，但可能需要提取一下 helper 函数从而复用代码。并且 MSVC 的组件配置不应该放在 `.scripts/` 下。
- [ ] Unix：编写新系统初始化脚本，放入 `.scripts/unix`，并在 just 的 unix 模块中调用。
- [ ] 用 Scoop 管理 VSCode 安装。我自己的 bucket 在另一个仓库中，可以考虑把 manifest 符号链接进来。
- [ ] 配置 Windows 开发卷，并研究一下有没有可自动化的方法。

## 迁移到 mise

- [ ] `Justfile` 更新，然后删除 dotter 的残留
- [ ] `.scripts` 目录下的脚本考虑是否迁移到对应的应用下
- [ ] 迁移 vscode，并且考虑 `.local` 下的机器变量是否有更适合 mise 的管理方案

## Agent Skills

- [ ] `transform-media-with-ffmpeg`：考虑重命名。主要用于将 MP4 视频转为 WebP，以便在 GitHub 等网站的 README 中展示；需要补充个人审美要求。
- [ ] `create-scoop-manifest`：说明如何使用 `scoop search` 查找软件，并在缺失时向自己的 bucket 添加 manifest。
- [ ] `build-documents-with-pandoc`：使用 Pandoc 将 Markdown 转为 PDF，并提供模板。
- [ ] `making-braille-ascii`：使用 ImageMagick 和 chafa 将动漫图片转为盲文 ASCII，用于 fastfetch；需要补充个人审美要求。
- [ ] `process-pdf`：考虑重命名。需要明确验收要求，有待筛选更精简的工具集。

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

| 用途                                               | 候选工具        |
| -------------------------------------------------- | --------------- |
| 页面选择、拆分、合并、重排、结构性修改             | qpdf            |
| 文本提取、搜索、元数据检查、页面渲染               | Poppler utils   |
| PDF 检查、文本提取、搜索、页面渲染及通用处理       | MuPDF（mutool） |
| OCR                                                | OCRmyPDF        |
| 上述工具不方便完成的高级操作（Bug 有点多，待考虑） | pdfcpu          |
| 其它工具无法处理的异常 PDF，作为最后选择           | Ghostscript     |

## 日用脚本编写

- [ ] 查询 Codex 会话内容，可以使用 duckdb、fd、rg、jq、bat 等工具
  - [ ] 查询在指定日期区间内的所有会话，列出日期、标题和 id
  - [ ] 查询单个会话中的所有用户问题，需要指定 id
  - [ ] 查询单个会话中包含指定关键词的消息
  - [ ] 统计每天会话数
