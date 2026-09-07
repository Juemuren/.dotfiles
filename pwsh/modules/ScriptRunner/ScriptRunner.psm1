$script:ScriptRunnerDirectory = '~/.local/bin'

function Convert-ScriptName {
    param([string]$Value)

    return "'" + $Value.Replace("'", "''") + "'"
}

function Get-LocalScript {
    <# .SYNOPSIS
    Lists local scripts with a shebang or a .ps1 extension.
    #>

    if (-not (Test-Path -LiteralPath $script:ScriptRunnerDirectory -PathType Container)) {
        return
    }

    Get-ChildItem -LiteralPath $script:ScriptRunnerDirectory -File | Where-Object {
        $_.Extension -eq '.ps1' -or
        (Get-Content -LiteralPath $_.FullName -TotalCount 1 -ErrorAction SilentlyContinue) -match '^#!'
    } | Sort-Object Name
}

function Get-ScriptInterpreter {
    <# .SYNOPSIS
    Returns the interpreter name and arguments for a script without running it.
    #>
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    $firstLine = Get-Content -LiteralPath $Path -TotalCount 1
    if ($firstLine -notmatch '^#!\s*(.+)$') {
        if ([IO.Path]::GetExtension($Path) -eq '.ps1') {
            return [PSCustomObject]@{
                Name = 'pwsh'
                Args = @('-NoProfile', '-File')
            }
        }
        throw "Script has no shebang: $Path"
    }

    $interpreterPath, $optionalArgument = $Matches[1].Trim() -split '\s+', 2
    return [PSCustomObject]@{
        Name = ($interpreterPath -split '/')[-1]
        Args = @(if ($null -ne $optionalArgument) { $optionalArgument })
    }
}

function Invoke-LocalScript {
    <# .SYNOPSIS
    Runs a local script using its shebang, forwarding remaining arguments.
    .EXAMPLE
    runs backup.sh --target 'D:\My Backups'
    #>

    # Keep target script options out of PowerShell's named parameter binding.
    if ($args.Count -eq 0 -or -not $args[0]) {
        throw 'Usage: runs <script> [args]'
    }

    $scriptPath = [string]$args[0]
    if ($scriptPath -notmatch '[/\\]' -and -not [IO.Path]::IsPathRooted($scriptPath)) {
        $scriptPath = Join-Path $script:ScriptRunnerDirectory $scriptPath
    }
    $scriptPath = (Resolve-Path -LiteralPath $scriptPath -ErrorAction Stop).ProviderPath

    $scriptArgs = @()
    if ($args.Count -gt 1) {
        $scriptArgs = $args[1..($args.Count - 1)]
    }

    $interpreter = Get-ScriptInterpreter $scriptPath
    $interpreterPath = (Get-Command -Name $interpreter.Name -CommandType Application -ErrorAction Stop).Source
    $interpreterArgs = $interpreter.Args
    & $interpreterPath @interpreterArgs $scriptPath @scriptArgs
}

function Enable-ScriptPicker {
    <# .SYNOPSIS
    Binds Alt+s to insert an fzf-selected script into the command line.
    #>

    Set-PSReadLineKeyHandler -Chord 'Alt+s' -BriefDescription 'Select local script' -ScriptBlock {
        $selected = Get-LocalScript
        | Select-Object -ExpandProperty Name
        | fzf --prompt='script> ' --height=40% --layout=reverse

        if ($LASTEXITCODE -ne 0 -or -not $selected) {
            return
        }

        $quoted = Convert-ScriptName $selected
        $line = $null
        $cursor = 0
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
        if ([string]::IsNullOrWhiteSpace($line)) {
            [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $line.Length, "runs $quoted ")
        }
        else {
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$quoted ")
        }
    }
}

Set-Alias -Name runs -Value Invoke-LocalScript

Register-ArgumentCompleter -Native -CommandName Invoke-LocalScript, runs -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    if ($commandAst.CommandElements.Count -gt 1) {
        $scriptNameAst = $commandAst.CommandElements[1]
        $isCompletingScriptName = $cursorPosition -le $scriptNameAst.Extent.EndOffset
        if (-not $isCompletingScriptName) {
            return
        }

        if ($scriptNameAst -is [System.Management.Automation.Language.StringConstantExpressionAst]) {
            $wordToComplete = $scriptNameAst.Value
        }
    }

    Get-LocalScript | Where-Object {
        $_.Name.StartsWith($wordToComplete, [StringComparison]::OrdinalIgnoreCase)
    } | ForEach-Object {
        $quoted = Convert-ScriptName $_.Name
        [System.Management.Automation.CompletionResult]::new(
            $quoted, $_.Name, 'ParameterValue', $_.FullName
        )
    }
}

Export-ModuleMember -Function Invoke-LocalScript, Get-LocalScript, Get-ScriptInterpreter, Enable-ScriptPicker -Alias runs
