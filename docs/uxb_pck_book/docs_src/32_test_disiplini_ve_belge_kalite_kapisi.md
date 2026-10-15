# 32. Test Disiplini ve Belge Kalite Kapısı

Resmî teknik kitap, kaynak koddan koparsa kısa sürede eskiyen bir metne dönüşür. Bu yüzden uXBasic kitabında her ana bölüm, mümkün olduğunda test, örnek veya derleyici artefactı ile desteklenir. Kitapta yazılan örneklerin amacı güzel görünmek değildir; kaynak gerçekliğiyle bağ kurmaktır.

## 32.1. Project pack ana kapısı

Ana kapı şudur:

```powershell id="11fbwg"
python xtestx\_runners\run_xtestx_project_packs.py --root . --tests xtestx --uxb .\bin\uxb.exe
```

Bu komut, project pack örneklerinin genel durumunu verir. Kitabın omurgası bu paketlerden beslenir. Pack 30 tam entegrasyon örneği, dil yüzeylerinin birlikte nasıl kullanıldığını gösterdiği için özel değerdedir.

## 32.2. Odaklı test kapısı

Bir bölüm yazılırken ilgili pack ayrıca çalıştırılabilir:

```powershell id="wu9v13"
python xtestx\_runners\run_xtestx_project_packs.py --root . --tests xtestx --uxb .\bin\uxb.exe --only pack_16_big_extfp_canonical
```

Örneğin büyük sayı bölümü yazılıyorsa pack 16, tam entegrasyon bölümü yazılıyorsa pack 30 çalıştırılır.

## 32.3. Expected test kapısı

Expected testler, kaynak dosya ve beklenen çıktı ilişkisini denetler:

```powershell id="rsb8ak"
python xtestx\_runners\run_xtestx_expected_tests.py --root . --tests xtestx --uxb .\bin\uxb.exe
```

Bu komut özellikle kitap örnekleri çoğaldığında önem kazanır. Her yeni örnek ileride expected test havuzuna bağlanabilir.

## 32.4. Belge örneklerini çalıştırma disiplini

Kitap örnekleri için önerilen düzen:

```text id="xo7en2"
docs_examples/
  book_projects/
    project_01_tank_sicaklik.uxb
    project_02_yem_stok.uxb
    ...
```

Örnek çalıştırma:

```powershell id="5r9upk"
.\bin\uxb.exe .\docs_examples\book_projects\project_01_tank_sicaklik.uxb --execmem --interpreter-backend AST
```

MIR ile çalıştırma:

```powershell id="7ru5qq"
.\bin\uxb.exe .\docs_examples\book_projects\project_01_tank_sicaklik.uxb --execmem --interpreter-backend MIR
```

JSON artefact almak:

```powershell id="li7vxj"
.\bin\uxb.exe .\docs_examples\book_projects\project_01_tank_sicaklik.uxb `
  --ast-json-out reports\book_examples\project_01_ast.json `
  --mir-json-out reports\book_examples\project_01_mir.json `
  --run-report-json-out reports\book_examples\project_01_run.json
```

Bu komutlar, kitap örneklerini yalnız metin olmaktan çıkarır.

## 32.5. Kitap üretim kapısı

Kaynak yüzeyi çıkarılır:

```powershell id="3mtilw"
python tools\docs\extract_uxbasic_book_sources.py --root . --out docs_build\book_source_surface.json --md-out docs_build\generated
```

Tek kitap üretilir:

```powershell id="zcwjsu"
python tools\docs\build_uxbasic_pck_book.py --root . --include-generated
```

Bu iki komut, belge üretimini tekrar edilebilir hâle getirir.

## 32.6. Belge kalite kuralları

Kitaba yeni bölüm eklenirken şu kapılar uygulanır:

| Kapı | Soru |
|---|---|
| Görev kapısı | Bu bölüm okuyucuya ne yaptırıyor? |
| Syntax kapısı | Komutun yazılış biçimi açık mı? |
| Örnek kapısı | Öneri kodla gösterildi mi? |
| Katman kapısı | AST, MIR, runtime veya backend ilişkisi doğru mu? |
| Tekrar kapısı | Aynı cümle başka bölümde aynı görevle tekrar ediyor mu? |
| Kaynak kapısı | Anahtar kelime ve CLI bilgisi 12.06_1 yüzeyiyle uyumlu mu? |

Bu kapılar kitabı canlı tutar. uXBasic büyüdükçe kitap da büyür; fakat tekrar ederek değil, yeni görev açıklayarak büyür.
