/*
  UXGSL: a deliberately narrow, ABI10-safe facade for GNU Scientific Library.

  Raw GSL structs, callbacks and error handlers are not exported to uXBasic.
  Opaque vector/RNG pointers stay within this DLL and every public entry point
  uses only C ABI10 scalar or pointer values.
*/

#include "uxgsl.h"

#include <math.h>
#include <stddef.h>
#include <stdlib.h>

#if defined(_WIN32)
#include <windows.h>
#endif

#include <gsl/gsl_errno.h>
#include <gsl/gsl_blas.h>
#include <gsl/gsl_complex.h>
#include <gsl/gsl_complex_math.h>
#include <gsl/gsl_integration.h>
#include <gsl/gsl_matrix.h>
#include <gsl/gsl_randist.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_roots.h>
#include <gsl/gsl_sf_bessel.h>
#include <gsl/gsl_sf_erf.h>
#include <gsl/gsl_sf_gamma.h>
#include <gsl/gsl_statistics_double.h>
#include <gsl/gsl_vector.h>
#include <gsl/gsl_version.h>

static int uxgsl_initialized = 0;

enum {
    UXGSL_HANDLE_RNG = 1,
    UXGSL_HANDLE_VECTOR = 2,
    UXGSL_HANDLE_MATRIX = 3,
    UXGSL_HANDLE_INTEGRATION_WORKSPACE = 4,
    UXGSL_HANDLE_COMPLEX = 5,
    UXGSL_HANDLE_ROOT_BISECTION = 6
};

typedef struct uxgsl_complex_value {
    gsl_complex value;
} uxgsl_complex_value;

typedef struct uxgsl_root_bisection {
    gsl_root_fsolver *solver;
    gsl_function function;
    int configured;
} uxgsl_root_bisection;

typedef struct uxgsl_handle_node {
    void *pointer;
    int kind;
    struct uxgsl_handle_node *next;
} uxgsl_handle_node;

#if defined(_MSC_VER)
#define UXGSL_THREAD_LOCAL __declspec(thread)
#elif defined(__GNUC__)
#define UXGSL_THREAD_LOCAL __thread
#else
#define UXGSL_THREAD_LOCAL
#endif

/* A typed UXGSL handle must be created by this facade.  This guards normal
 * user code against a use-after-free or accidentally passing a raw GSL
 * pointer to the typed API.  Raw uxcapi calls deliberately stay separate. */
static uxgsl_handle_node *uxgsl_handles = NULL;
#if defined(_WIN32)
/* The DLL targets Windows x64. The registry protects ownership bookkeeping
 * between threads; callers must still not operate on the same handle while
 * another thread frees or mutates that handle. */
static SRWLOCK uxgsl_handle_registry_lock = SRWLOCK_INIT;
#endif
static UXGSL_THREAD_LOCAL int32_t uxgsl_status = UXGSL_STATUS_OK;
static UXGSL_THREAD_LOCAL int32_t uxgsl_gsl_status = GSL_SUCCESS;
static UXGSL_THREAD_LOCAL double uxgsl_estimated_error = NAN;

static void uxgsl_set_status(int32_t status) {
    uxgsl_status = status;
}

static void uxgsl_set_gsl_status(int gsl_status) {
    uxgsl_gsl_status = gsl_status;
    if (gsl_status == GSL_SUCCESS) {
        uxgsl_set_status(UXGSL_STATUS_OK);
    } else if (gsl_status == GSL_EDOM) {
        uxgsl_set_status(UXGSL_STATUS_DOMAIN_ERROR);
    } else if (gsl_status == GSL_ERANGE) {
        uxgsl_set_status(UXGSL_STATUS_RANGE_ERROR);
    } else {
        uxgsl_set_status(UXGSL_STATUS_BACKEND_ERROR);
    }
}

static int uxgsl_register_handle(void *pointer, int kind) {
    uxgsl_handle_node *node;
    if (pointer == NULL) return 0;
    node = (uxgsl_handle_node *)malloc(sizeof(*node));
    if (node == NULL) return 0;
    node->pointer = pointer;
    node->kind = kind;
#if defined(_WIN32)
    AcquireSRWLockExclusive(&uxgsl_handle_registry_lock);
#endif
    node->next = uxgsl_handles;
    uxgsl_handles = node;
#if defined(_WIN32)
    ReleaseSRWLockExclusive(&uxgsl_handle_registry_lock);
#endif
    return 1;
}

