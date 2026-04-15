param(
    [ValidateSet("testdisk", "photorec", "qphotorec", "recuva", "wise")]
    [string]$Tool = "qphotorec"
)

$paths = @{
    testdisk = "C:/Users/mete/AppData/Local/Microsoft/WinGet/Packages/CGSecurity.TestDisk_Microsoft.Winget.Source_8wekyb3d8bbwe/testdisk-7.3-WIP/testdisk_win.exe"
    photorec = "C:/Users/mete/AppData/Local/Microsoft/WinGet/Packages/CGSecurity.TestDisk_Microsoft.Winget.Source_8wekyb3d8bbwe/testdisk-7.3-WIP/photorec_win.exe"
    qphotorec = "C:/Users/mete/AppData/Local/Microsoft/WinGet/Packages/CGSecurity.TestDisk_Microsoft.Winget.Source_8wekyb3d8bbwe/testdisk-7.3-WIP/qphotorec_win.exe"
    recuva = "C:/Program Files/Recuva/recuva.exe"
    wise = "C:/Program Files (x86)/Wise/Wise Data Recovery/WiseDataRecovery.exe"
}

$target = $paths[$Tool]
if (-not (Test-Path $target)) {
    throw "Tool executable not found: $target"
}

Start-Process -FilePath $target
Write-Host "[DONE] Started $Tool"
