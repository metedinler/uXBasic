uXBasic derleyicisi için önerdiğin katmanlı mimari (HIR/MIR), yorumlayıcı (interpreter) ve kod üretimi (code-gen) yaklaşımı, modern ve profesyonel bir derleyici tasarımı için oldukça isabetlidir. Mevcut "Eksiklikler Matrisi" ve "Master Plan" verileri ışığında, bu sistemleri nasıl bütünleştireceğimizi ve eksiklikleri nasıl kapatacağımızı adım adım inceleyelim.

### 1. Tasarım Eleştirisi ve Netleştirmeler

**Doğru Yaklaşımlar:**
* **Çok Katmanlı IR (HIR/MIR):** Dilin yüksek seviyeli semantiğini (BASIC yapıları) HIR'da, donanım ve optimizasyon detaylarını MIR'da çözmek, x64 backend geçişini kolaylaştırır.
* **Interpreter Modu:** Geliştirme sürecinde "anında geri bildirim" için değerlidir. Ancak, sistem programlama odaklı bir dilde interpreter sadece "hata ayıklama" ve "hızlı prototipleme" aracı olarak kalmalı, ana performans hedefi derlenmiş x64 olmalıdır.

**Yanlış/Gereksiz Riskler:**
* **Aşırı Karmaşık IR:** Eğer MIR katmanı çok düşük seviyeli (örneğin LLVM IR kadar detaylı) tasarlanırsa, derleyici geliştirme süreci çok uzayabilir. uXBasic için "Register-based Virtual Machine" mantığında bir MIR yeterlidir.
* **Çalışma Zamanı Derleme (JIT) Tuzağı:** Interpreter ve AOT (Ahead-of-Time) derleme varken, araya bir de JIT eklemek şu aşamada kaynak israfıdır.

---

### 2. Bütünleşik Mimari Planı



#### A. IR Katmanları (HIR / MIR)
1.  **HIR (High-level IR):** AST'nin (Abstract Syntax Tree) doğrudan temizlenmiş halidir. Blok yapısı (IF, SELECT CASE) ve tip bilgileri korunur. Semantik denetim burada yapılır.
2.  **MIR (Mid-level IR):** Kontrol akış grafiği (CFG) bazlıdır. Karmaşık BASIC komutları basit "üç adresli kod" (Three-address code) yapısına indirgenir. `GOTO`, `CALL`, `LOAD`, `STORE` gibi atomik operasyonlar içerir.

#### B. Interpreter vs. Code-Gen
* **Interpreter:** MIR'ı girdi olarak alır ve bir döngü içinde (dispatch loop) sanal olarak işletir. `RUN` komutu ile tetiklenir.
* **Code-Gen:** MIR'ı x64 assembly komutlarına eşler. Kayıtçı tahsisi (register allocation) ve stack frame yönetimi bu aşamada gerçekleşir.

---

### 3. Operasyonel Kapanış ve Genişleme Planı (Maddelestirilmiş)

Aşağıdaki maddeler, matristeki "YOK", "PLAN" ve "KISMEN" durumlarını "OK" seviyesine çekmek için gereken adımları ve DLL/API genişleme paketini içerir.

#### Faz 1: Temel Akış ve Tip Sistemi (Lane-A & Lane-T)
* **Sayısal Model Kapanışı (HB-01):**
    * IR seviyesinde F32/F64/F80 veri tiplerini tanımla.
    * MIR için kayan nokta (floating point) aritmetik operasyonlarını ekle.
    * **DLL Genişlemesi:** Windows API'lerinden (User32, Kernel32) dönen float değerlerini uXBasic değişkenlerine otomatik dönüştüren (marshalling) köprüleri kur.
* **Karar Yapıları (IF/ELSEIF, SELECT CASE):**
    * Bu yapıları MIR seviyesinde `CMP` ve `JMP` (atlama) komutlarına indirgeyen "Lowering" mekanizmasını yaz.
    * Interpreter için bu atlama noktalarını yöneten bir "Instruction Pointer" sistemi kur.