static int uxgsl_has_handle(const void *pointer, int kind) {
    const uxgsl_handle_node *node;
    int found = 0;
#if defined(_WIN32)
    AcquireSRWLockShared(&uxgsl_handle_registry_lock);
#endif
    for (node = uxgsl_handles; node != NULL; node = node->next) {
        if (node->pointer == pointer && node->kind == kind) {
            found = 1;
            break;
        }
    }
#if defined(_WIN32)
    ReleaseSRWLockShared(&uxgsl_handle_registry_lock);
#endif
    return found;
}

static void *uxgsl_take_handle(void *pointer, int kind) {
    uxgsl_handle_node **link = &uxgsl_handles;
#if defined(_WIN32)
    AcquireSRWLockExclusive(&uxgsl_handle_registry_lock);
#endif
    while (*link != NULL) {
        uxgsl_handle_node *node = *link;
        if (node->pointer == pointer && node->kind == kind) {
            *link = node->next;
            free(node);
#if defined(_WIN32)
            ReleaseSRWLockExclusive(&uxgsl_handle_registry_lock);
#endif
            return pointer;
        }
        link = &node->next;
    }
#if defined(_WIN32)
    ReleaseSRWLockExclusive(&uxgsl_handle_registry_lock);
#endif
    return NULL;
}

static void uxgsl_initialize(void) {
    if (!uxgsl_initialized) {
        /* Never let a recoverable GSL domain error terminate the host process. */
        gsl_set_error_handler_off();
        uxgsl_initialized = 1;
    }
}

static gsl_vector *uxgsl_as_vector(void *handle) {
    return (gsl_vector *)handle;
}

static gsl_rng *uxgsl_as_rng(void *handle) {
    return (gsl_rng *)handle;
}

static gsl_matrix *uxgsl_as_matrix(void *handle) {
    return (gsl_matrix *)handle;
}

static gsl_integration_workspace *uxgsl_as_integration_workspace(void *handle) {
    return (gsl_integration_workspace *)handle;
}

static uxgsl_complex_value *uxgsl_as_complex(void *handle) {
    return (uxgsl_complex_value *)handle;
}

static uxgsl_root_bisection *uxgsl_as_root_bisection(void *handle) {
    return (uxgsl_root_bisection *)handle;
}

static int uxgsl_valid_vector_index(const gsl_vector *vector, int32_t index) {
    return vector != NULL && index >= 0 && (size_t)index < vector->size;
}

static int uxgsl_valid_matrix_index(const gsl_matrix *matrix, int32_t row, int32_t column) {
    return matrix != NULL && row >= 0 && column >= 0 &&
        (size_t)row < matrix->size1 && (size_t)column < matrix->size2;
}

int32_t uxgsl_api_version(void) {
    return 106;
}

int32_t uxgsl_available(void) {
    uxgsl_initialize();
    uxgsl_set_gsl_status(GSL_SUCCESS);
    return 1;
}

const char *uxgsl_gsl_version(void) {
    uxgsl_set_gsl_status(GSL_SUCCESS);
    return gsl_version;
}

int32_t uxgsl_self_test(void) {
    const double epsilon = 1e-12;
    uxgsl_initialize();
    if (fabs(gsl_sf_bessel_J0(0.0) - 1.0) > epsilon) {
        uxgsl_set_status(UXGSL_STATUS_BACKEND_ERROR);
        return 0;
    }
    if (fabs(gsl_sf_gamma(5.0) - 24.0) > epsilon) {
        uxgsl_set_status(UXGSL_STATUS_BACKEND_ERROR);
        return 0;
    }
    uxgsl_set_gsl_status(GSL_SUCCESS);
    return 1;
}

int32_t uxgsl_last_status(void) {
    return uxgsl_status;
}

int32_t uxgsl_last_gsl_status(void) {
    return uxgsl_gsl_status;
}

const char *uxgsl_status_text(int32_t status) {
    switch (status) {
        case UXGSL_STATUS_OK: return "ok";
        case UXGSL_STATUS_INVALID_ARGUMENT: return "invalid argument";
        case UXGSL_STATUS_ALLOCATION_FAILED: return "allocation failed";
        case UXGSL_STATUS_INVALID_HANDLE: return "invalid or released UXGSL handle";
        case UXGSL_STATUS_OUT_OF_RANGE: return "index out of range";
        case UXGSL_STATUS_DOMAIN_ERROR: return "GSL domain error";
        case UXGSL_STATUS_RANGE_ERROR: return "GSL range error";
        case UXGSL_STATUS_BACKEND_ERROR: return "GSL backend error";
        case UXGSL_STATUS_SHAPE_MISMATCH: return "matrix shape mismatch";
        case UXGSL_STATUS_INVALID_CALLBACK: return "invalid synchronous C callback";
        default: return "unknown UXGSL status";
    }
}

