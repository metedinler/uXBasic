# UXJSRT C ABI sözleşmesi v1

## Tasarım ilkesi

DLL sınırından QuickJS pointer'ı geçmez. Runtime, context ve result değerleri I32 nesne kimliğidir.

Bu sayede:

- uXBasic ABI10 üzerinde yalnız `I32` ve `STRPTR` gerekir,
- x64 pointer kırpılması UXJSRT dış ABI'sine taşınmaz,
- stale handle tespiti generation alanıyla yapılır,
- QuickJS nesne ömrü DLL içinde kalır.

## Handle ömrü

```text
runtime_create
  context_create
    bootstrap/eval/call
      result_json
      result_free
    context_free
  runtime_free
```

`runtime_free`, açık context ve resultları da temizler; yine de açık kapatma sırası tercih edilir.

## Eşzamanlılık

Bir `JSRuntime` yalnız oluşturulduğu işletim sistemi thread'inde kullanılabilir. Yanlış thread çağrısı `UXJS_THREAD_AFFINITY` hatası verir.

## Eval bayrakları

```text
0 = script
1 = module
2 = eval sonrası pending job queue boşalt
3 = module + pending job queue
```

## Async sınırı

`uxjs_call_json_await` yalnız QuickJS job queue içinde çözülen Promise'ları bekler. Harici timer, socket veya native event kaynağı henüz yoksa çözülmeyen Promise `UXJS_ASYNC_PENDING_EXTERNAL_IO` üretir.

## Sonuç biçimi

Normal değer JSON'dur. BigInt şu biçimde korunur:

```json
{"$uxbType":"bigint","value":"12345678901234567890"}
```

`undefined`:

```json
{"$uxbType":"undefined"}
```
