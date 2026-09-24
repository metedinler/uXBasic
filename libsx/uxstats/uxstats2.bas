' uXBasic Advanced Statistics Module 2
' Include file extension is .bas because current uXBasic INCLUDE accepts .bas.
' Usage:
'   INCLUDE "libs/uxstats/uxstats2.bas"
'   x = UXSTATS2_VecCreate(32)
'   UXSTATS2_VecPush(x, 1.0)
'   PRINT UXSTATS2_OneSampleTP(x, 0.0)
'
' Design:
' - No new uXBasic keyword.
' - Advanced tests are in uxstats2.dll.
' - Handles are U64/PTR-compatible.
' - p-values are numeric approximations intended for engineering/scientific workflows.

FUNCTION UXSTATS2_Version() AS I32
    DIM r AS I32
    r = CALL(DLL, "uxstats2.dll", "uxstats2_version", I32, CDECL)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_VecCreate(capacity AS I32) AS U64
    DIM h AS U64
    h = CALL(DLL, "uxstats2.dll", "uxstats2_vec_create", PTR, CDECL, "I32", capacity)
    RETURN h
END FUNCTION

FUNCTION UXSTATS2_VecFree(h AS U64) AS I32
    CALL(DLL, "uxstats2.dll", "uxstats2_vec_free", VOID, CDECL, "PTR", h)
    RETURN 1
END FUNCTION

FUNCTION UXSTATS2_VecPush(h AS U64, value AS F64) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxstats2.dll", "uxstats2_vec_push", I32, CDECL, "PTR,F64", h, value)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_VecSet(h AS U64, index AS I32, value AS F64) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxstats2.dll", "uxstats2_vec_set", I32, CDECL, "PTR,I32,F64", h, index, value)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_VecGet(h AS U64, index AS I32) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_vec_get", F64, CDECL, "PTR,I32", h, index)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_VecCount(h AS U64) AS I32
    DIM r AS I32
    r = CALL(DLL, "uxstats2.dll", "uxstats2_vec_count", I32, CDECL, "PTR", h)
    RETURN r
END FUNCTION

' --- Probability helpers ---
FUNCTION UXSTATS2_NormalCDF(z AS F64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_normal_cdf", F64, CDECL, "F64", z)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_NormalP2(z AS F64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_normal_p2", F64, CDECL, "F64", z)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_TP2(t AS F64, df AS F64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_t_p2", F64, CDECL, "F64,F64", t, df)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_ChiSquareP(stat AS F64, df AS F64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_chisq_p", F64, CDECL, "F64,F64", stat, df)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_FP(stat AS F64, df1 AS F64, df2 AS F64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_f_p", F64, CDECL, "F64,F64,F64", stat, df1, df2)
    RETURN r
END FUNCTION

' --- t tests ---
FUNCTION UXSTATS2_OneSampleTStat(x AS U64, mu0 AS F64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_one_sample_t_stat", F64, CDECL, "PTR,F64", x, mu0)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_OneSampleTP(x AS U64, mu0 AS F64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_one_sample_t_p", F64, CDECL, "PTR,F64", x, mu0)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_WelchTStat(x AS U64, y AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_welch_t_stat", F64, CDECL, "PTR,PTR", x, y)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_WelchTP(x AS U64, y AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_welch_t_p", F64, CDECL, "PTR,PTR", x, y)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_PooledTStat(x AS U64, y AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_pooled_t_stat", F64, CDECL, "PTR,PTR", x, y)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_PooledTP(x AS U64, y AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_pooled_t_p", F64, CDECL, "PTR,PTR", x, y)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_PairedTStat(before AS U64, after AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_paired_t_stat", F64, CDECL, "PTR,PTR", before, after)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_PairedTP(before AS U64, after AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_paired_t_p", F64, CDECL, "PTR,PTR", before, after)
    RETURN r
END FUNCTION

' --- z tests ---
FUNCTION UXSTATS2_OneSampleZStat(x AS U64, mu0 AS F64, sigma AS F64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_one_sample_z_stat", F64, CDECL, "PTR,F64,F64", x, mu0, sigma)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_OneSampleZP(x AS U64, mu0 AS F64, sigma AS F64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_one_sample_z_p", F64, CDECL, "PTR,F64,F64", x, mu0, sigma)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_TwoSampleZStat(x AS U64, y AS U64, sigmaX AS F64, sigmaY AS F64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_two_sample_z_stat", F64, CDECL, "PTR,PTR,F64,F64", x, y, sigmaX, sigmaY)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_TwoSampleZP(x AS U64, y AS U64, sigmaX AS F64, sigmaY AS F64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_two_sample_z_p", F64, CDECL, "PTR,PTR,F64,F64", x, y, sigmaX, sigmaY)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_OnePropZStat(successes AS I32, n AS I32, p0 AS F64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_one_prop_z_stat", F64, CDECL, "I32,I32,F64", successes, n, p0)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_OnePropZP(successes AS I32, n AS I32, p0 AS F64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_one_prop_z_p", F64, CDECL, "I32,I32,F64", successes, n, p0)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_TwoPropZStat(s1 AS I32, n1 AS I32, s2 AS I32, n2 AS I32) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_two_prop_z_stat", F64, CDECL, "I32,I32,I32,I32", s1, n1, s2, n2)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_TwoPropZP(s1 AS I32, n1 AS I32, s2 AS I32, n2 AS I32) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_two_prop_z_p", F64, CDECL, "I32,I32,I32,I32", s1, n1, s2, n2)
    RETURN r
