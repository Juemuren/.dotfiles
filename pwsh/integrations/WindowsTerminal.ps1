[Diagnostics.CodeAnalysis.SuppressMessageAttribute(
    'PSAvoidGlobalVars',
    '',
    Justification = 'Retains the original prompt, line reader, and command history state across invocations.'
)]
param()

if ($Global:__WTState) {
    return
}
$Global:__WTState = @{
    OriginalPrompt                = $function:Prompt
    OriginalPSConsoleHostReadLine = $function:PSConsoleHostReadLine
    LastHistoryId                 = -1
}

# PSReadLine is initialized by the profile before loading this integration.
function Global:PSConsoleHostReadLine {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidUsingWriteHost',
        '',
        Justification = 'Writes terminal metadata without adding it to the command text returned to the host.'
    )]
    param()

    $commandLine = $Global:__WTState.OriginalPSConsoleHostReadLine.Invoke()
    # Input has been accepted; mark output start before the host executes it.
    [Console]::Write("`e]133;C`a")
    return $commandLine
}

# Load this integration after prompt initialization.
function Global:prompt {
    # Capture status before any other statement can overwrite it.
    $commandSucceeded = $?
    $nativeExitCode = $LASTEXITCODE
    $lastHistory = Get-History -Count 1
    $commandEnd = ""

    if ($Global:__WTState.LastHistoryId -ne -1) {
        $hasNewHistoryEntry =
        $null -ne $lastHistory -and
        $lastHistory.Id -ne $Global:__WTState.LastHistoryId

        if ($hasNewHistoryEntry) {
            $exitCode = if ($commandSucceeded) {
                0
            }
            elseif ($Error.Count -gt 0 -and $Error[0].InvocationInfo.HistoryId -eq $lastHistory.Id) {
                -1 # PowerShell errors do not have a native process exit code.
            }
            else {
                $nativeExitCode
            }
            $commandEnd = "`e]133;D;$exitCode`a"
        }
        else {
            $commandEnd = "`e]133;D`a"
        }
    }

    $cwd = $ExecutionContext.SessionState.Path.CurrentLocation

    # Starship reads $? on entry. Restore failure without adding to $Error.
    if (-not $commandSucceeded) {
        Write-Error '' -ErrorAction Ignore
    }
    $promptText = $Global:__WTState.OriginalPrompt.Invoke()

    # Zero means the initial prompt was shown, before any command was run.
    $Global:__WTState.LastHistoryId = if ($null -ne $lastHistory) { $lastHistory.Id } else { 0 }

    return -join @(
        $commandEnd
        "`e]133;A`a" # Prompt start
        "`e]9;9;`"$cwd`"`a" # Current working directory
        $promptText
        "`e]133;B`a" # Prompt end
    )
}
