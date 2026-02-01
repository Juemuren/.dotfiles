# dotfiles

这个仓库用于管理我所使用的点文件

## 工具列表

目前包含这些配置

<!-- TOOL-LIST:START -->
* bash
* conda
* fastfetch
* git
* mise
* pwsh
* scoop
* starship
* uv
* vim
* vscode
* wt
* zsh
<!-- TOOL-LIST:END -->

## 使用方法

我使用了 [dotter](https://github.com/SuperCuber/dotter) 这个工具来管理点文件。你可以阅读它的[文档](https://github.com/SuperCuber/dotter/wiki)来了解如何使用

简单地说，本仓库的使用法方法如下

```sh
# 克隆本仓库
git clone https://github.com/Juemuren/.dotfiles
# 进入目录
cd .dotfiles
# 复制示例模板，生成本地配置文件
cp .dotter/local.sample.toml .dotter/local.toml
# 使用你最喜欢的编辑器修改变量
vim .dotter/local.toml
# 只查看运行结果，不实际修改
dotter deploy --dry-run -f
# 删除原文件，创建符号链接，并显示详细日志
dotter deploy -v -f
```

在进行最后一步之前，最好先备份一下原本已存在的文件。因为添加了 `-f` 参数，这会删除该位置原先的文件再创建符号链接。

如果你不想使用 `dotter`，那么也可以对照着 `.dotter\global.toml` 手动复制文件到对应的位置。
