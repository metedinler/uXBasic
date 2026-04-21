Set-Location "c:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo"
$matrixPath = 'reports/uxbasic_operasyonel_eksiklik_matrisi.md'
$rows = @()
Get-Content $matrixPath | ForEach-Object {
  if ($_ -match '^\| (?<feature>.+?) \| (?<D>OK|KISMEN|YOK|PLAN) \| (?<P>OK|KISMEN|YOK|PLAN) \| (?<S>OK|KISMEN|YOK|PLAN) \| (?<R>OK|KISMEN|YOK|PLAN|N/A) \| (?<T>OK|KISMEN|YOK|PLAN) \| (?<note>.*?) \| (?<phase>.*?) \|$') {
    $rows += [pscustomobject]@{
      feature = $Matches.feature.Trim()
      D = $Matches.D; P = $Matches.P; S = $Matches.S; R = $Matches.R; T = $Matches.T
      note = $Matches.note.Trim(); phase = $Matches.phase.Trim()
    }
  }
}

function Get-Tokens([string]$feature) {
  $f = $feature.ToUpperInvariant()
  $f = $f -replace '[^A-Z0-9_]', ' '
  $parts = $f -split '\s+' | Where-Object { $_ -and $_.Length -ge 2 -and $_ -notmatch '^[0-9]+$' }
  $stop = @('END','ELSE','CASE','IS','AND','OR','NOT','THE','WITH','MODEL','RUNTIME','PARSER','SEMANTIC','FUNCTION','FONKSIYON','KOMUT')
  $parts = $parts | Where-Object { $stop -notcontains $_ }
  $parts | Select-Object -Unique
}

function Get-FeatureProbePatterns([string]$feature) {
  $f = $feature.ToUpperInvariant().Trim()

  switch -Regex ($f) {
    '^IF\s*/\s*ELSEIF' { return @('IF_STMT|ELSEIF_PART|ParseIfStmt|\bIF\b') }
    '^CASE\s+IS$' { return @('CASE_IS_VALUE|ParseCaseIsRelOp|\bCASE\s+IS\b') }
    '^END$' { return @('END_STMT|ParseEndStmt|ExecRun.*END') }
    '^DIM$' { return @('DIM_STMT|DIM_DECL|ParseDimStmt|ParseDimDeclarator') }
    '^SIZEOF$' { return @('\bSIZEOF\b|ValidateSizeOfCall|ExecBuiltinArgAsTypeName') }
    '^MID$' { return @('\bMID\b|ValidateArgCountInRange') }
    '^MAIN\s*\.\.\.\s*END\s*MAIN$' { return @('MAIN_STMT|ParseMainStmt|\bEND\s+MAIN\b') }
    '^%%IFC$' { return @('%%IFC|\bIFC\b|preprocess_ifc') }
    '^PUBLIC/PRIVATE' { return @('\bPUBLIC\b|\bPRIVATE\b|CLASS_ACCESS') }
    '^INHERITANCE$' { return @('\bEXTENDS\b|CLASS_BASE_REF|inheritance') }
    '^VTABLE/POLYMORPHISM$' { return @('\bVIRTUAL\b|\bOVERRIDE\b|dispatch') }
    '^INTERFACE$' { return @('\bINTERFACE\b|\bIMPLEMENTS\b|INTERFACE_STMT') }
    default { return @() }
  }
}

$report = @()
foreach ($r in $rows) {
  $tests = [regex]::Matches($r.note, 'tests/[A-Za-z0-9_./-]+') | ForEach-Object { $_.Value } | Select-Object -Unique
  $missingTests = @()
  foreach ($t in $tests) {
    $p = $t -replace '/', '\\'
    if (-not (Test-Path $p)) { $missingTests += $t }
  }

  $tokens = Get-Tokens $r.feature
  $probePatterns = Get-FeatureProbePatterns $r.feature
  $srcHit = 0
  $srcHitToken = ''

  if ($probePatterns.Count -gt 0) {
    foreach ($pp in $probePatterns) {
      $out = rg -n --no-heading -m 1 -i "$pp" src tests 2>$null
      if ($LASTEXITCODE -eq 0 -and $out) { $srcHit = 1; $srcHitToken = $pp; break }
    }
  }

  if ($srcHit -eq 0 -and $tokens.Count -gt 0) {
    foreach ($tk in $tokens) {
      $out = rg -n --no-heading -m 1 -i "\b$tk\b" src tests 2>$null
      if ($LASTEXITCODE -eq 0 -and $out) { $srcHit = 1; $srcHitToken = $tk; break }
    }
  }

  $allOk = ($r.D -eq 'OK' -and $r.P -eq 'OK' -and $r.S -eq 'OK' -and ($r.R -eq 'OK' -or $r.R -eq 'N/A') -and $r.T -eq 'OK')
  $status = 'TUTARLI'
  if ($allOk -and $srcHit -eq 0 -and $tests.Count -eq 0) { $status = 'SUPHELI_OK_KOD_VE_TEST_IZI_YOK' }
  elseif ($allOk -and $srcHit -eq 0 -and $tests.Count -gt 0) { $status = 'SUPHELI_OK_KOD_IZI_ZAYIF' }
  elseif ($missingTests.Count -gt 0) { $status = 'TEST_REFERANSI_EKSIK_DOSYA' }

  $report += [pscustomobject]@{
    feature = $r.feature
    D = $r.D; P = $r.P; S = $r.S; R = $r.R; T = $r.T
    tests_ref_count = $tests.Count
    tests_missing_count = $missingTests.Count
    src_token_hit = $srcHit
    src_token = $srcHitToken
    status = $status
    phase = $r.phase
  }
}

$csvPath = 'reports/forensic_matrix_full_scan_2026-04-20.csv'
$report | Export-Csv -NoTypeInformation -Encoding UTF8 $csvPath

$summaryPath = 'reports/forensic_matrix_full_scan_2026-04-20_summary.txt'
$total = $report.Count
$susp = ($report | Where-Object { $_.status -like 'SUPHELI*' }).Count
$miss = ($report | Where-Object { $_.status -eq 'TEST_REFERANSI_EKSIK_DOSYA' }).Count
$topSusp = $report | Where-Object { $_.status -like 'SUPHELI*' } | Select-Object -First 25

"TOPLAM=$total" | Set-Content -Encoding utf8 $summaryPath
"SUPHELI=$susp" | Add-Content -Encoding utf8 $summaryPath
"EKSIK_TEST_DOSYASI=$miss" | Add-Content -Encoding utf8 $summaryPath
"--- EN_SUPHELI_KAYITLAR ---" | Add-Content -Encoding utf8 $summaryPath
$topSusp | ForEach-Object { "{0} | {1} | src_hit={2} | tests={3}" -f $_.feature, $_.status, $_.src_token_hit, $_.tests_ref_count } | Add-Content -Encoding utf8 $summaryPath

Write-Output "TOPLAM=$total"
Write-Output "SUPHELI=$susp"
Write-Output "EKSIK_TEST_DOSYASI=$miss"
Write-Output "CSV=$csvPath"
Write-Output "SUMMARY=$summaryPath"
