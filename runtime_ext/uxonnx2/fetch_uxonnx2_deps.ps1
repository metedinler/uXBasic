param(
  [string]$Version = "1.18.1"
)
$ErrorActionPreference = "Stop"
$root = Resolve-Path "$PSScriptRoot\..\..\.."
$dep = Join-Path $root "uxb\dist\runtime_ext\deps\uxonnx2"
$tmp = Join-Path $dep "download"
New-Item -ItemType Directory -Force -Path $dep,$tmp | Out-Null
$zipName = "onnxruntime-win-x64-$Version.zip"
$url = "https://github.com/microsoft/onnxruntime/releases/download/v$Version/$zipName"
$zipPath = Join-Path $tmp $zipName
$headerPath = Join-Path $dep "include\onnxruntime_c_api.h"
$dllPath = Join-Path $dep "onnxruntime.dll"
$libPath = Join-Path $dep "onnxruntime.lib"
$registryPath = Join-Path $dep "uxonnx2_dependency_registry.json"
if ((Test-Path $headerPath) -and (Test-Path $dllPath) -and (Test-Path $libPath) -and (Test-Path $registryPath)) {
  $installed = Get-Content -Raw $registryPath | ConvertFrom-Json
  if ($installed.version -eq $Version) {
    Write-Host "OK: ONNX Runtime $Version is already installed at $dep"
    exit 0
  }
}
Write-Host "Downloading $url"
Invoke-WebRequest -Uri $url -OutFile $zipPath
Expand-Archive -Path $zipPath -DestinationPath $tmp -Force
$pkg = Join-Path $tmp "onnxruntime-win-x64-$Version"
New-Item -ItemType Directory -Force -Path (Join-Path $dep "include") | Out-Null
Copy-Item (Join-Path $pkg "include\*.h") (Join-Path $dep "include") -Force
Copy-Item (Join-Path $pkg "lib\onnxruntime.dll") $dep -Force
if (Test-Path (Join-Path $pkg "lib\onnxruntime.lib")) { Copy-Item (Join-Path $pkg "lib\onnxruntime.lib") $dep -Force }
$reg = [ordered]@{
  module="uxonnx2"; dependency="ONNX Runtime"; version=$Version; source=$url; dll=(Join-Path $dep "onnxruntime.dll"); include=(Join-Path $dep "include"); provider="CPU default; DirectML/CUDA if symbols/runtime available"
}
$reg | ConvertTo-Json -Depth 4 | Set-Content -Encoding UTF8 (Join-Path $dep "uxonnx2_dependency_registry.json")
"module,dependency,version,source,dll,include,provider" | Set-Content -Encoding UTF8 (Join-Path $dep "uxonnx2_dependency_registry.csv")
"uxonnx2,ONNX Runtime,$Version,$url,$($reg.dll),$($reg.include),$($reg.provider)" | Add-Content -Encoding UTF8 (Join-Path $dep "uxonnx2_dependency_registry.csv")
Write-Host "OK: $dep"
