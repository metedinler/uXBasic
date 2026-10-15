# uXBasic Advanced Statistics Module 2

Bu modül `uxstats.bas` dosyasını bozmaz. İleri hipotez testleri ve model tanıları ayrı bir katman olarak gelir:

```basic
INCLUDE "libs/uxstats/uxstats2.bas"
```

## Kapsam

- t testleri: one-sample, Welch, pooled/equal variance, paired
- z testleri: one-sample, two-sample, one proportion, two proportion
- chi-square: goodness-of-fit, 2x2 independence
- F testleri: variance ratio, regression model F
- ANOVA: one-way ANOVA
- posthoc: Bonferroni-adjusted t p, Tukey-q statistic, Scheffe-F statistic
- regression: slope, intercept, R2, covariance, correlation
- diagnostics: VIF, Durbin-Watson, Breusch-Godfrey LM/p
- time series: ADF statistic and approximate p
- multivariate: binary ANCOVA F/p, Hotelling T2 2D p

## Dürüst sınır

Bu modül başlangıçta standart C ile yazıldı. SciPy/R seviyesinde her testin tüm varyantlarını değil, uXBasic içinde çağrılabilir sağlam bir ileri istatistik çekirdeğini hedefler.

Özellikle:

- ADF p-value yaklaşık t dağılımı ile verilir; MacKinnon tam değerleri değildir.
- Tukey için q istatistiği verilir; studentized-range exact p şu anda yoktur.
- BIG MANOVA yerine iki grup/iki değişken için Hotelling T2 sağlanır.
- ANCOVA binary group örneği ile gelir; çok faktörlü ANCOVA sonraki katmandır.

## Build / smoke

```bat
uxb\compiler\scripts\run_uxstats2_smoke.bat
```
