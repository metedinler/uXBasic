param(
    [string]$MatrixPath = 'reports/uxbasic_operasyonel_eksiklik_matrisi.md',
    [string]$AllowListPath,
    [switch]$Strict
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot

function Resolve-RepoPath {
    param([string]$InputPath)

    if ([string]::IsNullOrWhiteSpace($InputPath)) {
        return $null
    }

    if ([System.IO.Path]::IsPathRooted($InputPath)) {
        return [System.IO.Path]::GetFullPath($InputPath)
    }

    return [System.IO.Path]::GetFullPath((Join-Path $repoRoot $InputPath))
}

function Normalize-CellText {
    param([string]$Text)

    if ($null -eq $Text) {
        return ''
    }

    $clean = $Text.Trim()
    $clean = [System.Text.RegularExpressions.Regex]::Replace($clean, '\s+', ' ')
    return $clean
}

function Normalize-KeyText {
    param([string]$Text)

    $clean = Normalize-CellText $Text
    return $clean.ToLowerInvariant()
}

function Split-MarkdownRow {
    param([string]$Line)

    if ($null -eq $Line) {
        return @()
    }

    $trimmed = $Line.Trim()
    if (-not $trimmed.StartsWith('|')) {
        return @()
    }

    if (-not $trimmed.EndsWith('|')) {
        return @()
    }

    $inner = $trimmed.Trim('|')
    $parts = $inner.Split('|')
    $cells = New-Object System.Collections.Generic.List[string]
    foreach ($part in $parts) {
        $cells.Add((Normalize-CellText $part))
    }

    return $cells
}

function Is-MarkdownSeparatorRow {
    param([string[]]$Cells)

    if ($null -eq $Cells -or $Cells.Count -eq 0) {
        return $false
    }

    foreach ($cell in $Cells) {
        if ([string]::IsNullOrWhiteSpace($cell)) {
            return $false
        }

        $raw = $cell.Replace(' ', '')
        if ($raw -notmatch '^[\-:]+$') {
            return $false
        }

        if ($raw -notmatch '-') {
            return $false
        }
    }

    return $true
}

function Build-AllowKey {
    param(
        [string]$Section,
        [string]$Item,
        [string]$Column
    )

    $sec = Normalize-KeyText $Section
    $itm = Normalize-KeyText $Item
    $col = (Normalize-CellText $Column).ToUpperInvariant()
    return "$sec|$itm|$col"
}

function Parse-AllowList {
    param(
        [string]$Path,
        [datetime]$Today
    )

    $result = [PSCustomObject]@{
        Map = @{}
        Count = 0
    }

    if ([string]::IsNullOrWhiteSpace($Path)) {
        return $result
    }

    if (-not (Test-Path $Path)) {
        Write-Host "[FAIL] allowlist not found: $Path" -ForegroundColor Red
        exit 1
    }

    $lines = Get-Content $Path
    $active = New-Object System.Collections.Generic.List[string]
    foreach ($line in $lines) {
        $trimmed = $line.Trim()
        if ($trimmed -eq '') { continue }
        if ($trimmed.StartsWith('#')) { continue }
        $active.Add($line)
    }

    if ($active.Count -eq 0) {
        Write-Host "[FAIL] allowlist has no header: $Path" -ForegroundColor Red
        exit 1
    }

    $requiredHeaders = @('section', 'item', 'column', 'expires_on', 'owner', 'reason')
    $headerNames = (Normalize-CellText $active[0]).Split(',') | ForEach-Object { Normalize-CellText $_ }
    $rows = @()

    if ($active.Count -gt 1) {
        $parsedRows = $active | ConvertFrom-Csv
        if ($null -eq $parsedRows) {
            Write-Host "[FAIL] allowlist parse failed: $Path" -ForegroundColor Red
            exit 1
        }

        if ($parsedRows -is [array]) {
            $rows = $parsedRows
        } else {
            $rows = @($parsedRows)
        }
    }

    foreach ($h in $requiredHeaders) {
        if (-not ($headerNames -contains $h)) {
            Write-Host "[FAIL] allowlist missing required column '$h': $Path" -ForegroundColor Red
            exit 1
        }
    }

    $expired = New-Object System.Collections.Generic.List[string]
    $validationErrors = New-Object System.Collections.Generic.List[string]

    foreach ($row in $rows) {
        $section = Normalize-CellText ([string]$row.section)
        $item = Normalize-CellText ([string]$row.item)
        $column = (Normalize-CellText ([string]$row.column)).ToUpperInvariant()
        $expiresOn = Normalize-CellText ([string]$row.expires_on)
        $owner = Normalize-CellText ([string]$row.owner)
        $reason = Normalize-CellText ([string]$row.reason)

        if ($section -eq '' -or $item -eq '' -or $column -eq '' -or $expiresOn -eq '' -or $owner -eq '' -or $reason -eq '') {
            $validationErrors.Add("allowlist row has empty required field: section='$section' item='$item' column='$column'")
            continue
        }

        if ($column -notin @('P', 'S', 'R', 'T')) {
            $validationErrors.Add("allowlist column must be P/S/R/T: section='$section' item='$item' column='$column'")
            continue
        }

        if ($expiresOn -notmatch '^\d{4}-\d{2}-\d{2}$') {
            $validationErrors.Add("allowlist expires_on must be YYYY-MM-DD: section='$section' item='$item' expires_on='$expiresOn'")
            continue
        }

        $parsedDate = $null
        try {
            $parsedDate = [datetime]::ParseExact(
                $expiresOn,
                'yyyy-MM-dd',
                [System.Globalization.CultureInfo]::InvariantCulture,
                [System.Globalization.DateTimeStyles]::None
            )
        } catch {
            $validationErrors.Add("allowlist expires_on invalid date: section='$section' item='$item' expires_on='$expiresOn'")
            continue
        }

        if ($parsedDate.Date -lt $Today.Date) {
            $expired.Add("section='$section' item='$item' column='$column' expires_on='$expiresOn'")
        }

        $key = Build-AllowKey -Section $section -Item $item -Column $column
        if ($result.Map.ContainsKey($key)) {
            $validationErrors.Add("duplicate allowlist key: section='$section' item='$item' column='$column'")
            continue
        }

        $result.Map[$key] = [PSCustomObject]@{
            section = $section
            item = $item
            column = $column
            expires_on = $expiresOn
            owner = $owner
            reason = $reason
        }
    }

    if ($validationErrors.Count -gt 0) {
        Write-Host '[FAIL] allowlist validation errors:' -ForegroundColor Red
        foreach ($e in $validationErrors) {
            Write-Host " - $e" -ForegroundColor Red
        }
        exit 1
    }

    if ($expired.Count -gt 0) {
        Write-Host '[FAIL] allowlist contains expired exceptions:' -ForegroundColor Red
        foreach ($e in $expired) {
            Write-Host " - $e" -ForegroundColor Red
        }
        exit 1
    }

    $result.Count = $result.Map.Count
    return $result
}

function Parse-MatrixPsrt {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        Write-Host "[FAIL] matrix file not found: $Path" -ForegroundColor Red
        exit 1
    }

    $lines = Get-Content $Path
    $entries = New-Object System.Collections.Generic.List[object]

    $currentSection = 'UNSCOPED'
    $pendingHeader = $null
    $pendingHeaderLine = 0
    $tableHeaderCells = $null
    $tableColumnMap = $null
    $inTable = $false

    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        $trim = $line.Trim()
        $lineNo = $i + 1

        if ($trim -match '^##+\s+(.+)$') {
            $currentSection = Normalize-CellText $Matches[1]
            if ($inTable) {
                $inTable = $false
                $tableHeaderCells = $null
                $tableColumnMap = $null
            }
            $pendingHeader = $null
            continue
        }

        if ($trim -notmatch '^\|') {
            if ($inTable) {
                $inTable = $false
                $tableHeaderCells = $null
                $tableColumnMap = $null
            }
            $pendingHeader = $null
            continue
        }

        $cells = Split-MarkdownRow $line
        if ($cells.Count -eq 0) {
            $pendingHeader = $null
            continue
        }

        if ($inTable) {
            if (Is-MarkdownSeparatorRow $cells) {
                continue
            }

            if ($cells.Count -lt $tableHeaderCells.Count) {
                continue
            }

            $item = Normalize-CellText $cells[0]
            if ($item -eq '' -or $item -eq '---') {
                continue
            }

            foreach ($col in @('P', 'S', 'R', 'T')) {
                if (-not $tableColumnMap.ContainsKey($col)) {
                    continue
                }

                $colIndex = [int]$tableColumnMap[$col]
                if ($colIndex -ge $cells.Count) {
                    continue
                }

                $status = (Normalize-CellText $cells[$colIndex]).ToUpperInvariant()
                if ($status -eq '') {
                    continue
                }

                $entries.Add([PSCustomObject]@{
                        section = $currentSection
                        item = $item
                        column = $col
                        status = $status
                        line = $lineNo
                    })
            }

            continue
        }

        if ($null -eq $pendingHeader) {
            $pendingHeader = $cells
            $pendingHeaderLine = $lineNo
            continue
        }

        if (-not (Is-MarkdownSeparatorRow $cells)) {
            $pendingHeader = $cells
            $pendingHeaderLine = $lineNo
            continue
        }

        $columnMap = @{}
        for ($c = 0; $c -lt $pendingHeader.Count; $c++) {
            $header = (Normalize-CellText $pendingHeader[$c]).ToUpperInvariant()
            if ($header -in @('P', 'S', 'R', 'T')) {
                $columnMap[$header] = $c
            }
        }

        if ($columnMap.Count -eq 0) {
            $pendingHeader = $null
            continue
        }

        $tableHeaderCells = $pendingHeader
        $tableColumnMap = $columnMap
        $inTable = $true
        $pendingHeader = $null
    }

    return $entries
}

