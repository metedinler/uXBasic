#ifndef UXDATASET_H
#define UXDATASET_H
#ifdef __cplusplus
extern "C" {
#endif

#ifdef _WIN32
#define UXD_EXPORT __declspec(dllexport)
#else
#define UXD_EXPORT
#endif

UXD_EXPORT int uxdataset_version(void);
UXD_EXPORT const char* uxdataset_backend(void);

UXD_EXPORT void* uxdataset_create(int rows, int input_dim, int target_dim);
UXD_EXPORT void uxdataset_free(void* ds);
UXD_EXPORT void* uxdataset_clone(void* ds);
UXD_EXPORT void* uxdataset_load_csv(const char* path, int input_dim, int target_dim, int has_header);
UXD_EXPORT int uxdataset_save_csv(void* ds, const char* path);

UXD_EXPORT int uxdataset_row_count(void* ds);
UXD_EXPORT int uxdataset_input_dim(void* ds);
UXD_EXPORT int uxdataset_target_dim(void* ds);
UXD_EXPORT double* uxdataset_x_ptr(void* ds);
UXD_EXPORT double* uxdataset_y_ptr(void* ds);
UXD_EXPORT double uxdataset_get_x(void* ds, int row, int col);
UXD_EXPORT void uxdataset_set_x(void* ds, int row, int col, double value);
UXD_EXPORT double uxdataset_get_y(void* ds, int row, int col);
UXD_EXPORT void uxdataset_set_y(void* ds, int row, int col, double value);

UXD_EXPORT void uxdataset_shuffle(void* ds, unsigned long long seed);
UXD_EXPORT void* uxdataset_split_train(void* ds, double train_ratio, unsigned long long seed);
UXD_EXPORT void* uxdataset_split_test(void* ds, double train_ratio, unsigned long long seed);

UXD_EXPORT void* uxdataset_scaler_fit_standard(void* ds);
UXD_EXPORT void* uxdataset_scaler_fit_minmax(void* ds);
UXD_EXPORT void uxdataset_scaler_free(void* sc);
UXD_EXPORT void uxdataset_scaler_transform(void* sc, void* ds);
UXD_EXPORT void uxdataset_scaler_inverse_transform(void* sc, void* ds);
UXD_EXPORT void uxdataset_fill_missing_mean(void* ds);

UXD_EXPORT void* uxdataset_batch_create(void* ds, int batch_size, int shuffle, unsigned long long seed);
UXD_EXPORT void uxdataset_batch_free(void* loader);
UXD_EXPORT void uxdataset_batch_reset(void* loader);
UXD_EXPORT int uxdataset_batch_next(void* loader);
UXD_EXPORT int uxdataset_batch_rows(void* loader);
UXD_EXPORT double* uxdataset_batch_x_ptr(void* loader);
UXD_EXPORT double* uxdataset_batch_y_ptr(void* loader);
UXD_EXPORT double uxdataset_batch_get_x(void* loader, int row, int col);
UXD_EXPORT double uxdataset_batch_get_y(void* loader, int row, int col);

#ifdef __cplusplus
}
#endif
#endif
