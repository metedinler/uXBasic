# UXAI + UXMATH 4 Prompt Roadmap

## Prompt 1 — UXMATH Core

Bu pakette yapıldı.

Amaç:
- Polinom
- Türev
- İntegral
- Sayısal çözüm
- ODE çözümü
- Aktivasyonlar
- Vektör/matris çekirdeği

Çıktı:
- `uxmath.dll`
- `libs/uxmath/uxmath.bas`

## Prompt 2 — UXAI Inference Core

Odak:
- `uxai.dll`
- `libs/uxai/uxai.bas`
- Neuron handle
- Layer handle
- Network handle
- Sök-tak layer builder
- Dense layer
- Activation layer
- Forward pass

Kullanıcı hedefi:

```basic
INCLUDE "libs/uxmath/uxmath.bas"
INCLUDE "libs/uxai/uxai.bas"

net = UXAI_NetworkCreate()
UXAI_NetworkAddDense(net, 4, 8, UXAI_ACT_RELU)
UXAI_NetworkAddDense(net, 8, 3, UXAI_ACT_SIGMOID)
UXAI_NetworkForward(net, inputVec, outputVec)
```

## Prompt 3 — Training / Optimizer / Loss

Odak:
- Backpropagation
- MSE
- MAE
- binary cross entropy
- categorical cross entropy
- SGD
- momentum
- mini-batch
- model save/load
- stats2 ile metrik entegrasyonu

## Prompt 4 — Integration / Examples / Release Gate

Odak:
- XOR örneği
- regresyon örneği
- sınıflandırma örneği
- katman ekleme/çıkarma testleri
- model dosyası testleri
- UXBc final include paket düzeni
