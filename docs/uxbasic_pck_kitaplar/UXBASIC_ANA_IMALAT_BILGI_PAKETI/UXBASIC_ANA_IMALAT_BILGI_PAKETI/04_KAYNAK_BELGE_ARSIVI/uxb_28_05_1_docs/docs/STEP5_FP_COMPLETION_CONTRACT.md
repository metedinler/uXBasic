# UXBc Adım 5 Contract — Floating Point Completion

## Amaç

F80/F128/BIGF/BIGD/BALL tiplerini compiler içinde tek karar sistemine bağlamak.

## Tip aileleri

| Tip | Storage | Runtime family | Arithmetic |
|---|---:|---|---|
| F32 | native | none | native |
| F64 | native | none | SSE/native |
| F80 | 16 byte slot | uxb_f80 | external runtime |
| F128 | 16 byte slot | uxb_f128 | external runtime |
| BIGF(n) | handle | uxb_bigf | external runtime |
| BIGD(n) | handle | uxb_bigd | external runtime |
| BALL(n) | handle | uxb_ball | external runtime |

## Temel kural

F80/F128/BIGF/BIGD/BALL için register arithmetic yoktur.
Her işlem runtime call'dır.

## Diagnostic kuralları

- Runtime DLL yoksa: `UXB_EXTFP_RUNTIME_MISSING`
- Address lowering yoksa: `UXB_EXTFP_ADDRESS_LOWERING_MISSING`
- Type promotion belirsizse: `UXB_EXTFP_PROMOTION_AMBIGUOUS`
- BIGF/BIGD/BALL runtime handle yoksa: `UXB_EXTFP_HANDLE_RUNTIME_MISSING`
- Native FP instruction sızarsa: `UXB_EXTFP_NATIVE_ARITH_FORBIDDEN`

## Promotion

| Sol | Sağ | Sonuç |
|---|---|---|
| F80 | integer | F80 |
| F128 | integer | F128 |
| F80 | F128 | F128 |
| BIGF | any numeric | BIGF |
| BIGD | integer/decimal | BIGD |
| BALL | numeric | BALL |
| BIGF | BIGD | diagnostic veya explicit cast |
| BALL | BIGF/BIGD | BALL |

BIGF/BIGD karışık işlem explicit cast olmadan otomatik yapılmayacak.
