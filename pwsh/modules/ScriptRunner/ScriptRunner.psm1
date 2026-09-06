function Convert-ScriptName {
    param([string]$Value)

    return "'" + $Value.Replace("'", "''") + "'"
}

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
    <# .SYNOPSIS
    Returns the interpreter name and arguments for a script without running it.
    #>
    param([string]$Path)

    $firstLine = Get-Content -LiteralPath $Path -TotalCount 1
    if ($firstLine -notmatch '^#!\s*(.+)$') {
        if ([IO.Path]::GetExtension($Path) -eq '.ps1') {
            return [pscustomobject]@{
                Name = 'pwsh'
                Args = @('-NoProfile', '-File')
            }
        }
        throw "Script has no shebang: $Path"
    }

    # Pass the optional shebang argument intact for the interpreter to handle.
    $parts = @($Matches[1].Trim() -split '\s+', 2)
    return [pscustomobject]@{
        Name = ($parts[0] -split '/')[-1]
        Args = @($parts | Select-Object -Skip 1)
    }
}

function Invoke-LocalScript {
    <# .SYNOPSIS
    Runs a local script using its shebang, forwarding remaining arguments.
    .EXAMPLE
    runs backup.sh --target 'D:\My Backups'
    #>
    param([string]$ScriptPath)

    if (-not $ScriptPath) {
        throw 'Usage: runs <script> [args]'
    }

    $path = if ($ScriptPath -match '[/\\]' -or [IO.Path]::IsPathRooted($ScriptPath)) {
        $ScriptPath
    }
    else {
        Join-Path "$HOME/.local/bin" $ScriptPath
    }

    $path = (Resolve-Path -LiteralPath $path -ErrorAction Stop).ProviderPath

    $interpreter = Get-ScriptInterpreter $path
    $interpreterPath = Get-Command -Name $interpreter.Name -CommandType Application -ErrorAction Stop
    $interpreterArgs = $interpreter.Args
    & $interpreterPath @interpreterArgs $path @args
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

Register-ArgumentCompleter -CommandName Invoke-LocalScript, runs -ParameterName ScriptPath -ScriptBlock {
    # Argument completers receive the current word as their third argument.
    $wordToComplete = $args[2]

    Get-LocalScript | Where-Object Name -Like "$wordToComplete*" | ForEach-Object {
        $quoted = Convert-ScriptName $_.Name
        [System.Management.Automation.CompletionResult]::new(
            $quoted, $_.Name, 'ParameterValue', $_.FullName
        )
    }
}

Export-ModuleMember -Function Invoke-LocalScript, Get-LocalScript, Get-ScriptInterpreter, Enable-ScriptPicker -Alias runs