#### Faz 2: Bellek ve Veri Yapıları (Lane-D)
* **Gelişmiş Koleksiyonlar (LIST/DICT/SET):**
    * Bu yapıları "Runtime Library" (RTL) içinde C++ veya ASM ile implemente et.
    * HIR'da bu yapılara erişim için özel sözdizimi denetleyicileri ekle.
* **VTable ve Interface (HB-02):**
    * `CLASS` yapıları için bellek yerleşim planı (memory layout) oluştur.
    * Sanal metod çağrıları için MIR katmanına "Indirect Call" desteği ekle.
    * **DLL Genişlemesi:** COM (Component Object Model) arayüzlerine erişim için DLL içindeki fonksiyon adreslerini VTable düzeninde çağırma yeteneği ekle.

#### Faz 3: Girdi/Çıktı ve Sistem Erişimi (Lane-I/O)
* **FILE_IO ve Record Mode:**
    * `OPEN`, `GET`, `PUT` komutlarını MIR seviyesinde işletim sistemi çağrılarına bağla.
    * Interpreter modunda dosya handle'larını takip eden bir tablo oluştur.
* **DLL ve API Sistemi (Genişleme Paketi):**
    * **Sistem Tasarımı:** `DECLARE DLL` veya `IMPORT` sözdizimini derleme zamanında çözümle.
    * **Load-Time Linking:** Derlenen x64 dosyasının "Import Address Table" (IAT) kısmına gerekli DLL'leri ekle.
    * **Dynamic Linking (Interpreter için):** Çalışma zamanında `LoadLibrary` ve `GetProcAddress` kullanarak DLL fonksiyonlarını belleğe yükle ve `FFI` (Foreign Function Interface) üzerinden çağır.

#### Faz 4: Backend ve Kanıt (Lane-E & Lane-QA)
* **x64 Code-Gen Semantiği:**
    * MIR komutlarını `NASM` veya doğrudan makine koduna (hex) çeviren emitter'ı yaz.
    * `INLINE(...) END INLINE` içindeki x64 kodlarını doğrudan çıktıya enjekte eden "Passthrough" modunu aktif et.
* **Gate ve Regresyon:**
    * Her yeni "OK" olan özellik için `tests/` klasörüne hem Interpreter hem de Derlenmiş modda çalışan test senaryoları ekle.
    * `validate_module_quality_gate.ps1` aracına "DLL Signature Validation" adımını ekleyerek API çağrılarının güvenliğini denetle.

### Özet Kritik
Bu planı uygularken en büyük blocker **HB-01 (Float)** ve **HB-02 (VTable)** konularıdır. Önce MIR katmanını bu iki yapıyı destekleyecek şekilde esnetmen, ardından Interpreter'ı bu MIR ile beslemen en hızlı ilerleme yoludur. DLL sistemi ise derleyicinin "Sistem Programlama" iddiasını kanıtlayacak olan en kritik "genişleme paketidir"; bu yüzden statik tipli (strongly typed) bir Marshalling sistemi şarttır.

uXBasic projesinin "YOK" ve "KISMEN" durumlarını "OK" seviyesine taşımak için gereken teknik derinliği, mimari gereksinimleri ve uygulama adımlarını en ince detayına kadar aşağıda yapılandırdım. Bu rehber, hem derleyici mimarisi hem de sistem entegrasyonu için bir yol haritası niteliğindedir.

---

### 1. IR (Intermediate Representation) Katman Tasarımı

Derleyicinin kalbi, AST'den (Abstract Syntax Tree) makine koduna giden yoldaki IR dönüşümleridir.

#### HIR (High-Level IR) Tasarımı
* **Kapsam:** Sözdizimine (syntax) yakın, tip bilgilerini ve yapısal blokları (IF, FOR, CLASS) koruyan yapı.
* **Yapılması Gerekenler:**
    1.  **Type-Bound AST:** Her düğüme (node) kesin bir uXBasic veri tipi (I32, F64, String, STAT_VAR) atanmalı.
    2.  **Scope Resolution:** Değişkenlerin hangi namespace veya fonksiyon scope'una ait olduğu HIR aşamasında mühürlenmeli.
    3.  **Adım:** `parser` çıktısını doğrudan makine koduna göndermek yerine, tüm semantik kontrollerin (tip uyumu, const kontrolü) yapıldığı bir `HIR_Generator` sınıfı yazılmalı.