const char *uxgsl_last_error(void) {
    return uxgsl_status_text(uxgsl_last_status());
}

double uxgsl_bessel_j0(double x) {
    gsl_sf_result result;
    uxgsl_initialize();
    uxgsl_set_gsl_status(gsl_sf_bessel_J0_e(x, &result));
    return uxgsl_status == UXGSL_STATUS_OK ? result.val : NAN;
}

double uxgsl_bessel_j1(double x) {
    gsl_sf_result result;
    uxgsl_initialize();
    uxgsl_set_gsl_status(gsl_sf_bessel_J1_e(x, &result));
    return uxgsl_status == UXGSL_STATUS_OK ? result.val : NAN;
}

double uxgsl_bessel_y0(double x) {
    gsl_sf_result result;
    uxgsl_initialize();
    uxgsl_set_gsl_status(gsl_sf_bessel_Y0_e(x, &result));
    return uxgsl_status == UXGSL_STATUS_OK ? result.val : NAN;
}

double uxgsl_gamma(double x) {
    gsl_sf_result result;
    uxgsl_initialize();
    uxgsl_set_gsl_status(gsl_sf_gamma_e(x, &result));
    return uxgsl_status == UXGSL_STATUS_OK ? result.val : NAN;
}

double uxgsl_lngamma(double x) {
    gsl_sf_result result;
    uxgsl_initialize();
    uxgsl_set_gsl_status(gsl_sf_lngamma_e(x, &result));
    return uxgsl_status == UXGSL_STATUS_OK ? result.val : NAN;
}

double uxgsl_erf(double x) {
    gsl_sf_result result;
    uxgsl_initialize();
    uxgsl_set_gsl_status(gsl_sf_erf_e(x, &result));
    return uxgsl_status == UXGSL_STATUS_OK ? result.val : NAN;
}

double uxgsl_gaussian_pdf(double x, double sigma) {
    uxgsl_initialize();
    if (sigma <= 0.0) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_ARGUMENT);
        return NAN;
    }
    uxgsl_set_gsl_status(GSL_SUCCESS);
    return gsl_ran_gaussian_pdf(x, sigma);
}

void *uxgsl_rng_create(uint64_t seed) {
    gsl_rng *rng;
    uxgsl_initialize();
    gsl_rng_env_setup();
    rng = gsl_rng_alloc(gsl_rng_mt19937);
    if (rng == NULL) {
        uxgsl_set_status(UXGSL_STATUS_ALLOCATION_FAILED);
        return NULL;
    }
    gsl_rng_set(rng, (unsigned long)seed);
    if (!uxgsl_register_handle(rng, UXGSL_HANDLE_RNG)) {
        gsl_rng_free(rng);
        uxgsl_set_status(UXGSL_STATUS_ALLOCATION_FAILED);
        return NULL;
    }
    uxgsl_set_gsl_status(GSL_SUCCESS);
    return rng;
}

void uxgsl_rng_free(void *handle) {
    void *owned = uxgsl_take_handle(handle, UXGSL_HANDLE_RNG);
    if (owned == NULL) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_HANDLE);
        return;
    }
    gsl_rng_free(uxgsl_as_rng(owned));
    uxgsl_set_gsl_status(GSL_SUCCESS);
}

double uxgsl_rng_uniform(void *handle) {
    if (!uxgsl_has_handle(handle, UXGSL_HANDLE_RNG)) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_HANDLE);
        return NAN;
    }
    uxgsl_set_gsl_status(GSL_SUCCESS);
    return gsl_rng_uniform(uxgsl_as_rng(handle));
}

double uxgsl_rng_gaussian(void *handle, double sigma) {
    if (!uxgsl_has_handle(handle, UXGSL_HANDLE_RNG)) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_HANDLE);
        return NAN;
    }
    if (sigma < 0.0) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_ARGUMENT);
        return NAN;
    }
    uxgsl_set_gsl_status(GSL_SUCCESS);
    return gsl_ran_gaussian(uxgsl_as_rng(handle), sigma);
}

