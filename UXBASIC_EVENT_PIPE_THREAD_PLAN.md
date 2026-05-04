# uXBasic Event / Thread / Paralel / Pipe / Slot Tasarim Plani

Tarih: 2026-04-23

Bu belge, yeni komut ailesinin compiler katmanlarina nasil eklenecegini tanimlar.

Kabul edilen yeni yuzey:

- `CALL(API, ...)`
- `EVENT ... END EVENT`
- `THREAD ... END THREAD`
- `THREAT ... END THREAT` alias/uyumluluk yazimi
- `PARALEL ... END PARALEL`
- `PIPE ... END PIPE`
- pipe operatoru `|`
- `SLOT`
- `<BYTE slotsayisi>` / slot sayisi byte siniri
- `ON`
- `OFF`
- `TRIGGER`

## 1. Temel Ilke

`EVENT`, `THREAD`, `PARALEL` ve `PIPE` bloklari normal BASIC alt programina benzer. Farklari:

- Bir slot ailesine kaydedilirler.
- `ON` ile aktif hale gelirler.
- `OFF` ile pasif hale gelirler.
- `TRIGGER` ile calistirilirlar.
- Global degiskenlere erisebilirler.
- Ileride restricted/shared degisken politikasi eklenebilir.

## 2. Slot Modeli

Slot kimligi byte tabanlidir.

- Minimum: `0`
- Maksimum: `255`
- Her aile icin maksimum 256 slot:
  - event slotlari
  - pipe slotlari
  - thread/threat slotlari
  - paralel slotlari

Runtime ic model:

```text
SlotKind = EVENT | PIPE | THREAD | PARALEL
SlotId   = 0..255
State    = EMPTY | LOADED | ACTIVE | DISABLED | RUNNING | ERROR
```

`ON` RAM'e yukleme/aktif etme anlamina gelir.
`OFF` RAM'den kaldirma veya pasif etme anlamina gelir.
`TRIGGER` calistirma anlamina gelir.

## 3. Onerilen Syntax

### EVENT

```basic
EVENT EventAdi, x, y, 10
    PRINT x
    PRINT y
END EVENT
```

Alternatif okunur form:

```basic
EVENT EventAdi(x AS I32, y AS I32), 10
    PRINT x
END EVENT
```

Ilk MVP icin kabul:

```basic
EVENT EventAdi, 10
    PRINT "event"
END EVENT
```

### THREAD / THREAT

Canonical keyword `THREAD` olmalidir.
Kullanici metnindeki `THREAT` yazimi alias olarak degerlendirilebilir.

```basic
THREAD Worker, 1
    PRINT "worker"
END THREAD
```

Alias:

```basic
THREAT Worker, 1
    PRINT "worker"
END THREAT
```

### PARALEL

```basic
PARALEL Job, 2
    PRINT "parallel job"
END PARALEL
```

Ilk MVP'de gercek OS parallelism yerine deterministik sirali fallback kullanilabilir.
Sonraki fazda Win32 thread pool veya worker thread modeli eklenir.

### PIPE Blok

Pipe disaridan bir input alir, iceride sirali islemler yapar ve tek output verir.

```basic
PIPE Normalize, 3
    value = INPUT
    value = value + 1
    OUTPUT = value
END PIPE
```

MVP reserved degiskenleri:

- `INPUT`
- `OUTPUT`

### Pipe Operatoru

```basic
sonuc = 10 | Normalize | DoubleIt
```

Anlam:

```basic
tmp1 = TRIGGER PIPE Normalize, 10
sonuc = TRIGGER PIPE DoubleIt, tmp1
```

Operator precedence:

- Dusuk precedence onerilir.
- Assignment'tan yuksek, logical OR'dan dusuk veya esdeger olacak sekilde ayrica testlenmeli.

### SLOT

Slot deklarasyonu icin iki seviye onerilir.

Basit:

```basic
SLOT EVENT 10
SLOT PIPE 3
SLOT THREAD 1
SLOT PARALEL 2
```

Byte slot sayisi:

```basic
SLOT EVENT <BYTE 32>
SLOT PIPE <BYTE 16>
```

Not: `<BYTE slotsayisi>` syntax'i parser icin yeni angle annotation demektir. Alternatif daha kolay MVP syntax:

```basic
SLOT EVENT AS BYTE = 32
```

Kullanici istegindeki `<byte slotsayisi>` korunacak, ama parser zorlugunu azaltmak icin once `SLOT EVENT 32` MVP olarak eklenebilir.

### ON / OFF / TRIGGER

```basic
ON EVENT EventAdi
TRIGGER EVENT EventAdi
OFF EVENT EventAdi
```

Slot id ile:

```basic
ON EVENT 10
TRIGGER EVENT 10
OFF EVENT 10
```

Pipe input ile:

```basic
sonuc = TRIGGER PIPE Normalize, 123
```

## 4. CALL(API, ...) Tasarimi

`CALL(DLL, ...)` ham DLL sembolu cagirir.
`CALL(API, ...)` daha yuksek seviye API registry uzerinden calisir.

Onerilen anlam:

```basic
CALL(API, "windows.user32.MessageBoxA", I32, "PTR,STRPTR,STRPTR,I32", 0, "Mesaj", "Baslik", 0)
```

veya:

```basic
CALL(API, "win32", "MessageBoxA", I32, STDCALL, "PTR,STRPTR,STRPTR,I32", 0, "Mesaj", "Baslik", 0)
```

