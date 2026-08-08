---
name: develop-shell-scripts
description: Create, modify, test, lint, and format reusable POSIX shell and Bash scripts. Use when completing a command-line task whose reusable steps should be persisted as a script, when creating a new Shell script, or whenever changing an existing supported Shell script; validate every script change with ShellCheck and shfmt.
---

# Develop Shell Scripts

## Identify reusable work

- Complete the requested task, then review the commands and decisions it required. Persist the parts likely to be run again when doing so would reduce repetition or encode non-obvious knowledge.
- Prefer extending an existing script or task over creating a duplicate. Follow the repository's conventions for script location, naming, interpreter, executable mode, and invocation.
- Keep incidental exploration, one-off recovery commands, and trivial wrappers out of the script.
- Never persist secrets, credentials, machine-specific absolute paths, transient values, or unconfirmed destructive actions. Expose changing inputs as arguments, environment variables, or configuration.

## Create or modify the script

- Determine the required dialect from project conventions and target environments. Prefer POSIX shell for portability and Bash only when its features provide clear value.
- For a new script, define its inputs, outputs, exit behavior, side effects, working-directory assumptions, and failure modes before implementation.
- For an existing script, inspect its callers and preserve its interface unless the task explicitly changes it. Make the smallest coherent change.
- Quote expansions deliberately, handle paths safely, check important prerequisites, and make destructive operations narrow and explicit.
- Add comments for intent and constraints rather than narrating obvious syntax. Include usage text when the interface is not self-evident.

## Exercise the workflow

- Run the new or changed script on a safe representative case. Confirm that it reproduces the reusable portion of the completed task and fails clearly for invalid input.
- Avoid using live credentials or production data for validation. Preview filesystem mutations when the underlying tool supports it.
- Run the repository's focused tests or task-runner recipe when one exists.

## Lint and format every change

- Inspect the shebang, `.shellcheckrc`, ShellCheck directives, EditorConfig, and repository formatter settings.
- Run the appropriate syntax check, such as `sh -n` or `bash -n`.
- Run ShellCheck with the detected dialect. Fix findings in context; add only narrow, justified suppressions.
- Run `shfmt -d` and inspect the proposed formatting, then apply `shfmt -w` using the repository's established options.
- Re-run the syntax check, ShellCheck, and relevant tests after formatting.
- ShellCheck and shfmt do not fully support zsh. If the project requires unsupported syntax, do not rewrite it blindly; use the dialect's own checks and report which required validations could not be performed.

## Report the result

- Report the reusable work that was persisted, the script path and interface, and how it relates to the original task.
- List the execution, syntax, lint, formatting, and test commands run, along with any remaining warning, suppression, compatibility limitation, or untested side effect.