void *uxgsl_vector_create(int32_t count) {
    uxgsl_initialize();
    gsl_vector *vector;
    if (count < 0) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_ARGUMENT);
        return NULL;
    }
    vector = gsl_vector_calloc((size_t)count);
    if (vector == NULL) {
        uxgsl_set_status(UXGSL_STATUS_ALLOCATION_FAILED);
        return NULL;
    }
    if (!uxgsl_register_handle(vector, UXGSL_HANDLE_VECTOR)) {
        gsl_vector_free(vector);
        uxgsl_set_status(UXGSL_STATUS_ALLOCATION_FAILED);
        return NULL;
    }
    uxgsl_set_gsl_status(GSL_SUCCESS);
    return vector;
}

void uxgsl_vector_free(void *handle) {
    void *owned = uxgsl_take_handle(handle, UXGSL_HANDLE_VECTOR);
    if (owned == NULL) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_HANDLE);
        return;
    }
    gsl_vector_free(uxgsl_as_vector(owned));
    uxgsl_set_gsl_status(GSL_SUCCESS);
}

int32_t uxgsl_vector_size(void *handle) {
    const gsl_vector *vector = uxgsl_as_vector(handle);
    if (!uxgsl_has_handle(handle, UXGSL_HANDLE_VECTOR)) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_HANDLE);
        return 0;
    }
    if (vector->size > INT32_MAX) {
        uxgsl_set_status(UXGSL_STATUS_RANGE_ERROR);
        return 0;
    }
    uxgsl_set_gsl_status(GSL_SUCCESS);
    return (int32_t)vector->size;
}

int32_t uxgsl_vector_set(void *handle, int32_t index, double value) {
    gsl_vector *vector = uxgsl_as_vector(handle);
    if (!uxgsl_has_handle(handle, UXGSL_HANDLE_VECTOR)) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_HANDLE);
        return 0;
    }
    if (!uxgsl_valid_vector_index(vector, index)) {
        uxgsl_set_status(UXGSL_STATUS_OUT_OF_RANGE);
        return 0;
    }
    gsl_vector_set(vector, (size_t)index, value);
    uxgsl_set_gsl_status(GSL_SUCCESS);
    return 1;
}

double uxgsl_vector_get(void *handle, int32_t index) {
    const gsl_vector *vector = uxgsl_as_vector(handle);
    if (!uxgsl_has_handle(handle, UXGSL_HANDLE_VECTOR)) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_HANDLE);
        return NAN;
    }
    if (!uxgsl_valid_vector_index(vector, index)) {
        uxgsl_set_status(UXGSL_STATUS_OUT_OF_RANGE);
        return NAN;
    }
    uxgsl_set_gsl_status(GSL_SUCCESS);
    return gsl_vector_get(vector, (size_t)index);
}

double uxgsl_vector_mean(void *handle) {
    const gsl_vector *vector = uxgsl_as_vector(handle);
    if (!uxgsl_has_handle(handle, UXGSL_HANDLE_VECTOR)) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_HANDLE);
        return NAN;
    }
    if (vector->size == 0) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_ARGUMENT);
        return NAN;
    }
    uxgsl_set_gsl_status(GSL_SUCCESS);
    return gsl_stats_mean(vector->data, vector->stride, vector->size);
}

double uxgsl_vector_sd(void *handle) {
    const gsl_vector *vector = uxgsl_as_vector(handle);
    if (!uxgsl_has_handle(handle, UXGSL_HANDLE_VECTOR)) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_HANDLE);
        return NAN;
    }
    if (vector->size < 2) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_ARGUMENT);
        return NAN;
    }
    uxgsl_set_gsl_status(GSL_SUCCESS);
    return gsl_stats_sd(vector->data, vector->stride, vector->size);
}

double uxgsl_vector_variance(void *handle) {
    const gsl_vector *vector = uxgsl_as_vector(handle);
    if (!uxgsl_has_handle(handle, UXGSL_HANDLE_VECTOR)) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_HANDLE);
        return NAN;
    }
    if (vector->size < 2) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_ARGUMENT);
        return NAN;
    }
    uxgsl_set_gsl_status(GSL_SUCCESS);
    return gsl_stats_variance(vector->data, vector->stride, vector->size);
}

