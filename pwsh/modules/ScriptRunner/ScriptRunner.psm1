function Get-LocalScript {
    <# .SYNOPSIS
    Lists local scripts with a shebang or a .ps1 extension.
    #>
    Get-ChildItem -LiteralPath "$HOME/.local/bin" -File | Where-Object {
        $_.Extension -eq '.ps1' -or
        (Get-Content -LiteralPath $_.FullName -TotalCount 1) -match '^#!'
    }
}

function Get-ScriptInterpreter {
    param([string]$Path)

    $firstLine = Get-Content -LiteralPath $Path -TotalCount 1
    if ($firstLine -notmatch '^#!\s*(.+)$') {
        if ([IO.Path]::GetExtension($Path) -eq '.ps1') {
            return 'pwsh', '-NoProfile', '-File'
        }
        throw "Script has no shebang: $Path"
    }

    # Pass the optional shebang argument intact for the interpreter to handle.
    $parts = @($Matches[1].Trim() -split '\s+', 2)
    $parts[0] = ($parts[0] -split '/')[-1]
    return $parts
}

function Invoke-LocalScript {
    <# .SYNOPSIS
    Runs a local script using its shebang, forwarding remaining arguments.
    .EXAMPLE
    runs backup.sh --target 'D:\My Backups'
    #>
    # A simple function deliberately avoids common parameters intercepting
    # the target script's -Verbose, -Debug, etc.
    param([string]$ScriptPath)

    if (-not $ScriptPath) {
        throw 'Usage: runs <script name or path> [arguments]. Use Alt+s to select a script.'
    }
    $path = if ($ScriptPath -match '[/\\]' -or [IO.Path]::IsPathRooted($ScriptPath)) {
        $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ScriptPath)
    }
    else {
        Join-Path "$HOME/.local/bin" $ScriptPath
    }
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        throw "Script not found: $path"
    }
    $interpreter = @(Get-ScriptInterpreter $path)
    $command = Get-Command -Name $interpreter[0] -CommandType Application -ErrorAction Stop
    $prefix = @($interpreter | Select-Object -Skip 1)
    $global:LASTEXITCODE = 0
    & $command.Source @prefix $path @args
}

Set-Alias -Name runs -Value Invoke-LocalScript

$completeScript = {
    $wordToComplete = $args[2]

    Get-LocalScript | Where-Object Name -Like "$wordToComplete*" | ForEach-Object {
        $quoted = "'" + $_.Name.Replace("'", "''") + "'"
        [System.Management.Automation.CompletionResult]::new(
            $quoted, $_.Name, 'ParameterValue', $_.FullName
        )
    }
}.GetNewClosure()
Register-ArgumentCompleter -CommandName Invoke-LocalScript, runs -ParameterName ScriptPath -ScriptBlock $completeScript

function Enable-ScriptPicker {
    <# .SYNOPSIS
    Binds Alt+s to insert an fzf-selected script into the command line.
    #>
    Set-PSReadLineKeyHandler -Chord 'Alt+s' -BriefDescription 'Select local script' -ScriptBlock {
        $selected = Get-LocalScript | Select-Object -ExpandProperty Name | fzf --prompt='script> ' --height=40% --layout=reverse
        if ($LASTEXITCODE -eq 0 -and $selected) {
            $quoted = "'" + $selected.Replace("'", "''") + "'"
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
}

Export-ModuleMember -Function Invoke-LocalScript, Get-LocalScript, Enable-ScriptPicker -Alias runs
