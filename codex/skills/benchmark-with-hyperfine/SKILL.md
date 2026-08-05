---
name: benchmark-with-hyperfine
description: Design and run repeatable command-line benchmarks with hyperfine. Use when comparing command or implementation performance, establishing a timing baseline, investigating a performance regression, or validating an optimization.
---

# Benchmark With Hyperfine

## Prepare the comparison

- Define the performance question and whether to measure steady-state, cold-start, build, or end-to-end time.
- Confirm that compared commands perform equivalent work and produce equivalent results before measuring them.
- Build artifacts before benchmarking unless build time is the intended measurement.
- Fix relevant inputs, working directory, environment variables, and background workload where practical.
- Treat every command passed to `hyperfine` as executable code subject to the normal sandbox and approval policy.

## Run the benchmark

- Check that `hyperfine` is available. If it is unavailable, report that and suggest an installation method appropriate to the environment.
- Give each command a descriptive label with `--command-name` when comparing alternatives.
- Use warmup runs for steady-state measurements affected by filesystem caches, runtime initialization, or JIT compilation. Do not warm up a cold-start benchmark.
- Let `hyperfine` select the run count by default. Adjust `--min-runs`, `--max-runs`, or `--runs` only when runtime or statistical needs justify it, and report the adjustment.
- Use `--prepare` only for state that must be reset before every measured run. Remember that preparation time is excluded from the measurement.
- Use parameter scans such as `-L` when the task is to compare a controlled range of input values.
- Export results with `--export-json` when they need to be preserved, plotted, or compared later.

Example steady-state comparison:

```sh
hyperfine --warmup 3 --command-name baseline '<baseline command>' --command-name candidate '<candidate command>'
```

Adapt quoting to the active shell and verify the expanded commands before starting a long benchmark.

## Interpret and report

- Report the exact commands, relevant environment, benchmark mode, warmup count, sample count, and summary statistics.
- Compare both central tendency and observed variance; do not present a difference within measurement noise as a meaningful improvement.
- Call out likely confounders such as thermal throttling, power policy, antivirus activity, network access, shared caches, or changing inputs.
- State whether the result supports the claimed optimization and identify any follow-up benchmark needed.
