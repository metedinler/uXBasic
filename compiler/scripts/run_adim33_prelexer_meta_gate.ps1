param([switch]$NoRepair)
$ErrorActionPreference = 'Stop'
function Find-UxbRoot {
    $p = (Get-Location).Path
    while ($true) {
        if ((Test-Path (Join-Path $p 'src\main.bas')) -and (Test-Path (Join-Path $p 'compiler\scripts'))) { return $p }
        $parent = Split-Path $p -Parent
        if ($parent -eq $p) { throw 'uXBasic root not found' }
        $p = $parent
    }
}
$root = Find-UxbRoot
Set-Location $root
$current = 'reports\control\current'
New-Item -ItemType Directory -Force -Path $current | Out-Null
$gate = [ordered]@{ step='ADIM33_PRELEXER_META'; ok=$true; missing=@(); notes=@() }
$required = @(
 'src\preprocessor\preprocess_meta_model.fbs',
 'src\parser\lexer\lexer_preprocess.fbs',
 'src\parser\lexer.fbs'
)
foreach($r in $required){ if(!(Test-Path $r)){ $gate.ok=$false; $gate.missing += $r } }
$src = Get-Content 'src\parser\lexer\lexer_preprocess.fbs' -Raw -ErrorAction SilentlyContinue
foreach($pat in @('Type PreprocessResult','Type MetaBlock','Type MetaAsset','Type MetaWatImport','LexerPreprocessSourceEx')){
    if($src -notmatch [regex]::Escape($pat)){ $gate.ok=$false; $gate.notes += "missing pattern in lexer_preprocess: $pat" }
}
foreach($cmd in @('ALIAS','FOR','FOREACH','TARGET','OUTDIR','JS_BEGIN','WAT_IMPORT','HTML_BEGIN','CSS_BEGIN','JSON_BEGIN','ASSET_COPY','MANIFEST_SET','ASSERT_META','WARN_META')){
    if($src -notmatch ('"' + [regex]::Escape($cmd) + '"')){ $gate.notes += "directive not visibly dispatched: %%$cmd" }
}
$gate | ConvertTo-Json -Depth 6 | Set-Content -Encoding UTF8 (Join-Path $current 'adim33_prelexer_meta_gate.json')
if($gate.ok){ exit 0 } else { exit 1 }
