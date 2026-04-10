$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$manifestPath = Join-Path $repoRoot 'tests/manifest.csv'
$planDir = Join-Path $repoRoot 'tests/plan'
$compatPath = Join-Path $planDir 'command_compatibility_win11.csv'
$cmpInteropPath = Join-Path $planDir 'cmp_interop_win11.csv'
$testsDir = Join-Path $repoRoot 'tests'

if (-not (Test-Path $manifestPath)) {
    Write-Error "manifest not found: $manifestPath"
}
if (-not (Test-Path $planDir)) {
    Write-Error "plan directory not found: $planDir"
}
if (-not (Test-Path $compatPath)) {
    Write-Error "compatibility plan not found: $compatPath"
}
if (-not (Test-Path $cmpInteropPath)) {
    Write-Error "interop plan not found: $cmpInteropPath"
}

$regexOptions = [System.Text.RegularExpressions.RegexOptions]::CultureInvariant
$testIdRegex = '^TST-[A-Z0-9]+(?:-[A-Z0-9]+)*-[0-9]{3}$'
$cmpIdRegex = '^CMP-[A-Z0-9]+(?:-[A-Z0-9]+)*$'
$phaseRegex = '^phase[0-9]+$'
$runnerRegex = '^run_[a-z0-9_]+\.bas$'
$testRefFieldRegex = ',(?<test_ref>(?:TST-[A-Z0-9]+(?:-[A-Z0-9]+)*-[0-9]{3}|CMP-[A-Z0-9]+(?:-[A-Z0-9]+)*|tests\/[^,\r\n]+)(?:\|(?:TST-[A-Z0-9]+(?:-[A-Z0-9]+)*-[0-9]{3}|CMP-[A-Z0-9]+(?:-[A-Z0-9]+)*|tests\/[^,\r\n]+))*)(?=,)'

$errors = New-Object System.Collections.Generic.List[string]
$manifestIds = @{}
$idToPhase = @{}
$manifestPhaseHasRows = @{}
$coveredPhases = @{}
$compatCmpRefs = @{}
$cmpPlanIds = @{}

$manifestRows = Import-Csv $manifestPath
if ($manifestRows.Count -eq 0) {
    Write-Error 'manifest is empty'
}

foreach ($row in $manifestRows) {
    $id = [string]$row.test_id
    $phase = [string]$row.phase

    if ([string]::IsNullOrWhiteSpace($id)) {
        $errors.Add('empty test_id found in manifest')
        continue
    }

    if (-not [System.Text.RegularExpressions.Regex]::IsMatch($id, $testIdRegex, $regexOptions)) {
        $errors.Add("invalid test_id format: $id")
        continue
    }

    if ($manifestIds.ContainsKey($id)) {
        $errors.Add("duplicate test_id: $id")
        continue
    }

    if ([string]::IsNullOrWhiteSpace($phase)) {
        $errors.Add("empty phase in manifest for test_id: $id")
        continue
    }

    if (-not [System.Text.RegularExpressions.Regex]::IsMatch($phase, $phaseRegex, $regexOptions)) {
        $errors.Add("invalid phase format in manifest: $phase (test_id: $id)")
        continue
    }

    $manifestIds[$id] = $true
    $idToPhase[$id] = $phase
    $manifestPhaseHasRows[$phase] = $true
}

$compatLines = Get-Content $compatPath
for ($i = 1; $i -lt $compatLines.Count; $i++) {
    $line = $compatLines[$i]
    if ([string]::IsNullOrWhiteSpace($line)) { continue }

    $match = [System.Text.RegularExpressions.Regex]::Match($line, $testRefFieldRegex, $regexOptions)
    if (-not $match.Success) {
        $errors.Add("could not parse test_ref at compatibility row $($i + 1)")
        continue
    }

    $testRef = $match.Groups['test_ref'].Value.Trim()
    if ([string]::IsNullOrWhiteSpace($testRef)) {
        $errors.Add("empty test_ref at compatibility row $($i + 1)")
        continue
    }

    $parts = $testRef.Split('|')
    foreach ($p in $parts) {
        $token = $p.Trim()
        if ([string]::IsNullOrWhiteSpace($token)) { continue }

        if ($token.StartsWith('tests/')) {
            $evidencePath = Join-Path $repoRoot ($token.Replace('/', '\\'))
            if (-not (Test-Path $evidencePath)) {
                $errors.Add("compatibility evidence path not found: $token (row $($i + 1))")
            }
            continue
        }

        if ($token.StartsWith('CMP-')) {
            if (-not [System.Text.RegularExpressions.Regex]::IsMatch($token, $cmpIdRegex, $regexOptions)) {
                $errors.Add("invalid CMP reference format in test_ref: $token (row $($i + 1))")
            }
            $compatCmpRefs[$token] = $true
            continue
        }

        if (-not $manifestIds.ContainsKey($token)) {
            $errors.Add("compatibility test_ref not found in manifest: $token (row $($i + 1))")
            continue
        }

        $coveredPhases[$idToPhase[$token]] = $true
    }
}

