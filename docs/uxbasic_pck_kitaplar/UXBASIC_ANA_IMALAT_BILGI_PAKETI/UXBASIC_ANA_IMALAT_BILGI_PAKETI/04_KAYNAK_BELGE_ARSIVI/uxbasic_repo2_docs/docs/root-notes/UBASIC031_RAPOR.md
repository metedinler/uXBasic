# ubasic031 Klasor Raporu

## Nedir?
`ubasic031`, oyun klasoru degil; UltraBasic adli QB benzeri bir derleyici ve onun runtime (ASM) altyapisidir.

## Ne ise yarar?
- BASIC benzeri kaynak kodu parse edip asm uretir, sonra exe'ye linkler.
- DOS ve Win32 hedeflerini destekler.
- PMODE ve bellek odakli calisma mantigi vardir.
- DLL fonksiyon cagirma (USEDLL) ve ATOFFSET gibi dusuk seviye ozellikler sunar.

## Klasor Icerigi (Ana Bilesenler)
- `UBASIC.EXE`: Derleyici calistirilabilir dosyasi.
- `SOURCE/`: Derleyici kaynak kodu.
  - `UBASIC.BAS`: Ana derleme dongusu.
  - `KEYWORDS.BAS`, `KEYWORD2.BAS`: Komut/cozumleyici rutinleri.
  - `UBASIC.MAK`: Kaynak liste dosyasi.
- `AINCLUDE/`: Runtime asm modulleri.
  - `MEM.ASM`: DPMI/bellek blok yonetimi.
  - `STRING.ASM`: String rutinleri.
  - `FILE.ASM` / `FILE.W32`: DOS/Win32 dosya islemleri.
  - `TEXTWIN.W32`: Windows pseudo-console/text window.
  - `UBWIN.INC`: Win32 sabitleri/yapi tanimlari.
- `MAKEDOS.BAT`, `MAKEWIN.BAT`: NASM + linker derleme akislari.
- `FLOAT.BAS`, `oop.bas`: Ornek test kaynaklari.

## Derleme Akisi (Ozet)
1. UltraBasic kaynak satirlari parse edilir.
2. ASM cikisi uretilir.
3. Hedefe gore DOS veya Win32 linkleme yapilir.

## Not
- `AINCLUDE/TEXTWIN.ASM` dosyasi bos.
- Klasor icinde derleme araclari (`nasm.exe`, `ALINK.EXE`, `STUBIT.EXE`) da bulunuyor.

# ubasic031 Klasor Raporu

## Kisa Ozet
Bu klasor bir oyun klasoru degildir. Bu klasorun amaci, yazilan program metnini alip calisabilir bir programa donusturmektir.

## Bu Klasor Ne Ise Yarar?
- Yazilan metni adim adim okuyup anlamlandirir.
- Metindeki komutlari duzene koyar.
- Programin calisabilmesi icin gerekli parcali metinleri birlestirir.
- Sonunda calistirilabilir dosya olusturur.

## Tam Yapi Duzeni

### 1) Giris Katmani
Bu bolumde kullanici tarafindan yazilan program metni alinır.

### 2) Anlamlandirma Katmani
Bu bolum metindeki satirlari tek tek inceler.
Hangi satirin ne yapmak istedigini bulur.

### 3) Kurallar Katmani
Bu bolumde hangi komutun nasil ele alinacagi belirlenir.
Yanlis kullanim olursa kullaniciya acik hata mesaji verilir.

### 4) Temel Isler Katmani
Bu bolumde yazma, okuma, metin isleme, sayi ve bellekle ilgili temel isler yapilir.

### 5) Ekran Katmani
Bu bolum ekrana yazi basma ve goruntuleme islerini yapar.
Bir yontemle eski tip ekran gorunumunu taklit eder.

### 6) Dosyalama Katmani
Bu bolum dosya acma, kapama, okuma, yazma ve dosya icinde ileri geri gitme islerini yapar.

### 7) Cikti Uretim Katmani
Bu bolumde tum parcalar bir araya getirilir.
Sonunda calistirilabilir dosya olusturulur.

## Klasor Icindeki Bolumler ve Gorevleri

### Ana Program Bolumu
- UBASIC.EXE: Tum sureci baslatan ana calistirici dosya.

### Kaynak Metin Bolumu
- SOURCE klasoru: Ana duzenin yazili oldugu bolum.
- UBASIC.BAS: Isin genel akisini yoneten ana dosya.
- KEYWORDS.BAS ve KEYWORD2.BAS: Komutlari tanima ve isleme bolumu.
- UBASIC.MAK: Hangi dosyalarin bir arada ele alinacagini gosteren liste.

