param(
    [switch]$Strict
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$srcRoot = Join-Path $repoRoot 'src'

if (-not (Test-Path $srcRoot)) {
    Write-Error "src directory not found: $srcRoot"
}

function Normalize-RelPath {
    param([string]$FullPath)

    $full = [System.IO.Path]::GetFullPath($FullPath)
    $root = [System.IO.Path]::GetFullPath($repoRoot)
    if ($full.StartsWith($root, [System.StringComparison]::OrdinalIgnoreCase)) {
        $rel = $full.Substring($root.Length).TrimStart('\', '/')
        return $rel.Replace('\', '/')
    }

    return $full.Replace('\', '/')
}

function Get-SourceCategory {
    param([string]$RelPath)

    if ($RelPath.Equals('src/main.bas', [System.StringComparison]::OrdinalIgnoreCase)) {
        return 'main'
    }

    $parts = $RelPath.Split('/')
    if ($parts.Length -lt 2) {
        return 'unknown'
    }

    switch ($parts[1].ToLowerInvariant()) {
        'parser' { return 'parser' }
        'semantic' { return 'semantic' }
        'runtime' { return 'runtime' }
        'build' { return 'build' }
        'legacy' { return 'legacy' }
        'codegen' { return 'codegen' }
        'dist' { return 'dist' }
        default { return 'unknown' }
    }
}

function Is-HeaderLine {
    param([string]$Line)

    $trim = $Line.Trim()
    if ($trim -eq '') { return $true }
    if ($trim.StartsWith("'")) { return $true }
    if ($trim.StartsWith('#')) { return $true }
    if ($trim -match '^(?i)rem(\s|$)') { return $true }
    return $false
}

function Resolve-IncludePath {
    param(
        [string]$FromRelPath,
        [string]$TargetRaw
    )

    $fromAbs = Join-Path $repoRoot ($FromRelPath.Replace('/', '\'))
    $fromDir = Split-Path -Parent $fromAbs
    $targetWin = $TargetRaw.Replace('/', '\')

    $candidates = @(
        (Join-Path $fromDir $targetWin),
        (Join-Path $srcRoot $targetWin),
        (Join-Path $repoRoot $targetWin)
    )

    foreach ($cand in $candidates) {
        if (Test-Path $cand) {
            return [System.IO.Path]::GetFullPath($cand)
        }
    }

    return $null
}

function Visit-Dependency {
    param(
        [string]$Node,
        [string[]]$Path,
        [hashtable]$Adj,
        [hashtable]$Visit,
        [System.Collections.Generic.HashSet[string]]$CycleSet
    )

    $state = 0
    if ($Visit.ContainsKey($Node)) {
        $state = [int]$Visit[$Node]
    }

    if ($state -eq 1) {
        $idx = [Array]::IndexOf($Path, $Node)
        if ($idx -ge 0) {
            $cycleNodes = @($Path[$idx..($Path.Length - 1)] + $Node)
        } else {
            $cycleNodes = @($Path + $Node)
        }

        $cycleText = ($cycleNodes -join ' -> ')
        [void]$CycleSet.Add($cycleText)
        return
    }

    if ($state -eq 2) {
        return
    }

    $Visit[$Node] = 1
    $nextPath = @($Path + $Node)
    foreach ($nextNode in $Adj[$Node]) {
        Visit-Dependency -Node $nextNode -Path $nextPath -Adj $Adj -Visit $Visit -CycleSet $CycleSet
    }
    $Visit[$Node] = 2
}

$categoryRules = @{
    main = @{ WarnFunc = 70; FailFunc = 120; WarnFile = 220; FailFile = 450 }
    parser = @{ WarnFunc = 110; FailFunc = 180; WarnFile = 950; FailFile = 1400 }
    semantic = @{ WarnFunc = 120; FailFunc = 200; WarnFile = 900; FailFile = 1300 }
    runtime = @{ WarnFunc = 180; FailFunc = 400; WarnFile = 1800; FailFile = 3000 }
    build = @{ WarnFunc = 90; FailFunc = 140; WarnFile = 700; FailFile = 1000 }
    legacy = @{ WarnFunc = 100; FailFunc = 150; WarnFile = 450; FailFile = 900 }
    codegen = @{ WarnFunc = 120; FailFunc = 180; WarnFile = 700; FailFile = 1000 }
    dist = @{ WarnFunc = 80; FailFunc = 140; WarnFile = 700; FailFile = 1000 }
    unknown = @{ WarnFunc = 100; FailFunc = 150; WarnFile = 500; FailFile = 900 }
}

$functionHardDebtCap = @{
    'src/runtime/memory_exec.fbs::ExecRunStmt' = 1700
    'src/runtime/memory_exec.fbs::ExecEvalBuiltinCall' = 700
}

$fileHardDebtCap = @{
    'src/runtime/memory_exec.fbs' = 5200
}

$layerRank = @{
    legacy = 0
    runtime = 1
    parser = 2
    semantic = 3
    build = 4
    codegen = 5
    main = 6
    dist = 7
    unknown = 100
}

$errors = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

$sourceFiles = Get-ChildItem -Path $srcRoot -Recurse -File | Where-Object { $_.Extension -in '.bas', '.fbs' }
if ($sourceFiles.Count -eq 0) {
    Write-Error 'no source files found under src'
}

$fileInfos = New-Object System.Collections.Generic.List[object]
$functionInfos = New-Object System.Collections.Generic.List[object]
$includeInfos = New-Object System.Collections.Generic.List[object]
$sourcePathSet = @{}

$funcStartRegex = '^\s*(?:(?:Private|Public|Static)\s+)*(?:Sub|Function)\s+([A-Za-z_][A-Za-z0-9_]*)\b'
$funcEndRegex = '^\s*End\s+(?:Sub|Function)\b'
$includeRegex = '^\s*#include\s+"([^"]+)"'

foreach ($file in ($sourceFiles | Sort-Object FullName)) {
    $relPath = Normalize-RelPath $file.FullName
    $category = Get-SourceCategory $relPath
    $lines = Get-Content $file.FullName

    $fileInfos.Add([PSCustomObject]@{
            File = $relPath
            Category = $category
            LineCount = $lines.Count
        })
    $sourcePathSet[$relPath] = $true

    $seenCode = $false
    $firstIncludeLine = 0

    $insideFunction = $false
    $funcName = ''
    $funcStart = 0

    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        $lineNo = $i + 1

        $incMatch = [System.Text.RegularExpressions.Regex]::Match($line, $includeRegex)
        if ($incMatch.Success) {
            if ($firstIncludeLine -eq 0) {
                $firstIncludeLine = $lineNo
            }

            if ($seenCode) {
                $errors.Add("include after code: ${relPath}:$lineNo")
            }

            $includeInfos.Add([PSCustomObject]@{
                    File = $relPath
                    Category = $category
                    Line = $lineNo
                    Target = $incMatch.Groups[1].Value
                })
        } elseif (-not (Is-HeaderLine $line)) {
            $seenCode = $true
        }

        if (-not $insideFunction) {
            if ($line -match '(?i)\bDeclare\b') {
                continue
            }

            $startMatch = [System.Text.RegularExpressions.Regex]::Match($line, $funcStartRegex)
            if ($startMatch.Success) {
                $insideFunction = $true
                $funcName = $startMatch.Groups[1].Value
                $funcStart = $lineNo
            }
        } else {
            if ([System.Text.RegularExpressions.Regex]::IsMatch($line, $funcEndRegex)) {
                $funcLines = $lineNo - $funcStart + 1
                $functionInfos.Add([PSCustomObject]@{
                        File = $relPath
                        Category = $category
                        Name = $funcName
                        StartLine = $funcStart
                        EndLine = $lineNo
                        LineCount = $funcLines
                    })
                $insideFunction = $false
            }
        }
    }

    if ($insideFunction) {
        $errors.Add("unterminated function block: ${relPath}:$funcStart ($funcName)")
    }

    if ($firstIncludeLine -gt 40) {
        $warnings.Add("late include block: $relPath first include at line $firstIncludeLine")
    }
}

$requiredCategories = @('parser', 'semantic', 'runtime', 'build', 'legacy')
$categoryGroups = $fileInfos | Group-Object Category
$presentCategories = @{}
foreach ($g in $categoryGroups) {
    $presentCategories[$g.Name] = $g.Count
}

foreach ($reqCat in $requiredCategories) {
    if (-not $presentCategories.ContainsKey($reqCat)) {
        $warnings.Add("missing expected source category: $reqCat")
    }
}

foreach ($fi in $fileInfos) {
    if ($fi.Category -eq 'unknown') {
        $errors.Add("unknown category path: $($fi.File)")
    }
}

foreach ($fn in $functionInfos) {
    $rule = $categoryRules[$fn.Category]
    if ($null -eq $rule) {
        $rule = $categoryRules['unknown']
    }

    $fnKey = "$($fn.File)::$($fn.Name)"
    if ($fn.LineCount -gt [int]$rule.FailFunc) {
        if ($functionHardDebtCap.ContainsKey($fnKey)) {
            $cap = [int]$functionHardDebtCap[$fnKey]
            if ($fn.LineCount -gt $cap) {
                $errors.Add("function exceeds debt cap: $fnKey lines=$($fn.LineCount) cap=$cap")
            } else {
                $warnings.Add("function over category fail limit under debt cap: $fnKey lines=$($fn.LineCount) fail=$($rule.FailFunc) cap=$cap")
            }
        } else {
            $errors.Add("function too long: $fnKey lines=$($fn.LineCount) fail=$($rule.FailFunc)")
        }
    } elseif ($fn.LineCount -gt [int]$rule.WarnFunc) {
        $warnings.Add("function near limit: $fnKey lines=$($fn.LineCount) warn=$($rule.WarnFunc)")
    }
}

foreach ($fi in $fileInfos) {
    $rule = $categoryRules[$fi.Category]
    if ($null -eq $rule) {
        $rule = $categoryRules['unknown']
    }

    if ($fi.LineCount -gt [int]$rule.FailFile) {
        if ($fileHardDebtCap.ContainsKey($fi.File)) {
            $cap = [int]$fileHardDebtCap[$fi.File]
            if ($fi.LineCount -gt $cap) {
                $errors.Add("file exceeds debt cap: $($fi.File) lines=$($fi.LineCount) cap=$cap")
            } else {
                $warnings.Add("file over category fail limit under debt cap: $($fi.File) lines=$($fi.LineCount) fail=$($rule.FailFile) cap=$cap")
            }
        } else {
            $errors.Add("file too long for category: $($fi.File) lines=$($fi.LineCount) fail=$($rule.FailFile)")
        }
    } elseif ($fi.LineCount -gt [int]$rule.WarnFile) {
        $warnings.Add("file near limit: $($fi.File) lines=$($fi.LineCount) warn=$($rule.WarnFile)")
    }
}

$edges = New-Object System.Collections.Generic.List[object]
foreach ($inc in $includeInfos) {
    $resolvedAbs = Resolve-IncludePath -FromRelPath $inc.File -TargetRaw $inc.Target
    if ($null -eq $resolvedAbs) {
        $warnings.Add("unresolved include: $($inc.File):$($inc.Line) -> $($inc.Target)")
        continue
    }

    $resolvedRel = Normalize-RelPath $resolvedAbs
    if (-not $sourcePathSet.ContainsKey($resolvedRel)) {
        continue
    }

    if ($resolvedRel -eq $inc.File) {
        $errors.Add("self include detected: $($inc.File):$($inc.Line)")
        continue
    }

    $toCategory = Get-SourceCategory $resolvedRel
    $edges.Add([PSCustomObject]@{
            From = $inc.File
            FromCategory = $inc.Category
            To = $resolvedRel
            ToCategory = $toCategory
            Line = $inc.Line
        })
}

foreach ($e in $edges) {
    $fromRank = [int]$layerRank[$e.FromCategory]
    $toRank = [int]$layerRank[$e.ToCategory]

    if ($fromRank -eq 100 -or $toRank -eq 100) {
        $warnings.Add("layer check skipped due to unknown category: $($e.From) -> $($e.To)")
        continue
    }

    if ($fromRank -lt $toRank) {
        $errors.Add("layer violation: $($e.FromCategory) cannot include $($e.ToCategory) ($($e.From):$($e.Line) -> $($e.To))")
    }
}

$adj = @{}
foreach ($sp in $sourcePathSet.Keys) {
    $adj[$sp] = New-Object System.Collections.Generic.List[string]
}
foreach ($e in $edges) {
    $adj[$e.From].Add($e.To)
}

$visit = @{}
$cycleSet = New-Object 'System.Collections.Generic.HashSet[string]'
foreach ($node in ($adj.Keys | Sort-Object)) {
    Visit-Dependency -Node $node -Path @() -Adj $adj -Visit $visit -CycleSet $cycleSet
}

foreach ($cycle in ($cycleSet | Sort-Object)) {
    $errors.Add("include cycle: $cycle")
}

$totalIncludes = $includeInfos.Count
if ($totalIncludes -gt 0) {
    $includeByFile = $includeInfos | Group-Object File | Sort-Object Count -Descending
    $topFile = $includeByFile[0]
    $topRatio = [double]$topFile.Count / [double]$totalIncludes

    if ($topFile.Count -gt 20) {
        $errors.Add("include concentration too high in single file: $($topFile.Name) count=$($topFile.Count)")
    } elseif ($topFile.Count -gt 12) {
        $warnings.Add("include concentration warning in single file: $($topFile.Name) count=$($topFile.Count)")
    }

    if ($topRatio -gt 0.85) {
        $warnings.Add("include concentration ratio high: file=$($topFile.Name) ratio=$([math]::Round(($topRatio * 100), 1))%")
    }
}

Write-Host 'MODULE QUALITY GATE REPORT'
Write-Host " - source files: $($fileInfos.Count)"
Write-Host " - functions: $($functionInfos.Count)"
Write-Host " - includes: $($includeInfos.Count)"
Write-Host " - dependency edges: $($edges.Count)"
Write-Host " - warnings: $($warnings.Count)"
Write-Host " - errors: $($errors.Count)"

if ($warnings.Count -gt 0) {
    Write-Host 'WARNINGS' -ForegroundColor Yellow
    foreach ($w in $warnings) {
        Write-Host " - $w" -ForegroundColor Yellow
    }
}

if ($errors.Count -gt 0) {
    Write-Host 'ERRORS' -ForegroundColor Red
    foreach ($e in $errors) {
        Write-Host " - $e" -ForegroundColor Red
    }
    Write-Host 'MODULE QUALITY GATE FAILED' -ForegroundColor Red
    exit 1
}

if ($Strict -and $warnings.Count -gt 0) {
    Write-Host 'STRICT MODE: warnings are treated as failures' -ForegroundColor Red
    exit 1
}

if ($warnings.Count -gt 0) {
    Write-Host 'MODULE QUALITY GATE PASSED WITH WARNINGS' -ForegroundColor Yellow
    exit 0
}

Write-Host 'MODULE QUALITY GATE PASSED' -ForegroundColor Green
exit 0