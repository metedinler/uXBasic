# ADIM04 Terminal Emirleri

Repo kökü:

```powershell
Set-Location "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb"
```

## 1. Current raporlarını history altına taşı

```powershell
$step = "04_ast_contract_child_model"
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$current = "reports/control/current"
$history = "reports/control/history/${step}_$stamp"
New-Item -ItemType Directory -Force "reports/control/history" | Out-Null
if (Test-Path $current) {
  $items = Get-ChildItem $current -Force -ErrorAction SilentlyContinue
  if ($items) {
    New-Item -ItemType Directory -Force $history | Out-Null
    Move-Item "$current\*" $history -Force
  }
}
New-Item -ItemType Directory -Force $current | Out-Null
Write-Output "CURRENT_ARCHIVED_TO=$history"
```

## 2. Mevcut AST contract araçlarını çalıştır

```powershell
cmd /c compiler\scripts\run_step2_ast_contract_gate.bat
if ($LASTEXITCODE -ne 0) { Write-Error "Mevcut AST contract gate FAIL"; exit 1 }
```

## 3. Derle

```powershell
cmd /c compiler\scripts\build_uxb_main_64.bat
if ($LASTEXITCODE -ne 0) { Write-Error "FreeBASIC derleme FAIL"; exit 1 }
```

## 4. Pozitif testleri çalıştır

```powershell
$exe = "build\uxb_main_64.exe"
if (!(Test-Path $exe)) { $exe = "compiler\wrappers\uxb_main_64.exe" }
if (!(Test-Path $exe)) { Write-Error "uxb_main_64.exe bulunamadi"; exit 1 }

$tests = @(
  "tests\adim04\positive\adim04_binary_expr.bas",
  "tests\adim04\positive\adim04_if_call.bas",
  "tests\adim04\positive\adim04_class.bas"
)

foreach ($t in $tests) {
  $name = [IO.Path]::GetFileNameWithoutExtension($t)
  & $exe $t --ast-contract-check --ast-contract-json-out "reports/control/current/$name.ast_contract.json"
  if ($LASTEXITCODE -ne 0) { Write-Error "ADIM04 pozitif test FAIL: $t"; exit 1 }
}
```

## 5. Negatif harness derle ve çalıştır

```powershell
$fbc = "tools\FreeBASIC-1.10.1-win64\fbc.exe"
if (!(Test-Path $fbc)) { Write-Error "fbc bulunamadi: $fbc"; exit 1 }

& $fbc "tests\adim04\negative_harness\adim04_ast_contract_negative_harness.bas" -x "reports\control\current\adim04_ast_contract_negative_harness.exe"
if ($LASTEXITCODE -ne 0) { Write-Error "negative harness derleme FAIL"; exit 1 }

& "reports\control\current\adim04_ast_contract_negative_harness.exe"
if ($LASTEXITCODE -ne 0) { Write-Error "negative harness beklenen PASS sonucunu vermedi"; exit 1 }
```

## 6. Çıktıları kontrol et

```powershell
Get-ChildItem reports/control/current | Select-Object Name,Length
Get-Content reports/control/current/adim04_gate.json -TotalCount 80
Get-Content reports/control/current/adim04_gate.md -TotalCount 80
```

## Olası hatalar

- `UXBAstAdim04ValidateTree` bulunamadı: `ast_contract.fbs` include eklemesi eksik.
- `ASTK_MODE_REF` bulunamadı: `ast_node_kinds.fbs` içindeki sabit adı repo sürümünde farklıdır; child model dosyasında ilgili leaf case'i kaldır.
- Pozitif IF/CALL testi fail: Parser rol atamıyor olabilir; 08 parser patch role child üretimine bağlanmalı.
- Negative harness yanlışlıkla fail: harness bozuk AST üretmeli ve gate bunu yakalamalı; test kodundaki beklenen yön ters çevrilmiş olabilir.
