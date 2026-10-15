UXB_X64_BUILD_GOTO_SAFE_FIX_20260712

Bu yama, bir önceki X64_FFI_RESOLVER_RELEASE yamasının x64_build_pipeline.fbs içinde oluşturduğu FreeBASIC derleme hatasını düzeltir.

Hata:
  error 105: Branch crossing local array, var-len string or object definition, to label: X64BUILDRUNARTIFACTSCLEANUP

Kök sebep:
  X64BuildRunArtifacts içinde GoTo cleanup label'ına atlayan satırdan sonra iki adet local String tanımlanmıştı:
    buildStdoutPath
    buildStderrPath
  FreeBASIC, Goto'nun var-len String tanımını çaprazlamasına izin vermez.

Düzeltme:
  buildStdoutPath ve buildStderrPath Dim tanımları ilk GoTo'dan önceye taşındı.

Değişen dosya:
  src/build/x64_build_pipeline.fbs