void *uxgsl_matrix_create(int32_t rows, int32_t columns) {
    gsl_matrix *matrix;
    uxgsl_initialize();
    if (rows < 0 || columns < 0) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_ARGUMENT);
        return NULL;
    }
    matrix = gsl_matrix_calloc((size_t)rows, (size_t)columns);
    if (matrix == NULL) {
        uxgsl_set_status(UXGSL_STATUS_ALLOCATION_FAILED);
        return NULL;
    }
    if (!uxgsl_register_handle(matrix, UXGSL_HANDLE_MATRIX)) {
        gsl_matrix_free(matrix);
        uxgsl_set_status(UXGSL_STATUS_ALLOCATION_FAILED);
        return NULL;
    }
    uxgsl_set_gsl_status(GSL_SUCCESS);
    return matrix;
}

void uxgsl_matrix_free(void *handle) {
    void *owned = uxgsl_take_handle(handle, UXGSL_HANDLE_MATRIX);
    if (owned == NULL) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_HANDLE);
        return;
    }
    gsl_matrix_free(uxgsl_as_matrix(owned));
    uxgsl_set_gsl_status(GSL_SUCCESS);
}

int32_t uxgsl_matrix_rows(void *handle) {
    const gsl_matrix *matrix = uxgsl_as_matrix(handle);
    if (!uxgsl_has_handle(handle, UXGSL_HANDLE_MATRIX)) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_HANDLE);
        return 0;
    }
    if (matrix->size1 > INT32_MAX) {
        uxgsl_set_status(UXGSL_STATUS_RANGE_ERROR);
        return 0;
    }
    uxgsl_set_gsl_status(GSL_SUCCESS);
    return (int32_t)matrix->size1;
}

int32_t uxgsl_matrix_columns(void *handle) {
    const gsl_matrix *matrix = uxgsl_as_matrix(handle);
    if (!uxgsl_has_handle(handle, UXGSL_HANDLE_MATRIX)) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_HANDLE);
        return 0;
    }
    if (matrix->size2 > INT32_MAX) {
        uxgsl_set_status(UXGSL_STATUS_RANGE_ERROR);
        return 0;
    }
    uxgsl_set_gsl_status(GSL_SUCCESS);
    return (int32_t)matrix->size2;
}

int32_t uxgsl_matrix_set(void *handle, int32_t row, int32_t column, double value) {
    gsl_matrix *matrix = uxgsl_as_matrix(handle);
    if (!uxgsl_has_handle(handle, UXGSL_HANDLE_MATRIX)) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_HANDLE);
        return 0;
    }
    if (!uxgsl_valid_matrix_index(matrix, row, column)) {
        uxgsl_set_status(UXGSL_STATUS_OUT_OF_RANGE);
        return 0;
    }
    gsl_matrix_set(matrix, (size_t)row, (size_t)column, value);
    uxgsl_set_gsl_status(GSL_SUCCESS);
    return 1;
}

double uxgsl_matrix_get(void *handle, int32_t row, int32_t column) {
    const gsl_matrix *matrix = uxgsl_as_matrix(handle);
    if (!uxgsl_has_handle(handle, UXGSL_HANDLE_MATRIX)) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_HANDLE);
        return NAN;
    }
    if (!uxgsl_valid_matrix_index(matrix, row, column)) {
        uxgsl_set_status(UXGSL_STATUS_OUT_OF_RANGE);
        return NAN;
    }
    uxgsl_set_gsl_status(GSL_SUCCESS);
    return gsl_matrix_get(matrix, (size_t)row, (size_t)column);
}

int32_t uxgsl_matrix_set_zero(void *handle) {
    gsl_matrix *matrix = uxgsl_as_matrix(handle);
    if (!uxgsl_has_handle(handle, UXGSL_HANDLE_MATRIX)) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_HANDLE);
        return 0;
    }
    gsl_matrix_set_zero(matrix);
    uxgsl_set_gsl_status(GSL_SUCCESS);
    return 1;
}

int32_t uxgsl_matrix_set_identity(void *handle) {
    gsl_matrix *matrix = uxgsl_as_matrix(handle);
    if (!uxgsl_has_handle(handle, UXGSL_HANDLE_MATRIX)) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_HANDLE);
        return 0;
    }
    if (matrix->size1 != matrix->size2) {
        uxgsl_set_status(UXGSL_STATUS_SHAPE_MISMATCH);
        return 0;
    }
    gsl_matrix_set_identity(matrix);
    uxgsl_set_gsl_status(GSL_SUCCESS);
    return 1;
}