$cmpRows = Import-Csv $cmpInteropPath
if ($cmpRows.Count -eq 0) {
    $errors.Add('cmp_interop_win11.csv is empty')
} else {
    foreach ($row in $cmpRows) {
        $cmpId = [string]$row.cmp_id
        $evidence = [string]$row.evidence

        if ([string]::IsNullOrWhiteSpace($cmpId)) {
            $errors.Add('empty cmp_id found in cmp_interop_win11.csv')
            continue
        }

        if (-not [System.Text.RegularExpressions.Regex]::IsMatch($cmpId, $cmpIdRegex, $regexOptions)) {
            $errors.Add("invalid cmp_id format: $cmpId")
        }

        if ($cmpPlanIds.ContainsKey($cmpId)) {
            $errors.Add("duplicate cmp_id: $cmpId")
        } else {
            $cmpPlanIds[$cmpId] = $true
        }

        if ([string]::IsNullOrWhiteSpace($evidence)) {
            $errors.Add("empty evidence for cmp_id: $cmpId")
        } elseif (-not $evidence.StartsWith('tests/')) {
            $errors.Add("cmp evidence must be tests/ relative path: $cmpId -> $evidence")
        } else {
            $evidencePath = Join-Path $repoRoot ($evidence.Replace('/', '\\'))
            if (-not (Test-Path $evidencePath)) {
                $errors.Add("cmp evidence path not found: $cmpId -> $evidence")
            }
        }
    }
}

foreach ($cmpRef in $compatCmpRefs.Keys) {
    if (-not $cmpPlanIds.ContainsKey($cmpRef)) {
        $errors.Add("compatibility test_ref CMP id not found in cmp_interop plan: $cmpRef")
    }
}

foreach ($phaseName in $manifestPhaseHasRows.Keys) {
    if (-not $coveredPhases.ContainsKey($phaseName)) {
        $errors.Add("phase not covered by command_compatibility test_ref: $phaseName")
    }
}

$phaseNumbers = New-Object System.Collections.Generic.List[int]
foreach ($phaseName in $manifestPhaseHasRows.Keys) {
    $phaseNumbers.Add([int]($phaseName.Substring(5)))
}

if ($phaseNumbers.Count -gt 0) {
    $minPhase = ($phaseNumbers | Measure-Object -Minimum).Minimum
    $maxPhase = ($phaseNumbers | Measure-Object -Maximum).Maximum
    $phaseSet = @{}
    foreach ($n in $phaseNumbers) { $phaseSet[[string]$n] = $true }

    for ($n = $minPhase; $n -le $maxPhase; $n++) {
        if (-not $phaseSet.ContainsKey([string]$n)) {
            $errors.Add("missing manifest phase index: phase$n")
        }
    }
}

$runnerFiles = Get-ChildItem -Path $testsDir -Filter 'run_*.bas' -File
foreach ($rf in $runnerFiles) {
    if (-not [System.Text.RegularExpressions.Regex]::IsMatch($rf.Name, $runnerRegex, $regexOptions)) {
        $errors.Add("invalid runner file name: $($rf.Name)")
    }
}

if ($errors.Count -gt 0) {
    Write-Host 'TEST NAMING VALIDATION FAILED' -ForegroundColor Red
    foreach ($e in $errors) {
        Write-Host " - $e" -ForegroundColor Red
    }
    exit 1
}

Write-Host 'TEST NAMING VALIDATION PASSED' -ForegroundColor Green
exit 0