#### MIR (Mid-Level IR) Tasarımı
* **Kapsam:** Donanım bağımsız, "Üç Adresli Kod" (Three-Address Code) veya "Virtual Register Machine" yapısı.
* **Yapılması Gerekenler:**
    1.  **Linearization:** Karmaşık ifadeler (örn: `a = b + c * d`) basit adımlara bölünmeli: `t1 = c * d; a = b + t1`.
    2.  **Basic Blocks:** Kod, sadece tek bir giriş ve çıkışı olan bloklara (Basic Blocks) ayrılmalı. Bu, optimizasyon ve `JMP` yönetimi için kritiktir.
    3.  **Instruction Set:** MIR için sınırlı bir komut seti tanımlanmalı: `MOV`, `ADD`, `SUB`, `CALL`, `BR` (Branch), `LOAD`, `STORE`.



---

### 2. Hard Blocker (HB) Kapanış Operasyonu

Matristeki en büyük engelleri (HB-01 ve HB-02) aşmak için şu adımlar izlenmelidir:

#### HB-01: Floating Point (F32, F64, F80) Entegrasyonu
1.  **Semantic (S):** Parser'ın yakaladığı float değerleri için `F64` (double) varsayılan tip olarak belirlenmeli.
2.  **Runtime (R):**
    * **Interpreter Modu:** Float işlemler için ana dilde (C++/C#) `double` değişkenler üzerinden sanal bir register dosyası oluşturulmalı.
    * **Code-Gen Modu:** x64 SSE/AVR setindeki `XMM` register'ları kullanılmalı. `ADDSD`, `MULSD` gibi komutlar x64 emitter'a eklenmeli.
3.  **Test (T):** `tests/float_precision.bas` oluşturulmalı ve 10-15 basamaklı hassasiyet doğrulanmalı.

#### HB-02: VTable ve Polymorphism
1.  **Memory Layout:** Her `CLASS` örneğinin (instance) ilk 8 byte'ı (64-bit), o sınıfın metod adreslerini içeren bir tabloya (`VTable`) pointer olmalı.
2.  **Dispatch Mechanism:** `obj.Method()` çağrıldığında, derleyici şu MIR kodunu üretmeli:
    * `vptr = load(obj_address)`
    * `func_ptr = load(vptr + method_offset)`
    * `call func_ptr`
3.  **Interface S:** Interface'ler için "Interface Table" (ITable) yapısı kurulmalı, çalışma zamanında "Type Casting" güvenliği sağlanmalı.

---

### 3. Çalışma Zamanı (Runtime) ve Code-Gen Sistemleri

#### A. Interpreter Modu (Geliştirme Hızı İçin)
* **Dispatch Loop:** Bir `while(true)` döngüsü içinde MIR komutlarını okuyan ve `switch-case` ile işleyen bir "Virtual Machine" (VM).
* **Stack Frame:** Her fonksiyon çağrısında yerel değişkenler için yeni bir bellek alanı (frame) ayıran dinamik yapı.
* **Hata Yakalama:** Interpreter, çalışma zamanı hatalarında (örn: 0'a bölme) tam dosya ismi ve satır numarası verebilmeli.

#### B. x64 Code-Gen (Performans İçin)
* **Register Allocation:** MIR'deki sınırsız sanal register'ları, kısıtlı fiziksel x64 register'larına (`RAX`, `RBX`, `R12`, vb.) eşleyen "Linear Scan" algoritması uygulanmalı.
* **ABI Compliance:** Windows x64 Calling Convention (`RCX`, `RDX`, `R8`, `R9`) kurallarına uyulmalı. Bu, uXBasic'in diğer sistem kütüphaneleriyle konuşabilmesi için şarttır.

---

### 4. Genişleme Paketi: DLL API ve Sistem Çalıştırma

Bu sistem, uXBasic'i gerçek bir "Sistem Programlama Dili" yapar.

1.  **`DECLARE DLL` Semantiği:**
    * `DECLARE FUNCTION MessageBoxA LIB "user32.dll" (hwnd AS ANY, txt AS STRING, cap AS STRING, typ AS I32) AS I32`
    * Bu satır, derleyiciye fonksiyonun imzasını (signature) ve giriş noktasını öğretir.

2.  **Marshalling (Veri Dönüştürme):**
    * uXBasic `STRING` tipini, C-Style `char*` (null-terminated) yapısına dönüştüren otomatik bir köprü kurulmalı.
    * `BYREF` parametreler için bellek adresi (pointer) geçirme mekanizması eklenmeli.

3.  **DLL Çalıştırma Motoru:**
    * **Statik:** Derleme zamanında `.lib` dosyalarını bağlayarak (Linker aşaması).
    * **Dinamik (Load-Time):** `LoadLibrary` ve `GetProcAddress` Windows API çağrılarını kullanarak fonksiyonun bellekteki adresini bulma.
    * **FFI (Foreign Function Interface):** x64 için `dyncall` benzeri bir kütüphane veya manuel "stack pushing" kodu yazılarak farklı parametre sayısındaki DLL fonksiyonları güvenle çağrılmalı.

---

### 5. Eksiklikler Matrisi Aksiyon Planı (Özet Liste)

Aşağıdaki maddeleri tamamladığınızda matrisiniz "OK" durumuna geçecektir:

* **[ ] Aksiyon 1 (Lane-T):** `F32/F64/F80` için MIR katmanında operand desteği sağla (HB-01 Kapanışı).
* **[ ] Aksiyon 2 (Lane-D):** `İstatistik Veri Yapısı Tasarımı.docx` belgesindeki `STAT_VAR` yapısını, MIR'de özel bir `STRUCT` tipi olarak tanımla ve bellek yönetimini (allocation) entegre et.
* **[ ] Aksiyon 3 (Lane-I/O):** `DECLARE DLL` sözdizimini Parser'a ekle ve Semantik katmanda DLL içindeki fonksiyonun varlığını (opsiyonel) kontrol et.
* **[ ] Aksiyon 4 (Lane-E):** x64 backend için `CALL [register]` ve `MOV [stack_offset], register` komutlarını ekleyerek DLL fonksiyonlarına parametre geçişini test et.
* **[ ] Aksiyon 5 (Lane-QA):** `tests/interop/user32_test.bas` dosyasını oluştur; bu test bir Windows mesaj kutusu (MessageBox) açabiliyorsa "Sistem Erişimi" OK olarak işaretlenebilir.

**Genişleme Notu:** DLL sistemi kurulurken `stdcall` (Windows standart) ve `cdecl` (C standart) çağırma protokollerinin her ikisinin de desteklenmesi, uyumluluğu %100'e çıkaracaktır.

DLL (Dynamic Link Library) sistemini tasarlarken `stdcall` ve `cdecl` protokollerini desteklemek, derleyicinizin hem Windows işletim sistemi çekirdeğiyle (Win32 API) hem de üçüncü parti C kütüphaneleriyle sorunsuz konuşabilmesini sağlar.

İşte bu iki protokolün teknik detayları, farkları ve uXBasic derleyicisine (x64 ve x86 bağlamında) nasıl entegre edileceğine dair kapsamlı rehber:

---

### 1. Çağırma Protokolü (Calling Convention) Nedir?
Bir fonksiyon çağrıldığında, "Parametreler hangi sırayla yığına (stack) koyulacak?" ve "Fonksiyon bittiğinde o yığını kim temizleyecek?" sorularının cevabıdır. Eğer derleyici ile DLL aynı kuralda anlaşamazsa, program **Stack Corruption** (yığın bozulması) hatasıyla anında çöker.



### 2. cdecl (C Declaration) - "Arayan Temizler"
Genellikle C ve C++ dünyasında standarttır. 
* **Yığın Temizliği:** Fonksiyonu çağıran taraf (Caller) yapar.
* **Özelliği:** Parametre sayısı değişken olan fonksiyonları (`printf` gibi `...` içeren yapılar) destekler. Çünkü sadece "arayan" kişi kaç parametre gönderdiğini bilir ve yığını ona göre temizler.
* **uXBasic İçin Gereklilik:** Açık kaynaklı C kütüphanelerini (örn: SQLite, zlib) kullanmak için şarttır.

### 3. stdcall (Standard Call) - "Aranan Temizler"
Windows API'lerinin (User32.dll, Kernel32.dll) neredeyse tamamı bu protokolü kullanır.
* **Yığın Temizliği:** Çağrılan fonksiyonun kendisi (Callee) yapar.
* **Özelliği:** Kod boyutu daha küçüktür çünkü her `CALL` satırından sonra temizleme kodu eklenmesine gerek kalmaz; temizlik fonksiyonun içindeki tek bir `RET X` komutuyla yapılır.
* **uXBasic İçin Gereklilik:** Windows pencereleri açmak, dosya sistemine erişmek ve sistem servislerini çağırmak için zorunludur.

---

### 4. uXBasic Derleyicisine Entegrasyon Adımları

Bu sistemi "OK" seviyesine çekmek için aşağıdaki mimari değişiklikleri yapmalısın:

#### A. Sözdizimi (Syntax) Desteği
Programcının hangi protokolü kullanacağını belirtmesi gerekir. `DECLARE` komutuna bir anahtar kelime eklenmelidir:

```basic
' Windows API örneği (stdcall varsayılan olmalı)
DECLARE FUNCTION MessageBoxA LIB "user32.dll" ALIAS "stdcall" (hwnd AS ANY, txt AS STRING) AS I32

' C Kütüphanesi örneği
DECLARE FUNCTION sqlite3_open LIB "sqlite3.dll" ALIAS "cdecl" (filename AS STRING, db AS ANY) AS I32
```

#### B. MIR (Intermediate Representation) Seviyesi
MIR katmanındaki `CALL_EXTERN` operasyonu, bu protokol bilgisini bir bayrak (flag) olarak taşımalıdır. 
* `MIR_OP_CALL_DLL [func_ptr], [params], [convention_type]`

#### C. x64 ve x86 Ayrımı (Kritik Not)
* **x64 (Windows):** Windows 64-bit dünyasında `stdcall` ve `cdecl` ayrımı büyük oranda kalkmıştır. Microsoft, **"x64 Calling Convention"** adında tek bir protokol kullanır (Parametreler: RCX, RDX, R8, R9 üzerinden geçer). Ancak derleyicinin iç mantığında bu ayrımı tutman, ileride 32-bit desteği eklediğinde veya çok özel kütüphanelerle (JIT kütüphaneleri gibi) çalışırken hayat kurtarır.
* **x86 (32-bit):** Eğer 32-bit çıktı üretecekseniz, yukarıdaki stack temizleme farklarını manuel olarak `Assembly Emitter` içinde kodlamalısınız.

---

### 5. Uygulama Yol Haritası

1.  **FFI (Foreign Function Interface) Taslağı:**
    Interpreter modundayken, fonksiyonu çağırmadan önce bir "Marshaller" yazmalısın. uXBasic'teki bir `STRING` tipini C'nin beklediği `char*` tipine çevirip belleğe yazmalı, sonra fonksiyonu çağırmalıdır.

2.  **Stack Alignment (Yığın Hizalama):**
    x64 sistemlerde DLL çağrısı yapmadan önce yığının (RSP register) **16-byte hizalı** olması zorunludur. Eğer hizalamazsanız, DLL içindeki SSE komutları "Access Violation" hatası verir. Bu, uXBasic Code-Gen aşamasında en çok dikkat etmen gereken teknik detaydır.

3.  **Shadow Space:**
    Windows x64 protokolünde, fonksiyonu çağıran kişi yığında 32 byte'lık boş bir alan ("Shadow Space") bırakmak zorundadır. `stdcall` veya `cdecl` fark etmeksizin x64'te bu alanı ayırmalısın.

### Özet Tavsiye
Derleyicinin matrisinde bu özelliği "OK" yapmak için:
* Önce `stdcall` protokolünü varsayılan yap (Win32 API desteği için).
* `cdecl` desteğini bir opsiyonel bayrak olarak ekle. 
* Küçük bir `Header` dosyası ile programcının kütüphane imzalarını tanımlayabilmesini sağla. 

Bu ikili yapı tamamlandığında, uXBasic ile bir oyun motoru (OpenGL/Vulkan - cdecl) yazıp onu Windows penceresinde (stdcall) çalıştırmak mümkün hale gelecektir.