# Agent Coordination Rules

## Shared Test Naming Contract

Tum ajanlar su dosyayi normatif kaynak kabul eder:
- `tests/TEST_NAMING_STANDARD.md`

Uygulama zorunlulugu:
- Manifest test ID'leri standart format disina cikamaz.
- Compatibility test_ref degerleri manifest test ID'leri ile bagli olmalidir.
- Her test-related degisiklikten sonra `tools/validate_test_naming.ps1` calistirilir.

## Enforcement

Ajanlar naming standardina uymayan degisiklikleri bitmis kabul etmez.
