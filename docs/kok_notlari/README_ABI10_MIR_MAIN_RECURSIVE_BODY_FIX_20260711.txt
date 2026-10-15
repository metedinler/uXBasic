UXB ABI10 MIR MAIN recursive body fix + debug collector ask rebuild

Bu paket iki şeyi değiştirir:

1) src/semantic/mir_tail.fbs
   MAIN_STMT içindeki yürütülebilir gövdeyi sadece direct child olarak değil,
   BLOCK/BODY/STMT_LIST gibi container düğümlerinin içinden recursive olarak indirir.
   Ama SUB/FUNCTION/DECLARE/CLASS gibi program gövdesi dışında ayrı pass ile işlenen
   deklarasyonları MAIN içine karıştırmaz.

2) Collect_UXB_Debug.ps1
   -RunBuildAndTests verildiğinde bin\uxb.exe zaten varsa yeniden compiler üretimini sorar.
   Otomatik cevap için:
     -RebuildCompiler Yes
     -RebuildCompiler No
   kullanılabilir.
   Ayrıca ABI10 MIR teşhisi için ast/semantic_mir/canonical_mir/mir_exec/runtime_trace JSON çıktıları üretmeye çalışır.

Uygulama:
  Expand-Archive -LiteralPath .\UXB_ABI10_MIR_MAIN_RECURSIVE_BODY_FIX_20260711_DIRECT_ROOT.zip -DestinationPath . -Force
