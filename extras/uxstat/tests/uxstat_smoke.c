#include "../include/uxstat.h"

#include <math.h>
#include <stdio.h>

static int nearly_equal(double a, double b, double eps) {
  double d = a - b;
  if (d < 0.0) d = -d;
  return d <= eps;
}

int main(void) {
  UxbStatVectorF64* v = NULL;
  double mean = 0.0;
  double var = 0.0;
  double std = 0.0;
  int st;

  st = uxb_vec_create_f64(4, &v);
  if (st != UXSTAT_OK) {
    printf("FAIL create: %d\n", st);
    return 1;
  }

  uxb_vec_set_f64(v, 0, 1.0);
  uxb_vec_set_f64(v, 1, 2.0);
  uxb_vec_set_f64(v, 2, 3.0);
  uxb_vec_set_f64(v, 3, 4.0);

  st = uxb_stat_mean_f64(v, &mean);
  if (st != UXSTAT_OK || !nearly_equal(mean, 2.5, 1e-12)) {
    printf("FAIL mean: st=%d mean=%.17g\n", st, mean);
    return 2;
  }

  st = uxb_stat_var_f64(v, &var);
  if (st != UXSTAT_OK || !nearly_equal(var, 1.6666666666666667, 1e-12)) {
    printf("FAIL var: st=%d var=%.17g\n", st, var);
    return 3;
  }

  st = uxb_stat_std_f64(v, &std);
  if (st != UXSTAT_OK || !nearly_equal(std, sqrt(1.6666666666666667), 1e-12)) {
    printf("FAIL std: st=%d std=%.17g\n", st, std);
    return 4;
  }

  uxb_vec_destroy_f64(v);
  printf("UXSTAT_SMOKE_OK\n");
  return 0;
}