END FUNCTION

' --- chi-square / F / ANOVA / posthoc ---
FUNCTION UXSTATS2_FVarianceStat(x AS U64, y AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_f_variance_stat", F64, CDECL, "PTR,PTR", x, y)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_FVarianceP(x AS U64, y AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_f_variance_p", F64, CDECL, "PTR,PTR", x, y)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_ChiSquareGOFStat(obs AS U64, expected AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_chisq_gof_stat", F64, CDECL, "PTR,PTR", obs, expected)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_ChiSquareGOFP(obs AS U64, expected AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_chisq_gof_p", F64, CDECL, "PTR,PTR", obs, expected)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_ChiSquare2x2Stat(a AS F64, b AS F64, c AS F64, d AS F64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_chisq_2x2_stat", F64, CDECL, "F64,F64,F64,F64", a, b, c, d)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_ChiSquare2x2P(a AS F64, b AS F64, c AS F64, d AS F64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_chisq_2x2_p", F64, CDECL, "F64,F64,F64,F64", a, b, c, d)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_AnovaOneWayF(values AS U64, groups AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_anova_oneway_f", F64, CDECL, "PTR,PTR", values, groups)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_AnovaOneWayP(values AS U64, groups AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_anova_oneway_p", F64, CDECL, "PTR,PTR", values, groups)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_PosthocBonferroniTP(values AS U64, groups AS U64, g1 AS F64, g2 AS F64, comparisons AS I32) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_posthoc_bonferroni_t_p", F64, CDECL, "PTR,PTR,F64,F64,I32", values, groups, g1, g2, comparisons)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_PosthocTukeyQ(values AS U64, groups AS U64, g1 AS F64, g2 AS F64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_posthoc_tukey_q", F64, CDECL, "PTR,PTR,F64,F64", values, groups, g1, g2)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_PosthocScheffeF(values AS U64, groups AS U64, g1 AS F64, g2 AS F64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_posthoc_scheffe_f", F64, CDECL, "PTR,PTR,F64,F64", values, groups, g1, g2)
    RETURN r
END FUNCTION

' --- regression / covariance / multivariate / time series ---
FUNCTION UXSTATS2_CovarianceSamp(x AS U64, y AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_covariance_samp", F64, CDECL, "PTR,PTR", x, y)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_Correlation(x AS U64, y AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_correlation", F64, CDECL, "PTR,PTR", x, y)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_RegressionSlope(x AS U64, y AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_regression_slope", F64, CDECL, "PTR,PTR", x, y)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_RegressionIntercept(x AS U64, y AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_regression_intercept", F64, CDECL, "PTR,PTR", x, y)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_RegressionR2(x AS U64, y AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_regression_r2", F64, CDECL, "PTR,PTR", x, y)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_RegressionF(x AS U64, y AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_regression_f", F64, CDECL, "PTR,PTR", x, y)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_RegressionFP(x AS U64, y AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_regression_f_p", F64, CDECL, "PTR,PTR", x, y)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_VIFPair(x AS U64, y AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_vif_pair", F64, CDECL, "PTR,PTR", x, y)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_DurbinWatson(resid AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_durbin_watson", F64, CDECL, "PTR", resid)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_BreuschGodfreyLM(resid AS U64, lags AS I32) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_breusch_godfrey_lm", F64, CDECL, "PTR,I32", resid, lags)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_BreuschGodfreyP(resid AS U64, lags AS I32) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_breusch_godfrey_p", F64, CDECL, "PTR,I32", resid, lags)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_ADFStat(y AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_adf_stat", F64, CDECL, "PTR", y)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_ADFP(y AS U64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_adf_p_approx", F64, CDECL, "PTR", y)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_AncovaBinaryF(y AS U64, covar AS U64, groups AS U64, g1 AS F64, g2 AS F64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_ancova_binary_f", F64, CDECL, "PTR,PTR,PTR,F64,F64", y, covar, groups, g1, g2)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_AncovaBinaryP(y AS U64, covar AS U64, groups AS U64, g1 AS F64, g2 AS F64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_ancova_binary_p", F64, CDECL, "PTR,PTR,PTR,F64,F64", y, covar, groups, g1, g2)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_HotellingT2_2D(x1 AS U64, x2 AS U64, groups AS U64, g1 AS F64, g2 AS F64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_hotelling_t2_2d", F64, CDECL, "PTR,PTR,PTR,F64,F64", x1, x2, groups, g1, g2)
    RETURN r
END FUNCTION

FUNCTION UXSTATS2_HotellingP_2D(x1 AS U64, x2 AS U64, groups AS U64, g1 AS F64, g2 AS F64) AS F64
    DIM r AS F64
    r = CALL(DLL, "uxstats2.dll", "uxstats2_hotelling_p_2d", F64, CDECL, "PTR,PTR,PTR,F64,F64", x1, x2, groups, g1, g2)
    RETURN r
END FUNCTION
