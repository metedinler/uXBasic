# Copilot Workspace Instructions

## Test Naming Policy (Mandatory)

Tum yeni testler ve test referanslari asagidaki standarda uymak zorundadir:
- Dokuman: `tests/TEST_NAMING_STANDARD.md`
- Dogrulama: `tools/validate_test_naming.ps1`

Kurallar:
- `tests/manifest.csv` icinde sadece `TST-...-NNN` formati kullanilir (buyuk harf/rakam/tire + 3 haneli sira).
- `tests/plan/command_compatibility_win11.csv` icindeki `test_ref` alanlari manifestte var olan test ID'lerine baglanir.
- Yeni test yazildiginda veya test_ ref degistiginde naming validator calistirilir.

## Agent/Subagent Rule

Bu workspace icinde calisan tum ajanlar (ana ajan + alt ajanlar):
- yeni test adlandirmasinda bu standardi kullanir,
- eski/legacy test ID uretmez,
- test naming validator basarisizsa degisikligi tamamlanmis saymaz.