$resolvedMatrixPath = Resolve-RepoPath $MatrixPath
$resolvedAllowListPath = Resolve-RepoPath $AllowListPath
$today = Get-Date

$allowList = Parse-AllowList -Path $resolvedAllowListPath -Today $today
$entries = Parse-MatrixPsrt -Path $resolvedMatrixPath

if ($entries.Count -eq 0) {
    Write-Host '[FAIL] no P/S/R/T status entries parsed from matrix' -ForegroundColor Red
    exit 1
}

$statusCounts = @{}
$sectionCounts = @{}
$nonOkEntries = New-Object System.Collections.Generic.List[object]
$allowedNonOkEntries = New-Object System.Collections.Generic.List[object]

foreach ($entry in $entries) {
    if (-not $statusCounts.ContainsKey($entry.status)) {
        $statusCounts[$entry.status] = 0
    }
    $statusCounts[$entry.status] = [int]$statusCounts[$entry.status] + 1

    if (-not $sectionCounts.ContainsKey($entry.section)) {
        $sectionCounts[$entry.section] = [PSCustomObject]@{
            total = 0
            non_ok = 0
            allowed = 0
        }
    }

    $sectionInfo = $sectionCounts[$entry.section]
    $sectionInfo.total = [int]$sectionInfo.total + 1

    if ($entry.status -ne 'OK') {
        $key = Build-AllowKey -Section $entry.section -Item $entry.item -Column $entry.column
        if ($allowList.Map.ContainsKey($key)) {
            $sectionInfo.allowed = [int]$sectionInfo.allowed + 1
            $allowedNonOkEntries.Add($entry)
        } else {
            $sectionInfo.non_ok = [int]$sectionInfo.non_ok + 1
            $nonOkEntries.Add($entry)
        }
    }
}

