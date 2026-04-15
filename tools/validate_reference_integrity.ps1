[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$issues = New-Object System.Collections.Generic.List[string]

function Add-Issue {
    param(
        [Parameter(Mandatory = $true)][string]$Message
    )
    $null = $script:issues.Add($Message)
}

function Get-RequiredPath {
    param(
        [Parameter(Mandatory = $true)][string]$RelativePath
    )

    $fullPath = Join-Path $repoRoot $RelativePath
    if (-not (Test-Path -LiteralPath $fullPath)) {
        Add-Issue ("Missing required file: {0}" -f $RelativePath)
    }

    return $fullPath
}

$matrixPath = Get-RequiredPath -RelativePath "reports/uxbasic_operasyonel_eksiklik_matrisi.md"
$commandCompatPath = Get-RequiredPath -RelativePath "tests/plan/command_compatibility_win11.csv"
$manifestPath = Get-RequiredPath -RelativePath "tests/manifest.csv"
$cmpInteropPath = Get-RequiredPath -RelativePath "tests/plan/cmp_interop_win11.csv"

if ($issues.Count -gt 0) {
    Write-Output ("FAILED: reference integrity checks found {0} issue(s)." -f $issues.Count)
    foreach ($issue in $issues) {
        Write-Output ("ERROR: {0}" -f $issue)
    }
    exit 1
}

$pathSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)

# 1) Collect tests/run_*.bas references from matrix markdown and verify file existence.
$matrixContent = Get-Content -LiteralPath $matrixPath -Raw
$matrixMatches = [System.Text.RegularExpressions.Regex]::Matches($matrixContent, 'tests/run_[A-Za-z0-9_]+\.bas')
foreach ($match in $matrixMatches) {
    $refPath = $match.Value
    if ($pathSet.Add($refPath)) {
        $fullRefPath = Join-Path $repoRoot $refPath
        if (-not (Test-Path -LiteralPath $fullRefPath)) {
            Add-Issue ("Matrix reference not found on disk: {0}" -f $refPath)
        }
    }
}

# 2) Parse test_ref in command compatibility CSV and validate token references.
$manifestRows = Import-Csv -LiteralPath $manifestPath
$cmpRows = Import-Csv -LiteralPath $cmpInteropPath
$commandRows = @()
$commandLines = Get-Content -LiteralPath $commandCompatPath

if ($commandLines.Count -lt 2) {
    Add-Issue "No data rows found in tests/plan/command_compatibility_win11.csv."
} else {
    $header = $commandLines[0].Trim()
    if ($header -ne "command,syntax,status,compiler_layer,test_ref,notes") {
        Add-Issue "Unexpected header in tests/plan/command_compatibility_win11.csv."
    }

    for ($lineIndex = 1; $lineIndex -lt $commandLines.Count; $lineIndex++) {
        $line = $commandLines[$lineIndex]
        if ([string]::IsNullOrWhiteSpace($line)) {
            continue
        }

        # Parse by anchoring around status/compiler_layer/test_ref columns; syntax can contain commas.
        $match = [regex]::Match($line, '^(?<command>[^,]*),(?<syntax>.*?),(?<status>implemented|partial|planned|experimental|deprecated),(?<compiler_layer>[^,]+),(?<test_ref>[^,]*),(?<notes>.*)$')
        if (-not $match.Success) {
            Add-Issue ("Unable to parse command_compatibility row {0}: {1}" -f ($lineIndex + 1), $line)
            continue
        }

        $commandRows += [pscustomobject]@{
            line_number = $lineIndex + 1
            command = $match.Groups['command'].Value
            test_ref = $match.Groups['test_ref'].Value
        }
    }
}

$manifestIdSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
foreach ($row in $manifestRows) {
    if ($null -ne $row.PSObject.Properties["test_id"]) {
        $id = [string]$row.test_id
        if (-not [string]::IsNullOrWhiteSpace($id)) {
            $null = $manifestIdSet.Add($id.Trim())
        }
    }
}

$cmpIdSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
foreach ($row in $cmpRows) {
    if ($null -ne $row.PSObject.Properties["cmp_id"]) {
        $id = [string]$row.cmp_id
        if (-not [string]::IsNullOrWhiteSpace($id)) {
            $null = $cmpIdSet.Add($id.Trim())
        }
    }
}

if ($manifestIdSet.Count -eq 0) {
    Add-Issue "No manifest IDs loaded from tests/manifest.csv (expected column: test_id)."
}
if ($cmpIdSet.Count -eq 0) {
    Add-Issue "No CMP IDs loaded from tests/plan/cmp_interop_win11.csv (expected column: cmp_id)."
}

if ($commandRows.Count -eq 0) {
    Add-Issue "No rows loaded from tests/plan/command_compatibility_win11.csv."
}

for ($i = 0; $i -lt $commandRows.Count; $i++) {
    $row = $commandRows[$i]
    $lineNumber = [int]$row.line_number

    if ($null -eq $row.PSObject.Properties["test_ref"]) {
        Add-Issue "Missing required column 'test_ref' in tests/plan/command_compatibility_win11.csv."
        break
    }

    $commandValue = ""
    if ($null -ne $row.PSObject.Properties["command"]) {
        $commandValue = [string]$row.command
    }

    $testRefRaw = [string]$row.test_ref
    if ([string]::IsNullOrWhiteSpace($testRefRaw)) {
        continue
    }

    $tokens = $testRefRaw -split "\|"
    foreach ($tokenCandidate in $tokens) {
        $token = $tokenCandidate.Trim()
        if ([string]::IsNullOrWhiteSpace($token)) {
            continue
        }

        if ($token -cmatch '^TST-[A-Za-z0-9_-]+$') {
            if (-not $manifestIdSet.Contains($token)) {
                Add-Issue ("command_compatibility row {0} ({1}): TST id not found in tests/manifest.csv -> {2}" -f $lineNumber, $commandValue, $token)
            }
            continue
        }

        if ($token -cmatch '^CMP-[A-Za-z0-9_-]+$') {
            if (-not $cmpIdSet.Contains($token)) {
                Add-Issue ("command_compatibility row {0} ({1}): CMP id not found in tests/plan/cmp_interop_win11.csv -> {2}" -f $lineNumber, $commandValue, $token)
            }
            continue
        }

        if ($token -cmatch '^tests/.+\.bas$') {
            if ($pathSet.Add($token)) {
                $fullRefPath = Join-Path $repoRoot $token
                if (-not (Test-Path -LiteralPath $fullRefPath)) {
                    Add-Issue ("command_compatibility row {0} ({1}): test file not found on disk -> {2}" -f $lineNumber, $commandValue, $token)
                }
            }
            continue
        }

        Add-Issue ("command_compatibility row {0} ({1}): unsupported test_ref token -> {2}" -f $lineNumber, $commandValue, $token)
    }
}

if ($issues.Count -gt 0) {
    Write-Output ("FAILED: reference integrity checks found {0} issue(s)." -f $issues.Count)
    foreach ($issue in $issues) {
        Write-Output ("ERROR: {0}" -f $issue)
    }
    exit 1
}

Write-Output "PASSED: reference integrity checks succeeded."
exit 0
