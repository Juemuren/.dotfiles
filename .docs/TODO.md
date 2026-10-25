# TODO

## 系统初始化与软件恢复

- [ ] 考虑如何管理 VSCode 安装。使用 Scoop 或者 Winget。
- [ ] 配置 Windows 开发卷 https://learn.microsoft.com/en-us/windows/dev-drive/ 并研究是否可以自动化

## 迁移到 mise

- [ ] 考虑用 mise 的 bootstrap 功能实现机器初始化

## Agent Skills

- [ ] `transform-media-with-ffmpeg`：考虑重命名。主要用于将 MP4 视频转为 WebP，以便在 GitHub 等网站的 README 中展示；需要补充个人审美要求。
- [ ] `build-documents-with-pandoc`：使用 Pandoc 将 Markdown 转为 PDF，并提供模板。
- [ ] `process-pdf`：考虑重命名。需要明确验收要求，有待筛选更精简的工具集。

### 设计备注：build-documents-with-pandoc

PDF 生成路径的优先顺序：

1. Typst。
2. LaTeX（tectonic / xelatex）。
3. HTML（weasyprint / headless chrome）。

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
