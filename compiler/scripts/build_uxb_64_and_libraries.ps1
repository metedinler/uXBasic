param(
    [ValidateSet("minimal","core","all")][string]$Set = "core",
    [switch]$FetchDeps,
    [switch]$StrictAll
)
$ErrorActionPreference = "Stop"
& "$PSScriptRoot\build_libraries.ps1" -Set $Set -FetchDeps:$FetchDeps -StrictAll:$StrictAll -StrictRuntime -BuildCompiler
exit $LASTEXITCODE
