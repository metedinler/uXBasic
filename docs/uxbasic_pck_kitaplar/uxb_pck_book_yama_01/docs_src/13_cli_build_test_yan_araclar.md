# CLI, Build, Test ve Yan Araçlar

uXBasic kitabı yalnız dil sözdizimini anlatmaz; programcının dili nasıl doğrulayacağını da gösterir. Bir komutu öğrenmek kadar, onu test etmek ve raporunu okumak da önemlidir.

## Derleme

```powershell
.\build_64.bat
```

Bu komut uXBasic derleyicisini üretir. Başarılı sonuçta `bin\uxb.exe` oluşur.

## Project pack testleri

```powershell
python xtestx\_runners\run_xtestx_project_packs.py --root . --tests xtestx --uxb .\bin\uxb.exe
```

Bu komut 30 project pack paketini çalıştırır. Kitabın örnek omurgası bu test ailesine dayanır. Paketler yalnız PASS/FAIL sonucu üretmez; komutların birlikte kullanımını gösteren küçük programlar da sağlar.

## Expected testleri

```powershell
python xtestx\_runners\run_xtestx_expected_tests.py --root . --tests xtestx --uxb .\bin\uxb.exe
```

Expected test hattı daha küçük sözleşme testlerini çalıştırır. Komut, lexer, parser, semantic ve runtime düzeyinde beklenen çıktılar bu ailede kontrol edilir.

## Derin analiz

```powershell
python uxb_derin_analiz.py
```

Derin analiz aracı kaynak yüzeyi, dosya haritası, kullanım ilişkisi ve rapor üretimi için kullanılır. Kitapta bu araç, geliştiriciye “hangi dosya hangi katmana hizmet ediyor?” sorusunu cevaplamak için anlatılır.

## JSON çıktı ailesi

CLI içinde AST, MIR, runtime ve rapor dosyalarını dışarı almak için çok sayıda seçenek bulunur. Kitapta özellikle şu seçenekler ayrı anlatılır:

```text
--ast-json-out
--hir-json-out
--mir-pipeline-json-out
--mir-opcodes-json-out
--artifact-report-json-out
--ast-exec-result-json-out
--ast-stdout-out
--ast-stderr-out
--codegen-source AST|MIR
--emit-x64-nasm
--build-x64
```

Bu seçenekler kitabın mimari bölümleriyle birlikte kullanılacaktır. Okuyucu yalnız komutu çalıştırmayacak; AST ve MIR çıktısını da görerek dilin iç yolculuğunu anlayacaktır.