### Yardimci Parcalar Bolumu
- AINCLUDE klasoru: Programin temel islerini yapan yardimci parcalar.
- MEM.ASM: Bellek duzeni ile ilgili isler.
- STRING.ASM: Yazi birlestirme, karsilastirma gibi metin isleri.
- FILE.ASM ve FILE.W32: Dosya ile ilgili temel isler.
- TEXTWIN.W32: Ekran gosterimi ile ilgili bolum.
- UBWIN.INC: Ekran ve pencere tarafinda kullanilan tanimlar.

### Hazir Komut Dosyalari
- MAKEDOS.BAT: Bir hedef icin cikti hazirlar.
- MAKEWIN.BAT: Diger hedef icin cikti hazirlar.

### Ornekler
- FLOAT.BAS: Sayi agirlikli bir ornek.
- oop.bas: Yapi duzeni gosteren bir ornek.

## Calisma Sirasi
1. Program metni alinir.
2. Satirlar okunur ve anlamlandirilir.
3. Komutlar kurallara gore uygun bolumlere dagitilir.
4. Yardimci parcalarla birlikte tum metin birlestirilir.
5. Son cikti olusturulur.

## Artefakt (Ortaya Cikan Ciktilar)

Bu klasorde surecin sonunda ortaya cikan veya surec icin kullanilan cikti turleri sunlardir:
- Calistirilabilir dosyalar.
- Gecici ara dosyalar.
- Yardimci komut dosyalari.
- Ornek girdi dosyalari.
- Aciklama ve yonlendirme metinleri.

## Klasor Hakkinda Son Notlar
- AINCLUDE altindaki TEXTWIN.ASM dosyasi bostur.
- Klasor, tek parca bir oyundan cok, programi calistirilabilir hale getiren bir hazirlama duzenidir.


# ubasic031 Klasor Raporu

## Kisa Ozet
Bu klasor bir oyun klasoru degildir.
Bu klasor, BASIC benzeri bir dilde yazilan metinleri calisabilir programa ceviren bir hazirlama duzenidir.

## QBasic Ile Ilintisi
- Bu dil, QBasic ile ayni aileden bir yazim anlayisi kullanir.
- SUB, FUNCTION, DIM, IF, FOR, SELECT CASE gibi temel yapi komutlari benzerdir.
- Birebir ayni degildir; yani QBasicin tum komutlari ve tum davranislari aynen kopya degildir.
- QBasicten farkli olarak DOS disinda Windows hedefi de uretebilir.
- Ayrica dis kutuphane cagirimi (USEDLL) gibi ek imkanlar sunar.

## QBasic Programlarina Ne Destek Saglar?
- Basit ve klasik QBasic kodlarinin onemli bir bolumu kucuk duzeltmelerle tasinabilir.
- Ekran, dongu, kosul, temel dosya ve temel matematik komutlarinda benzerlik vardir.
- Tasima sirasinda en cok duzeltme gerektiren kisimlar:
  - Bazi islec yazimlari
  - Donanima dogrudan erisim komutlari
  - Bellek adresleme ile ilgili kisimlar
  - Hedef secimi (DOS ya da Windows)
- Sonuc: QBasic kodlarini yeniden kullanmak icin iyi bir taban verir, ama tam ve otomatik birebir uyumluluk beklenmemelidir.

## Klasor Bolumleri Ve Gorevleri
- UBASIC.EXE: Ana calistirici.
- SOURCE klasoru: Dili okuyan, anlayan ve ciktiya ceviren ana metinler.
- AINCLUDE klasoru: Dosya, metin, ekran ve bellek gibi temel isleri yapan yardimci parcalar.
- MAKEDOS.BAT ve MAKEWIN.BAT: Ciktiyi hedefe gore hazirlayan komut dosyalari.
- FLOAT.BAS ve oop.bas: Ornek kullanim metinleri.

## Bu Dilin Tanidigi Komutlar Ve Amaclari

### Hazirlama Asamasi Komutlari
- CONST: Sabit deger tanimlar.
- %%INCLUDE: Baska metin dosyasini ekler.
- %%DESTOS, %%PLATFORM: Ciktinin DOS mu Windows mu olacagini belirler.
- %%IFC: Bir ad tanimliysa ya da tanimli degilse satir bloklarini acar/kapatir.
- %%IF: Kosula gore satir bloklarini acar/kapatir.
- %%ELSE: Hazirlama asamasinda alternatif blok acma.
- %%ENDIF: Hazirlama kosul blogunu bitirme.
- %%ENDCOMP: Hazirlama islemini erken bitirme.
- %%ERRORENDCOMP: Mesaj verip hazirlamayi durdurma.
- %%NOZEROVARS: Degisken ilk deger sifirlama davranisini degistirme.
- %%SECSTACK: Ikinci yigin kullanimini acma.

