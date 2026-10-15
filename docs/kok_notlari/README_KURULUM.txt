Mete abi - build_64 pathfix kurulumu

1) Bu zip'i su klasore ac:
   UXBc_Clean\UXBc\uxb\

2) Uzerine yazmaya izin ver:
   build_64.bat
   build_64.ps1
   tools\build\diagnose_build64_paths.py
   uxb\compiler\wrappers\uxb_main_wrapper.bas

3) Kontrol et:
   python tools\build\diagnose_build64_paths.py

4) Derle:
   .\build_64.bat 2>&1 | Tee-Object -FilePath .\build_64_error.log

Not:
Bu yama ilk hatayi cozer: eski wrapper yolu yerine src\main.bas derlenir.
Derleme sonra baska kaynak kod hatasina duserse yeni logu gonder, oradan devam ederiz.
