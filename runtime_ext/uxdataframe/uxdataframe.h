#ifndef UXDATAFRAME_H
#define UXDATAFRAME_H
#ifdef __cplusplus
extern "C" {
#endif

#ifdef _WIN32
#define UXDF_API __declspec(dllexport)
#else
#define UXDF_API
#endif

UXDF_API int uxdf_runtime_version(void);
UXDF_API int uxdf_duckdb_available(void);
UXDF_API const char* uxdf_duckdb_version(void);
UXDF_API const char* uxdf_last_error(void* df);

UXDF_API void* uxdf_open_memory(void);
UXDF_API void* uxdf_open_database(const char* path);
UXDF_API void  uxdf_free(void* df);

UXDF_API void* uxdf_load_csv(const char* path, int header);
UXDF_API void* uxdf_load_parquet(const char* path);
UXDF_API int   uxdf_exec(void* df, const char* sql);
UXDF_API void* uxdf_query(void* df, const char* sql);

UXDF_API long long uxdf_row_count(void* df);
UXDF_API int       uxdf_col_count(void* df);
UXDF_API const char* uxdf_col_name(void* df, int col);
UXDF_API double    uxdf_get_f64(void* df, long long row, int col);
UXDF_API const char* uxdf_get_text(void* df, long long row, int col);

UXDF_API void* uxdf_head(void* df, long long n);
UXDF_API void* uxdf_select(void* df, const char* columns);
UXDF_API void* uxdf_filter(void* df, const char* where_sql);
UXDF_API void* uxdf_order_by(void* df, const char* order_sql);
UXDF_API void* uxdf_describe(void* df);
UXDF_API void* uxdf_group_mean(void* df, const char* group_col, const char* value_col);
UXDF_API void* uxdf_join_inner(void* left, void* right, const char* left_key, const char* right_key);

UXDF_API int uxdf_to_csv(void* df, const char* path);
UXDF_API int uxdf_to_parquet(void* df, const char* path);

UXDF_API void* uxdf_to_f64_matrix(void* df);
UXDF_API void  uxdf_matrix_free(void* m);
UXDF_API long long uxdf_matrix_rows(void* m);
UXDF_API int uxdf_matrix_cols(void* m);
UXDF_API double* uxdf_matrix_data_ptr(void* m);
UXDF_API double uxdf_matrix_get(void* m, long long row, int col);

#ifdef __cplusplus
}
#endif
#endif