### Program Akisi Komutlari
- IF, ELSEIF, ELSE, END IF: Kosullu calisma.
- SELECT CASE, CASE, CASE ELSE, END SELECT: Cok secenekli kosul akisi.
- FOR, NEXT: Sayacli dongu.
- DO, LOOP: Kosullu/sonsuz dongu.
- EXIT: Dongu ya da bloktan cikis.
- GOTO: Etikete kosulsuz atlama.
- GOSUB, RETURN: Alt satir grubuna gidip geri donme.
- END: Programi sonlandirma.

### Tanim Ve Yapi Komutlari
- SUB, FUNCTION: Alt is parcasi tanimlama.
- DECLARE: Once tanim verme.
- TYPE: Alanlardan olusan yapi tanimlama.
- DIM: Degisken, dizi, yazi alani tanimlama.
- REDIM: Dizi boyutunu yeniden duzenleme.
- DEFINT, DEFLNG, DEFSNG, DEFDBL, DEFEXT, DEFSTR, DEFBYT: Ad araligina gore varsayilan tur atama.
- _SETSTRINGSIZE: Varsayilan yazi alan boyutunu ayarlama.

### Ekran Ve Metin Komutlari
- PRINT: Ekrana yazi basma.
- CLS: Ekrani temizleme.
- COLOR: Yazi ve arka plan rengi ayarlama.
- LOCATE: Imlec yerini ayarlama.
- INKEY$: Klavyeden tek tus alma.
- ASC: Karakterin sayi karsiligini alma.
- LEN: Yazi uzunlugunu alma.
- CHR$: Sayidan karakter uretme.
- STR$: Sayiyi yaziya cevirme.
- MID$: Yazinin ortasindan parca alma.
- LTRIM$, RTRIM$: Bas ve son bosluklari temizleme.
- UCASE$, LCASE$: Buyuk/kucuk harfe cevirme.
- STRING$, SPACE$: Tekrarli karakter ya da bosluk yazi uretme.

### Sayi Ve Hesap Komutlari
- VAL: Yazidan sayi cevirme.
- ABS: Mutlak deger alma.
- SGN: Isaret bulma.
- INT: Tam sayiya donusturme.
- SIN, COS, TAN: Trigonometrik hesaplar.
- SQRT: Karekok alma.
- TIMER: Gecen zamani alma.

### Dosya Komutlari
- OPEN: Dosya acma.
- CLOSE: Dosya kapama.
- GET: Dosyadan okuma.
- PUT: Dosyaya yazma.
- LOF: Dosya boyu alma.
- EOF: Dosya sonuna gelinip gelinmedigini anlama.
- SEEK: Dosyada konum alma/degistirme.

### Bellek Ve Adres Komutlari
- VARPTR, SADD: Degisken adresini alma.
- LPTR: Etiket adresini alma.
- CODEPTR: SUB/FUNCTION adresini alma.
- PEEK, PEEKB, PEEKW, PEEKD: Bellekten deger okuma.
- POKE, POKEB, POKEW, POKED: Bellege deger yazma.
- POKES: Bellege yazi yazma.
- MEMCOPY, MEMCOPYB, MEMCOPYW, MEMCOPYD: Bellek bolgesi kopyalama.
- MEMFILL, MEMFILLB, MEMFILLW, MEMFILLD: Bellek bolgesini degerle doldurma.
- SETNEWOFFSET: Bagli degiskenin adresini degistirme.

### Donanima Yakin Komutlar (Ozellikle DOS)
- INP, INPB, INPW, INPD: Giris kapilarindan okuma.
- OUT, OUTB, OUTW, OUTD: Cikis kapilarina yazma.
- INT: Kesme cagrisi yapma.
- INT16: Gercek kip kesme cagrisi.
- SETVECT: Kesme adresi degistirme.
- CPUFLAGS: Islem durumu bayrak degerini alma.
- PUSH: Degeri yigina koyma.

### Gomu Kod Komutlari
- _ASM: Gomu kod blogu baslatma.
- _END ASM: Gomu kod blogu bitirme.
- ASM_SUB: Tamami gomu kod olan alt is tanimi.
- ASM_FUNCTION: Tamami gomu kod olan fonksiyon tanimi.

## Artefakt (Ortaya Cikan Ciktilar)
- Calistirilabilir dosyalar.
- Gecici ara dosyalar.
- Yardimci komut dosyalari.
- Ornek girdi metinleri.
- Aciklama metinleri.

## Son Not
- AINCLUDE altindaki TEXTWIN.ASM dosyasi bostur.
- Bu duzen, eski QBasic aliskanligi olan kullaniciya tanidik bir yol verir; ancak birebir ayni davranis beklemek yerine tasima ve test yaklasimi daha dogrudur.