int32_t uxgsl_matrix_multiply(void *left_handle, void *right_handle, void *output_handle) {
    const gsl_matrix *left = uxgsl_as_matrix(left_handle);
    const gsl_matrix *right = uxgsl_as_matrix(right_handle);
    gsl_matrix *output = uxgsl_as_matrix(output_handle);
    int gsl_status;
    if (!uxgsl_has_handle(left_handle, UXGSL_HANDLE_MATRIX) ||
        !uxgsl_has_handle(right_handle, UXGSL_HANDLE_MATRIX) ||
        !uxgsl_has_handle(output_handle, UXGSL_HANDLE_MATRIX)) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_HANDLE);
        return 0;
    }
    if (left->size2 != right->size1 || output->size1 != left->size1 ||
        output->size2 != right->size2 || output == left || output == right) {
        uxgsl_set_status(UXGSL_STATUS_SHAPE_MISMATCH);
        return 0;
    }
    gsl_status = gsl_blas_dgemm(CblasNoTrans, CblasNoTrans, 1.0, left, right, 0.0, output);
    uxgsl_set_gsl_status(gsl_status);
    return uxgsl_status == UXGSL_STATUS_OK ? 1 : 0;
}

void *uxgsl_integration_workspace_create(int32_t limit) {
    gsl_integration_workspace *workspace;
    uxgsl_initialize();
    if (limit <= 0) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_ARGUMENT);
        return NULL;
    }
    workspace = gsl_integration_workspace_alloc((size_t)limit);
    if (workspace == NULL) {
        uxgsl_set_status(UXGSL_STATUS_ALLOCATION_FAILED);
        return NULL;
    }
    if (!uxgsl_register_handle(workspace, UXGSL_HANDLE_INTEGRATION_WORKSPACE)) {
        gsl_integration_workspace_free(workspace);
        uxgsl_set_status(UXGSL_STATUS_ALLOCATION_FAILED);
        return NULL;
    }
    uxgsl_set_gsl_status(GSL_SUCCESS);
    return workspace;
}

void uxgsl_integration_workspace_free(void *handle) {
    void *owned = uxgsl_take_handle(handle, UXGSL_HANDLE_INTEGRATION_WORKSPACE);
    if (owned == NULL) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_HANDLE);
        return;
    }
    gsl_integration_workspace_free(uxgsl_as_integration_workspace(owned));
    uxgsl_set_gsl_status(GSL_SUCCESS);
}

double uxgsl_integrate_qag(void *callback, void *user_data,
    double lower, double upper, double absolute_tolerance,
    double relative_tolerance, int32_t limit, int32_t key, void *workspace_handle) {
    gsl_function function;
    gsl_integration_workspace *workspace = uxgsl_as_integration_workspace(workspace_handle);
    double result = NAN;
    double estimated_error = NAN;
    int gsl_status;
    uxgsl_initialize();
    uxgsl_estimated_error = NAN;
    if (callback == NULL) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_CALLBACK);
        return NAN;
    }
    if (!uxgsl_has_handle(workspace_handle, UXGSL_HANDLE_INTEGRATION_WORKSPACE)) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_HANDLE);
        return NAN;
    }
    if (limit <= 0 || (size_t)limit > workspace->limit || absolute_tolerance < 0.0 || relative_tolerance < 0.0 ||
        (absolute_tolerance == 0.0 && relative_tolerance == 0.0) || key < 1 || key > 6) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_ARGUMENT);
        return NAN;
    }
    function.function = (double (*)(double, void *))callback;
    function.params = user_data;
    gsl_status = gsl_integration_qag(&function, lower, upper, absolute_tolerance,
        relative_tolerance, (size_t)limit, key, workspace, &result, &estimated_error);
    uxgsl_estimated_error = estimated_error;
    uxgsl_set_gsl_status(gsl_status);
    return uxgsl_status == UXGSL_STATUS_OK ? result : NAN;
}

double uxgsl_last_estimated_error(void) {
    return uxgsl_estimated_error;
}

void *uxgsl_root_bisection_create(void) {
    uxgsl_root_bisection *root;
    uxgsl_initialize();
    root = (uxgsl_root_bisection *)calloc(1, sizeof(*root));
    if (root == NULL) {
        uxgsl_set_status(UXGSL_STATUS_ALLOCATION_FAILED);
        return NULL;
    }
    root->solver = gsl_root_fsolver_alloc(gsl_root_fsolver_bisection);
    if (root->solver == NULL) {
        free(root);
        uxgsl_set_status(UXGSL_STATUS_ALLOCATION_FAILED);
        return NULL;
    }
    if (!uxgsl_register_handle(root, UXGSL_HANDLE_ROOT_BISECTION)) {
        gsl_root_fsolver_free(root->solver);
        free(root);
        uxgsl_set_status(UXGSL_STATUS_ALLOCATION_FAILED);
        return NULL;
    }
    uxgsl_set_gsl_status(GSL_SUCCESS);
    return root;
}