API registry su bilgiyi tutar:

| Alan | Ornek |
|---|---|
| api namespace | `windows.user32` |
| dll | `user32.dll` |
| symbol | `MessageBoxA` |
| convention | `STDCALL` |
| ret type | `I32` |
| arg types | `PTR,STRPTR,STRPTR,I32` |
| policy | allow/deny/manual |

Fark:

- `CALL(DLL)` serbest/ham DLL cagrisi.
- `CALL(API)` onceden kayitli, belgeli, guvenlik politikali API cagrisi.

## 5. AST Node Onerileri

| Syntax | AST Kind | Value | Cocuklar |
|---|---|---|---|
| `EVENT A, 1` | `EVENT_STMT` | `A` | slot expr, param decl/list, body |
| `THREAD A, 1` | `THREAD_STMT` | `A` | slot expr, body |
| `THREAT A, 1` | `THREAD_STMT` | `A` | alias source flag |
| `PARALEL A, 1` | `PARALEL_STMT` | `A` | slot expr, body |
| `PIPE A, 1` | `PIPE_STMT` | `A` | slot expr, body |
| `SLOT EVENT 10` | `SLOT_STMT` | `EVENT` | count/id expr |
| `ON EVENT A` | `SLOT_CONTROL_STMT` | `ON` | kind, target |
| `OFF EVENT A` | `SLOT_CONTROL_STMT` | `OFF` | kind, target |
| `TRIGGER EVENT A` | `TRIGGER_STMT` | `EVENT` | target, args |
| `a | b` | `BINARY_EXPR` | op `|` | left/right |

## 6. Runtime MVP

Yeni dosya onerisi:

- `src/runtime/exec/exec_slot_manager.fbs`
- `src/runtime/exec/exec_pipe_runtime.fbs`

MVP davranisi:

1. Program basinda event/pipe/thread/paralel bloklari registry'ye alinir.
2. `ON` slotu active yapar.
3. `OFF` slotu disabled yapar.
4. `TRIGGER` active slotu calistirir.
5. `THREAD` ve `PARALEL` ilk fazda sirali/deterministik calisir.
6. Ikinci fazda OS thread ve paralel queue eklenir.

## 7. MIR MVP

Yeni MIR opcode onerileri:

- `MIR_OP_SLOT_DEF`
- `MIR_OP_SLOT_ON`
- `MIR_OP_SLOT_OFF`
- `MIR_OP_TRIGGER`
- `MIR_OP_PIPE`
- `MIR_OP_PIPE_SEND`

Ilk fazda AST runtime daha hizli uygulanabilir.
MIR ikinci fazda parity icin eklenmelidir.

## 8. x64 MVP

Native x64 ilk faz:

- Slot bloklari metadata olarak emit edilir.
- `TRIGGER` icin kontrollu runtime helper call uretilir.
- Gercek OS thread/native parallel daha sonraki faza birakilir.

Runtime helper sembolleri:

- `__uxb_runtime_slot_on`
- `__uxb_runtime_slot_off`
- `__uxb_runtime_trigger`
- `__uxb_runtime_pipe_trigger`

## 9. Test Plani

### Parser Tests

- `EVENT E, 1 ... END EVENT`
- `THREAD T, 2 ... END THREAD`
- `THREAT T, 2 ... END THREAT`
- `PARALEL P, 3 ... END PARALEL`
- `PIPE Normalize, 4 ... END PIPE`
- `SLOT EVENT 10`
- `ON EVENT E`
- `OFF EVENT E`
- `TRIGGER EVENT E`
- `x = 10 | Normalize`
- `CALL(API, ...)`

### Runtime Tests

- ON olmadan TRIGGER hata vermeli veya no-op politikasi net olmali.
- ON sonrasi TRIGGER event body calistirmali.
- OFF sonrasi TRIGGER calistirmamali.
- Slot id 0..255 araliginda olmali.
- 256 ustu hata vermeli.
- Pipe input/output dogru akmali.
- Thread/paralel MVP sirali deterministik calismali.

### Native Tests

- Slot metadata build kirilmamali.
- Trigger runtime helper'a inmeli.
- Pipe operatoru x64 build'de ya helper'a inmeli ya da kontrollu unsupported vermeli.

## 10. Uygulama Sirasi

1. Parser keyword/registry ekleri. `OK`: `tests/probes/slot_event_pipe_parse.bas` ile dogrulandi.
2. AST node uretimi. `OK`: `EVENT_STMT`, `THREAD_STMT`, `PARALEL_STMT`, `PIPE_STMT`, `SLOT_STMT`, `SLOT_CONTROL_STMT`, `TRIGGER_STMT` ve `BINARY |` uretiliyor.
3. Semantic slot table metadata.
4. Slot manager runtime MVP. `PARTIAL`: AST runtime icin deterministik slot tablosu eklendi.
5. `ON/OFF/TRIGGER` AST runtime. `PARTIAL`: aktif slotlar sirali calistiriliyor.
6. `PIPE` block + pipe operator AST runtime. `PARTIAL`: `INPUT`/`OUTPUT` tek deger MVP calisiyor.
7. `CALL(API)` registry MVP.
8. MIR opcode ve evaluator parity.
9. x64 runtime helper lowering.
10. Test runner matrisi.
11. PCK5 ve README guncelleme.
