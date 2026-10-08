[Diagnostics.CodeAnalysis.SuppressMessageAttribute(
    'PSAvoidGlobalVars',
    '',
    Justification = 'Retains the original prompt and command history state across prompt invocations.'
)]
param()

if (-not $Global:__WTIntegrationLoaded) {
    $Global:__WTIntegrationLoaded = $true
    $Global:__OriginalPrompt = $function:Prompt
    $Global:__TerminalLastHistoryId = -1
    function Global:prompt {
        # Capture status before any other statement can overwrite it.
        $commandSucceeded = $?
        $nativeExitCode = $LASTEXITCODE
        $lastHistory = Get-History -Count 1
        $commandEnd = ""

        if ($Global:__TerminalLastHistoryId -ne -1) {
            $hasNewHistoryEntry =
            $null -ne $lastHistory -and
            $lastHistory.Id -ne $Global:__TerminalLastHistoryId

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
        $promptText = $Global:__OriginalPrompt.Invoke()

        # Zero means the initial prompt was shown, before any command was run.
        $Global:__TerminalLastHistoryId = if ($null -ne $lastHistory) { $lastHistory.Id } else { 0 }

        return -join @(
            $commandEnd
            "`e]133;A`a" # Prompt start
            "`e]9;9;`"$cwd`"`a" # Current working directory
            $promptText
            "`e]133;B`a" # Prompt end
        )
    }
}