void uxgsl_root_bisection_free(void *handle) {
    uxgsl_root_bisection *root = (uxgsl_root_bisection *)uxgsl_take_handle(handle, UXGSL_HANDLE_ROOT_BISECTION);
    if (root == NULL) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_HANDLE);
        return;
    }
    gsl_root_fsolver_free(root->solver);
    free(root);
    uxgsl_set_gsl_status(GSL_SUCCESS);
}

int32_t uxgsl_root_bisection_set(void *handle, void *callback, void *user_data,
    double lower, double upper) {
    uxgsl_root_bisection *root = uxgsl_as_root_bisection(handle);
    int gsl_status;
    uxgsl_initialize();
    if (!uxgsl_has_handle(handle, UXGSL_HANDLE_ROOT_BISECTION)) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_HANDLE);
        return 0;
    }
    if (callback == NULL) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_CALLBACK);
        return 0;
    }
    if (!isfinite(lower) || !isfinite(upper) || lower >= upper) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_ARGUMENT);
        return 0;
    }
    root->function.function = (double (*)(double, void *))callback;
    root->function.params = user_data;
    gsl_status = gsl_root_fsolver_set(root->solver, &root->function, lower, upper);
    root->configured = gsl_status == GSL_SUCCESS;
    uxgsl_set_gsl_status(gsl_status);
    return uxgsl_status == UXGSL_STATUS_OK ? 1 : 0;
}

int32_t uxgsl_root_bisection_iterate(void *handle) {
    uxgsl_root_bisection *root = uxgsl_as_root_bisection(handle);
    int gsl_status;
    if (!uxgsl_has_handle(handle, UXGSL_HANDLE_ROOT_BISECTION)) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_HANDLE);
        return 0;
    }
    if (!root->configured) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_ARGUMENT);
        return 0;
    }
    gsl_status = gsl_root_fsolver_iterate(root->solver);
    uxgsl_set_gsl_status(gsl_status);
    return uxgsl_status == UXGSL_STATUS_OK ? 1 : 0;
}

static double uxgsl_root_bisection_bound(void *handle, int upper) {
    uxgsl_root_bisection *root = uxgsl_as_root_bisection(handle);
    if (!uxgsl_has_handle(handle, UXGSL_HANDLE_ROOT_BISECTION)) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_HANDLE);
        return NAN;
    }
    if (!root->configured) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_ARGUMENT);
        return NAN;
    }
    uxgsl_set_gsl_status(GSL_SUCCESS);
    return upper ? gsl_root_fsolver_x_upper(root->solver) : gsl_root_fsolver_x_lower(root->solver);
}

double uxgsl_root_bisection_root(void *handle) {
    uxgsl_root_bisection *root = uxgsl_as_root_bisection(handle);
    if (!uxgsl_has_handle(handle, UXGSL_HANDLE_ROOT_BISECTION)) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_HANDLE);
        return NAN;
    }
    if (!root->configured) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_ARGUMENT);
        return NAN;
    }
    uxgsl_set_gsl_status(GSL_SUCCESS);
    return gsl_root_fsolver_root(root->solver);
}

double uxgsl_root_bisection_lower(void *handle) {
    return uxgsl_root_bisection_bound(handle, 0);
}

double uxgsl_root_bisection_upper(void *handle) {
    return uxgsl_root_bisection_bound(handle, 1);
}

