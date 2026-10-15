UXB_005_TP02_ERR_FIX

Amaç:
- tp_02 x64 codegen hatasının boş hata metniyle kaybolmasını engeller.
- Başarısız AST düğümünün index/kind/op/line/column bilgisini raporlar.
- ABI10 veya ADIM25 politikasını değiştirmez.
- UXB_004 operatör semantiğini geri almaz.

Beklenen:
Release pipeline --only tp_02 çalıştırıldığında UXB_X64_AST_EMIT_FAILED artık boş olmayacaktır.
