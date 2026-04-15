[CmdletBinding()]
param(
    [string]$InputPath = "reports/uxbasic_operasyonel_eksiklik_matrisi.md",
    [string]$OutputCsv = "reports/matrix_psrt_nonok_inventory.csv",
    [switch]$Summary
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$RepoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))

function Resolve-RepoPath {
    param([Parameter(Mandatory = $true)][string]$Path)
    if ([System.IO.Path]::IsPathRooted($Path)) {
        return $Path
    }
    return [System.IO.Path]::GetFullPath((Join-Path $RepoRoot $Path))
}

function Normalize-Token {
    param([string]$Text)
    if ($null -eq $Text) {
        return ""
    }
    $t = $Text.Trim().ToUpperInvariant()
    $t = $t -replace "\s+", ""
    return ($t -replace "[^A-Z0-9/_]", "")
}

function Split-MarkdownRow {
    param([string]$Line)
    $trimmed = $Line.Trim()
    if (-not $trimmed.StartsWith("|")) {
        return @()
    }
    $parts = $trimmed.Split("|")
    if ($parts.Count -lt 3) {
        return @()
    }

    $cells = New-Object System.Collections.Generic.List[string]
    for ($i = 1; $i -lt ($parts.Count - 1); $i++) {
        $cells.Add($parts[$i].Trim())
    }
    return ,$cells.ToArray()
}

function Test-SeparatorRow {
    param([string[]]$Cells)
    if ($Cells.Count -eq 0) {
        return $false
    }
    foreach ($cell in $Cells) {
        if ($cell -notmatch "^\s*:?-{3,}:?\s*$") {
            return $false
        }
    }
    return $true
}

function Get-SectionFamily {
    param([string]$HeadingLine)
    $h = $HeadingLine.ToUpperInvariant()

    if ($h -match "##\s*2\).*KOMUT MATRISI") { return "command matrix" }
    if ($h -match "##\s*3\).*FONKSIYON MATRISI") { return "intrinsic matrix" }
    if ($h -match "##\s*4\).*OPERATOR MATRISI") { return "operator matrix" }
    if ($h -match "##\s*5\).*VERI TIPLERI VE VERI YAPILARI MATRISI") { return "data structures" }
    if ($h -match "##\s*8\).*PROGRAM YAPISI ANAHTAR KELIME MATRISI") { return "program structure keywords" }
    if ($h -match "##\s*9\).*DERLEYICI META-KOMUT MATRISI") { return "meta command table" }
    if ($h -match "##\s*10\).*CLASS OOP OZELLIK MATRISI") { return "oop table" }

    return $null
}

function Get-HeaderMap {
    param([string[]]$Cells)

    $norm = @()
    foreach ($cell in $Cells) {
        $norm += (Normalize-Token -Text $cell)
    }

    $map = [ordered]@{
        item   = -1
        p      = -1
        s      = -1
        r      = -1
        t      = -1
        target = -1
        note   = -1
    }

    $itemHeaders = @(
        "KOMUT",
        "FONKSIYON",
        "OPERATORGRUBU",
        "TIP/YAPI",
        "TIPYAPI",
        "YAPI",
        "METAKOMUT",
        "OOPOZELLIGI"
    )

    for ($i = 0; $i -lt $norm.Count; $i++) {
        $token = $norm[$i]
        switch ($token) {
            "P" { $map.p = $i; continue }
            "S" { $map.s = $i; continue }
            "R" { $map.r = $i; continue }
            "T" { $map.t = $i; continue }
            "NOT" { $map.note = $i; continue }
            "HEDEFFAZ" { $map.target = $i; continue }
        }

        if ($map.item -lt 0 -and $itemHeaders -contains $token) {
            $map.item = $i
        }
    }

    if ($map.item -lt 0 -or $map.p -lt 0 -or $map.r -lt 0) {
        return $null
    }

    return $map
}

function Get-Cell {
    param(
        [string[]]$Cells,
        [int]$Index
    )
    if ($Index -lt 0 -or $Index -ge $Cells.Count) {
        return ""
    }
    return $Cells[$Index].Trim()
}

function Normalize-Status {
    param([string]$Value)
    if ([string]::IsNullOrWhiteSpace($Value)) {
        return ""
    }
    return $Value.Trim().ToUpperInvariant()
}

