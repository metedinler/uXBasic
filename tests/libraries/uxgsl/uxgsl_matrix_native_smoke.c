/* Native companion for the uXBasic matrix smoke: verifies the public DLL
 * boundary independently of compiler/backend progress. */
#include <math.h>
#include <stdio.h>

#include "../../../runtime_ext/uxgsl/uxgsl.h"

static double square_callback(double x, void *user_data) {
    (void)user_data;
    return x * x;
}

static double sqrt_two_callback(double x, void *user_data) {
    (void)user_data;
    return x * x - 2.0;
}

int main(void) {
    void *a = uxgsl_matrix_create(2, 2);
    void *b = uxgsl_matrix_create(2, 2);
    void *product = uxgsl_matrix_create(2, 2);
    void *nonsquare = uxgsl_matrix_create(2, 3);
    void *workspace = uxgsl_integration_workspace_create(1000);
    void *root = uxgsl_root_bisection_create();
    void *z1 = uxgsl_complex_create(1.0, 2.0);
    void *z2 = uxgsl_complex_create(3.0, -4.0);
    void *zout = uxgsl_complex_create(0.0, 0.0);
    double integral;
    int iteration;
    int ok = a && b && product && nonsquare && workspace && root && z1 && z2 && zout;

    ok = ok && uxgsl_api_version() >= 106;
    ok = ok && uxgsl_matrix_set(a, 0, 0, 1.0);
    ok = ok && uxgsl_matrix_set(a, 0, 1, 2.0);
    ok = ok && uxgsl_matrix_set(a, 1, 0, 3.0);
    ok = ok && uxgsl_matrix_set(a, 1, 1, 4.0);
    ok = ok && uxgsl_matrix_set(b, 0, 0, 5.0);
    ok = ok && uxgsl_matrix_set(b, 0, 1, 6.0);
    ok = ok && uxgsl_matrix_set(b, 1, 0, 7.0);
    ok = ok && uxgsl_matrix_set(b, 1, 1, 8.0);
    ok = ok && uxgsl_matrix_multiply(a, b, product);
    ok = ok && fabs(uxgsl_matrix_get(product, 0, 0) - 19.0) < 1e-12;
    ok = ok && fabs(uxgsl_matrix_get(product, 1, 1) - 50.0) < 1e-12;
    ok = ok && !uxgsl_matrix_multiply(a, b, a) &&
        uxgsl_last_status() == UXGSL_STATUS_SHAPE_MISMATCH;
    ok = ok && !uxgsl_matrix_set_identity(nonsquare) &&
        uxgsl_last_status() == UXGSL_STATUS_SHAPE_MISMATCH;
    integral = uxgsl_integrate_qag((void *)square_callback, NULL, 0.0, 1.0,
        1e-12, 1e-12, 1000, 6, workspace);
    ok = ok && fabs(integral - (1.0 / 3.0)) < 1e-10;
    ok = ok && uxgsl_last_estimated_error() < 1e-10;
    ok = ok && isnan(uxgsl_integrate_qag((void *)square_callback, NULL, 0.0, 1.0,
        1e-12, 1e-12, 1001, 6, workspace));
    ok = ok && uxgsl_last_status() == UXGSL_STATUS_INVALID_ARGUMENT;
    ok = ok && isnan(uxgsl_integrate_qag(NULL, NULL, 0.0, 1.0,
        1e-12, 1e-12, 1000, 6, workspace));
    ok = ok && uxgsl_last_status() == UXGSL_STATUS_INVALID_CALLBACK;
    ok = ok && uxgsl_root_bisection_set(root, (void *)sqrt_two_callback, NULL, 1.0, 2.0);
    for (iteration = 0; iteration < 64 && ok; ++iteration) {
        ok = uxgsl_root_bisection_iterate(root);
    }
    ok = ok && uxgsl_root_bisection_interval_converged(root, 1e-12, 1e-12);
    ok = ok && fabs(uxgsl_root_bisection_root(root) - sqrt(2.0)) < 1e-10;
    ok = ok && !uxgsl_root_bisection_set(root, (void *)square_callback, NULL, 1.0, 2.0);
    ok = ok && uxgsl_last_status() == UXGSL_STATUS_BACKEND_ERROR;
    ok = ok && uxgsl_complex_add(z1, z2, zout);
    ok = ok && fabs(uxgsl_complex_real(zout) - 4.0) < 1e-12;
    ok = ok && fabs(uxgsl_complex_imaginary(zout) + 2.0) < 1e-12;
    ok = ok && uxgsl_complex_multiply(z1, z2, zout);
    ok = ok && fabs(uxgsl_complex_real(zout) - 11.0) < 1e-12;
    ok = ok && fabs(uxgsl_complex_imaginary(zout) - 2.0) < 1e-12;

    uxgsl_complex_free(zout);
    uxgsl_complex_free(z2);
    uxgsl_complex_free(z1);
    uxgsl_root_bisection_free(root);
    uxgsl_root_bisection_free(root);
    ok = ok && uxgsl_last_status() == UXGSL_STATUS_INVALID_HANDLE;
    uxgsl_integration_workspace_free(workspace);
    uxgsl_integration_workspace_free(workspace);
    ok = ok && uxgsl_last_status() == UXGSL_STATUS_INVALID_HANDLE;
    uxgsl_matrix_free(nonsquare);
    uxgsl_matrix_free(product);
    uxgsl_matrix_free(b);
    uxgsl_matrix_free(a);
    if (!ok) {
        fprintf(stderr, "UXGSL_MATRIX_NATIVE_SMOKE_FAIL: %s\n", uxgsl_last_error());
        return 1;
    }
    puts("UXGSL_MATRIX_NATIVE_SMOKE_PASS");
    return 0;
}