int32_t uxgsl_root_bisection_interval_converged(void *handle,
    double absolute_tolerance, double relative_tolerance) {
    uxgsl_root_bisection *root = uxgsl_as_root_bisection(handle);
    int gsl_status;
    if (!uxgsl_has_handle(handle, UXGSL_HANDLE_ROOT_BISECTION)) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_HANDLE);
        return 0;
    }
    if (!root->configured || absolute_tolerance < 0.0 || relative_tolerance < 0.0 ||
        (absolute_tolerance == 0.0 && relative_tolerance == 0.0)) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_ARGUMENT);
        return 0;
    }
    gsl_status = gsl_root_test_interval(gsl_root_fsolver_x_lower(root->solver),
        gsl_root_fsolver_x_upper(root->solver), absolute_tolerance, relative_tolerance);
    if (gsl_status == GSL_SUCCESS) {
        uxgsl_set_gsl_status(GSL_SUCCESS);
        return 1;
    }
    if (gsl_status == GSL_CONTINUE) {
        uxgsl_gsl_status = GSL_CONTINUE;
        uxgsl_set_status(UXGSL_STATUS_OK);
        return 0;
    }
    uxgsl_set_gsl_status(gsl_status);
    return 0;
}

void *uxgsl_complex_create(double real, double imaginary) {
    uxgsl_complex_value *complex_value;
    uxgsl_initialize();
    complex_value = (uxgsl_complex_value *)malloc(sizeof(*complex_value));
    if (complex_value == NULL) {
        uxgsl_set_status(UXGSL_STATUS_ALLOCATION_FAILED);
        return NULL;
    }
    GSL_SET_COMPLEX(&complex_value->value, real, imaginary);
    if (!uxgsl_register_handle(complex_value, UXGSL_HANDLE_COMPLEX)) {
        free(complex_value);
        uxgsl_set_status(UXGSL_STATUS_ALLOCATION_FAILED);
        return NULL;
    }
    uxgsl_set_gsl_status(GSL_SUCCESS);
    return complex_value;
}

void uxgsl_complex_free(void *handle) {
    void *owned = uxgsl_take_handle(handle, UXGSL_HANDLE_COMPLEX);
    if (owned == NULL) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_HANDLE);
        return;
    }
    free(owned);
    uxgsl_set_gsl_status(GSL_SUCCESS);
}

double uxgsl_complex_real(void *handle) {
    uxgsl_complex_value *complex_value = uxgsl_as_complex(handle);
    if (!uxgsl_has_handle(handle, UXGSL_HANDLE_COMPLEX)) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_HANDLE);
        return NAN;
    }
    uxgsl_set_gsl_status(GSL_SUCCESS);
    return GSL_REAL(complex_value->value);
}

double uxgsl_complex_imaginary(void *handle) {
    uxgsl_complex_value *complex_value = uxgsl_as_complex(handle);
    if (!uxgsl_has_handle(handle, UXGSL_HANDLE_COMPLEX)) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_HANDLE);
        return NAN;
    }
    uxgsl_set_gsl_status(GSL_SUCCESS);
    return GSL_IMAG(complex_value->value);
}

double uxgsl_complex_abs(void *handle) {
    uxgsl_complex_value *complex_value = uxgsl_as_complex(handle);
    if (!uxgsl_has_handle(handle, UXGSL_HANDLE_COMPLEX)) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_HANDLE);
        return NAN;
    }
    uxgsl_set_gsl_status(GSL_SUCCESS);
    return gsl_complex_abs(complex_value->value);
}

static int32_t uxgsl_complex_binary(void *left_handle, void *right_handle, void *output_handle, int multiply) {
    uxgsl_complex_value *left = uxgsl_as_complex(left_handle);
    uxgsl_complex_value *right = uxgsl_as_complex(right_handle);
    uxgsl_complex_value *output = uxgsl_as_complex(output_handle);
    if (!uxgsl_has_handle(left_handle, UXGSL_HANDLE_COMPLEX) ||
        !uxgsl_has_handle(right_handle, UXGSL_HANDLE_COMPLEX) ||
        !uxgsl_has_handle(output_handle, UXGSL_HANDLE_COMPLEX)) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_HANDLE);
        return 0;
    }
    if (output == left || output == right) {
        uxgsl_set_status(UXGSL_STATUS_INVALID_ARGUMENT);
        return 0;
    }
    output->value = multiply ? gsl_complex_mul(left->value, right->value) : gsl_complex_add(left->value, right->value);
    uxgsl_set_gsl_status(GSL_SUCCESS);
    return 1;
}

int32_t uxgsl_complex_add(void *left, void *right, void *output) {
    return uxgsl_complex_binary(left, right, output, 0);
}

int32_t uxgsl_complex_multiply(void *left, void *right, void *output) {
    return uxgsl_complex_binary(left, right, output, 1);
}

/* Generated checked scalar adapters must remain in this translation unit so
 * they reuse the same GSL error policy and status contract as the hand-written
 * facade. */
#include "generated/uxgsl_scalar_auto.inc"
