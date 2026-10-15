Mete abi - uXBasic compilefix2

1) Zip'i UXBc_Clean\UXBc ust dizinine ac.
2) apply_compilefix2.bat calistir.
3) Ust dizinden dene:
   .\build_64_fixed.bat 2>&1 | Tee-Object -FilePath .\build_64_error.log

Bu paket build_64.bat'i ezmez; build_64_fixed.bat olusturur.
