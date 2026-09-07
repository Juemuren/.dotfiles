---
name: benchmark-with-hyperfine
description: 使用 hyperfine 设计并运行可重复的命令行基准测试。比较命令或实现的性能、建立耗时基线或验证优化效果时使用；不适用于寻找程序性能瓶颈、调查性能异常原因等需要性能剖析的场景。
---

# 使用 Hyperfine 进行基准测试

## 明确测量目标

按以下维度确定测量目标：

- 待测命令：普通命令、构建过程，还是包含启动和请求等步骤的端到端流程。
- 初始状态：应用缓存和操作系统缓存是冷态还是热态。

遵守用户已指定的目标，其余根据命令和上下文推断。未指定冷态时，默认测量预热缓存后的重复命令耗时。

## 运行基准测试

### 命令帮助

运行以下命令获取使用帮助：

```sh
hyperfine --help
```

### 热态

测量热态命令耗时可通过 `--warmup` 预热文件系统缓存及可跨进程保留的应用缓存。

示例：

```sh
hyperfine --warmup 3 './old workload' './new workload'
```

### 冷启动

测量冷启动性能前先明确哪些状态需要重置，并通过 `--prepare` 在每轮计时前恢复这些状态。

如果命令本身产生缓存，且需要测量无缓存启动的性能，那么可以通过 `--prepare` 清理缓存，比如：

```sh
hyperfine --prepare 'rm -rf ./.ruff_cache' 'ruff check .'
```

如果目标是测量禁用缓存运行的性能，那么使用命令提供的选项跳过缓存的写入和读取：

```sh
hyperfine 'ruff check . --no-cache'
```

无缓存启动和禁用缓存运行并不相同，通常前者还会引入写缓存的额外开销，报告中可以说明这部分差异。

如果需要测试文件系统冷启动时的性能，那么需要在每次运行前通过 `--prepare` 清理操作系统的磁盘缓存：

- 在 Linux 上可以使用 `--prepare 'sync; echo 3 | sudo tee /proc/sys/vm/drop_caches'`。
- 在 Windows 上可以使用 `--prepare 'rammap -Et'`。

这些命令通常会要求提升权限，请在计时流程外完成所需的认证，而不是每次 `--prepare` 时重复认证。

如果无法建立目标冷态，请报告实际状态和限制，不将结果标为已验证的冷启动耗时。

### 构建

测试构建性能需要考虑测的是 clean build、incremental build 还是 no-op build。

如果要测量 clean build，那么每轮测试前要通过 `--prepare` 清除构建产物。优先使用项目已有的清理命令；如果需要自己编写清理命令，请确认不会误删文件。

示例：

```sh
# 使用项目的清理命令
hyperfine --prepare 'cargo clean' 'cargo build'
# 使用自己编写的清理命令
hyperfine --prepare 'rm -rf dist' 'npm run build'
```

如果要测量 incremental build，那么请先准备好基线，并在每轮测试前通过 `--prepare` 恢复基线（包括源码以及对应的构建产物和缓存）并施加变更。

示例：

```sh
# 准备基线
./prepare-baseline.sh
# 每轮测试前恢复基线并施加变更
hyperfine --prepare './restore-baseline.sh && ./apply-changes.sh' 'npm run build'
```

如果要测量 no-op build，那么请通过 `--warmup` 提前完成一次构建。

示例：

```sh
hyperfine --warmup 1 'npm run build'
```

### 端到端

测试端到端性能需要把用户等待的所有时间都放进计时命令：

```sh
hyperfine './run-e2e.sh'
```

## 解读并报告结果

- 报告待测命令、相关环境、测量范围、实际缓存状态、预热次数、准备与清理命令、样本数和汇总统计数据。
- 结合均值、标准差及异常值评估差异，必要时可使用 `--export-json` 导出测量结果并检查每轮耗时。
- 指出可能的混杂因素，例如温度降频、电源策略、杀毒软件活动、网络访问、共享缓存或变化的输入。