function Get-Severity {
    param([string[]]$Statuses)
    if ($Statuses -contains "YOK") { return "critical" }
    if ($Statuses -contains "PLAN") { return "high" }
    if ($Statuses -contains "KISMEN") { return "medium" }
    return "info"
}

function Get-TrackedStatus {
    param([string]$Status)
    switch ($Status) {
        "YOK" { return "YOK" }
        "PLAN" { return "PLAN" }
        "KISMEN" { return "KISMEN" }
        default { return "" }
    }
}

$inputFullPath = Resolve-RepoPath -Path $InputPath
$outputFullPath = Resolve-RepoPath -Path $OutputCsv

if (-not (Test-Path -LiteralPath $inputFullPath)) {
    throw "Input markdown not found: $inputFullPath"
}

$lines = Get-Content -LiteralPath $inputFullPath -Encoding UTF8

$rows = New-Object System.Collections.Generic.List[object]
$summarySeed = New-Object System.Collections.Generic.List[object]

$currentSection = $null
$headerMap = $null
$inTable = $false

foreach ($line in $lines) {
    if ($line -match "^\s*##\s+") {
        $currentSection = Get-SectionFamily -HeadingLine $line
        $headerMap = $null
        $inTable = $false
        continue
    }

    if (-not $currentSection) {
        continue
    }

    if ($line -notmatch "^\s*\|") {
        if ($inTable) {
            $headerMap = $null
            $inTable = $false
        }
        continue
    }

    $cells = Split-MarkdownRow -Line $line
    if ($cells.Count -eq 0) {
        continue
    }
    if (Test-SeparatorRow -Cells $cells) {
        continue
    }

    if ($null -eq $headerMap) {
        $candidate = Get-HeaderMap -Cells $cells
        if ($null -ne $candidate) {
            $headerMap = $candidate
            $inTable = $true
        }
        continue
    }

    $item = Get-Cell -Cells $cells -Index $headerMap.item
    if ([string]::IsNullOrWhiteSpace($item)) {
        continue
    }

    $p = Normalize-Status -Value (Get-Cell -Cells $cells -Index $headerMap.p)
    $s = ""
    if ($headerMap.s -ge 0) {
        $s = Normalize-Status -Value (Get-Cell -Cells $cells -Index $headerMap.s)
    }
    $r = Normalize-Status -Value (Get-Cell -Cells $cells -Index $headerMap.r)
    $t = ""
    if ($headerMap.t -ge 0) {
        $t = Normalize-Status -Value (Get-Cell -Cells $cells -Index $headerMap.t)
    }

    $targetFaz = Get-Cell -Cells $cells -Index $headerMap.target
    $note = Get-Cell -Cells $cells -Index $headerMap.note

    $statusCells = @($p, $s, $r, $t)
    $nonOkStatuses = @()
    foreach ($status in $statusCells) {
        $tracked = Get-TrackedStatus -Status $status
        if (-not [string]::IsNullOrWhiteSpace($tracked)) {
            $nonOkStatuses += $tracked
        }
    }

    if ($nonOkStatuses.Count -eq 0) {
        continue
    }

    $rows.Add([pscustomobject]@{
        section    = $currentSection
        item       = $item
        p          = $p
        s          = $s
        r          = $r
        t          = $t
        target_faz = $targetFaz
        note       = $note
        severity   = (Get-Severity -Statuses $nonOkStatuses)
    })

    foreach ($status in $nonOkStatuses) {
        $summarySeed.Add([pscustomobject]@{
            section = $currentSection
            status  = $status
        })
    }
}

$outputDir = Split-Path -Parent $outputFullPath
if (-not [string]::IsNullOrWhiteSpace($outputDir) -and -not (Test-Path -LiteralPath $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

$rows |
    Sort-Object section, item |
    Export-Csv -LiteralPath $outputFullPath -NoTypeInformation -Encoding UTF8

Write-Host ("Wrote " + $rows.Count + " rows to " + $outputFullPath)

if ($Summary) {
    if ($summarySeed.Count -eq 0) {
        Write-Host "No non-OK statuses found."
    }
    else {
        $summaryRows = $summarySeed |
            Group-Object section, status |
            ForEach-Object {
                [pscustomobject]@{
                    section = $_.Group[0].section
                    status  = $_.Group[0].status
                    count   = $_.Count
                }
            } |
            Sort-Object section, status

        $summaryRows | Format-Table -AutoSize
    }
}