Write-Host "MATRIX: $resolvedMatrixPath"
Write-Host "STRICT: $($Strict.IsPresent)"
Write-Host "ALLOWLIST: $([string]::IsNullOrWhiteSpace($resolvedAllowListPath) -eq $false) entries=$($allowList.Count)"
Write-Host ''

Write-Host 'STATUS COUNTS (P/S/R/T):'
foreach ($name in ($statusCounts.Keys | Sort-Object)) {
    Write-Host (" - {0}: {1}" -f $name, $statusCounts[$name])
}
Write-Host ''

Write-Host 'SECTION COUNTS (non_ok / allowed_non_ok / total):'
foreach ($sec in ($sectionCounts.Keys | Sort-Object)) {
    $info = $sectionCounts[$sec]
    Write-Host (" - {0}: {1} / {2} / {3}" -f $sec, $info.non_ok, $info.allowed, $info.total)
}
Write-Host ''

$unresolvedCount = $nonOkEntries.Count
$allowedCount = $allowedNonOkEntries.Count

Write-Host ("UNRESOLVED NON-OK (not allowlisted): {0}" -f $unresolvedCount)
Write-Host ("ALLOWLISTED NON-OK: {0}" -f $allowedCount)

if ($Strict -and $unresolvedCount -gt 0) {
    Write-Host '[FAIL] strict mode: unresolved P/S/R/T statuses remain.' -ForegroundColor Red
    $preview = $nonOkEntries | Select-Object -First 20
    foreach ($row in $preview) {
        Write-Host (" - {0} | {1} | {2}={3} (line {4})" -f $row.section, $row.item, $row.column, $row.status, $row.line)
    }

    if ($nonOkEntries.Count -gt $preview.Count) {
        Write-Host (" - ... and {0} more" -f ($nonOkEntries.Count - $preview.Count))
    }

    exit 1
}

if (-not $Strict -and $unresolvedCount -gt 0) {
    Write-Host '[WARN] unresolved P/S/R/T statuses remain (strict mode disabled).' -ForegroundColor Yellow
}

Write-Host '[PASS] matrix PSRT validation completed.' -ForegroundColor Green
exit 0

# README NOTE (allowlist sample row)
# section,item,column,expires_on,owner,reason
# 2) Komut Matrisi (Statement),EXIT IF,P,2026-12-31,team-owner,temporary gap accepted until runtime alignment
