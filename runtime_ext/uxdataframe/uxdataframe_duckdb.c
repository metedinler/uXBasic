// uXBasic uxdataframe runtime. Primary backend: DuckDB C API loaded dynamically.
// The wrapper deliberately exposes handles and simple C ABI functions for CALL(DLL).

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <ctype.h>
#include <windows.h>
#include "duckdb.h"
#include "uxdataframe.h"

#define UXDF_NAME_MAX 96
#define UXDF_ERR_MAX 2048
#define UXDF_SQL_MAX 8192

typedef struct UXDFCtx {
    duckdb_database db;
    duckdb_connection con;
    volatile LONG refs;
} UXDFCtx;

typedef struct UXDataFrame {
    UXDFCtx* ctx;
    char table[UXDF_NAME_MAX];
    char last_error[UXDF_ERR_MAX];
} UXDataFrame;

typedef struct UXDFMatrix {
    long long rows;
    int cols;
    double* data;
} UXDFMatrix;

#if defined(_MSC_VER)
#define UXDF_THREAD_LOCAL __declspec(thread)
#else
#define UXDF_THREAD_LOCAL _Thread_local
#endif

static HMODULE g_duck = NULL;
static SRWLOCK g_duck_lock = SRWLOCK_INIT;
static UXDF_THREAD_LOCAL char g_last_error[UXDF_ERR_MAX] = "";
static volatile LONG64 g_counter = 0;
static UXDF_THREAD_LOCAL char g_tmp_text[8][4096];
static UXDF_THREAD_LOCAL unsigned int g_tmp_text_slot = 0;

static char* next_tmp_text(void) {
    char* result = g_tmp_text[g_tmp_text_slot++ % 8U];
    result[0] = 0;
    return result;
}

#define DECLARE_FN(name) static __typeof__(&name) p_##name = NULL
DECLARE_FN(duckdb_open);
DECLARE_FN(duckdb_close);
DECLARE_FN(duckdb_connect);
DECLARE_FN(duckdb_disconnect);
DECLARE_FN(duckdb_query);
DECLARE_FN(duckdb_destroy_result);
DECLARE_FN(duckdb_result_error);
DECLARE_FN(duckdb_row_count);
DECLARE_FN(duckdb_column_count);
DECLARE_FN(duckdb_column_name);
DECLARE_FN(duckdb_value_int64);
DECLARE_FN(duckdb_value_double);
DECLARE_FN(duckdb_value_varchar);
DECLARE_FN(duckdb_value_is_null);
DECLARE_FN(duckdb_free);
DECLARE_FN(duckdb_library_version);

static void set_global_error(const char* msg) {
    if (!msg) msg = "";
    strncpy(g_last_error, msg, UXDF_ERR_MAX - 1);
    g_last_error[UXDF_ERR_MAX - 1] = 0;
}

static void set_error(UXDataFrame* df, const char* msg) {
    if (df) {
        strncpy(df->last_error, msg ? msg : "", UXDF_ERR_MAX - 1);
        df->last_error[UXDF_ERR_MAX - 1] = 0;
    }
    set_global_error(msg);
}

static FARPROC load_sym(const char* name) {
    FARPROC p = GetProcAddress(g_duck, name);
    if (!p) {
        char buf[512];
        snprintf(buf, sizeof(buf), "DuckDB symbol not found: %s", name);
        set_global_error(buf);
    }
    return p;
}

static int load_duckdb(void) {
    AcquireSRWLockExclusive(&g_duck_lock);
    if (g_duck) { ReleaseSRWLockExclusive(&g_duck_lock); return 1; }
    g_duck = LoadLibraryA("duckdb.dll");
    if (!g_duck) {
        set_global_error("duckdb.dll not found. Run fetch_uxdataframe_duckdb_deps.ps1 and copy runtime deps.");
        ReleaseSRWLockExclusive(&g_duck_lock);
        return 0;
    }
#define LOAD(name) do { p_##name = (__typeof__(p_##name))load_sym(#name); if (!p_##name) goto load_failed; } while(0)
    LOAD(duckdb_open); LOAD(duckdb_close); LOAD(duckdb_connect); LOAD(duckdb_disconnect);
    LOAD(duckdb_query); LOAD(duckdb_destroy_result); LOAD(duckdb_result_error);
    LOAD(duckdb_row_count); LOAD(duckdb_column_count); LOAD(duckdb_column_name);
    LOAD(duckdb_value_int64); LOAD(duckdb_value_double); LOAD(duckdb_value_varchar);
    LOAD(duckdb_value_is_null); LOAD(duckdb_free); LOAD(duckdb_library_version);
#undef LOAD
    ReleaseSRWLockExclusive(&g_duck_lock);
    return 1;
load_failed:
    FreeLibrary(g_duck);
    g_duck = NULL;
    ReleaseSRWLockExclusive(&g_duck_lock);
    return 0;
}

static void sql_escape_path(const char* in, char* out, size_t outsz) {
    size_t j = 0;
    if (!in) in = "";
    for (size_t i = 0; in[i] && j + 3 < outsz; i++) {
        char c = in[i];
        if (c == '\\') c = '/';
        if (c == '\'') { out[j++] = '\''; out[j++] = '\''; }
        else out[j++] = c;
    }
    out[j] = 0;
}

static void next_table(char* out, size_t outsz) {
    snprintf(out, outsz, "uxdf_%lld", (long long)InterlockedIncrement64(&g_counter));
}

static int exec_sql(UXDataFrame* df, const char* sql) {
    if (!df || !df->ctx || !df->ctx->con || !sql) return 0;
    duckdb_result res;
    if (p_duckdb_query(df->ctx->con, sql, &res) != DuckDBSuccess) {
        const char* e = p_duckdb_result_error(&res);
        set_error(df, e ? e : "duckdb query failed");
        p_duckdb_destroy_result(&res);
        return 0;
    }
    p_duckdb_destroy_result(&res);
    return 1;
}

static UXDFCtx* ctx_create(const char* db_path) {
    if (!load_duckdb()) return NULL;
    UXDFCtx* c = (UXDFCtx*)calloc(1, sizeof(UXDFCtx));
    if (!c) return NULL;
    if (p_duckdb_open(db_path, &c->db) != DuckDBSuccess) { free(c); set_global_error("duckdb_open failed"); return NULL; }
    if (p_duckdb_connect(c->db, &c->con) != DuckDBSuccess) { p_duckdb_close(&c->db); free(c); set_global_error("duckdb_connect failed"); return NULL; }
    c->refs = 1;
    return c;
}

static void ctx_ref(UXDFCtx* c) { if (c) InterlockedIncrement(&c->refs); }
static void ctx_unref(UXDFCtx* c) {
    if (!c) return;
    if (InterlockedDecrement(&c->refs) == 0) {
        if (c->con) p_duckdb_disconnect(&c->con);
        if (c->db) p_duckdb_close(&c->db);
        free(c);
    }
}

static UXDataFrame* df_new(UXDFCtx* c, const char* table) {
    if (!c || !table) return NULL;
    UXDataFrame* df = (UXDataFrame*)calloc(1, sizeof(UXDataFrame));
    if (!df) return NULL;
    df->ctx = c; ctx_ref(c);
    strncpy(df->table, table, UXDF_NAME_MAX - 1);
    return df;
}

UXDF_API int uxdf_runtime_version(void) { return 1; }
UXDF_API int uxdf_duckdb_available(void) { return load_duckdb(); }
UXDF_API const char* uxdf_duckdb_version(void) { if (!load_duckdb()) return ""; return p_duckdb_library_version(); }
UXDF_API const char* uxdf_last_error(void* df_) { UXDataFrame* df=(UXDataFrame*)df_; return df ? df->last_error : g_last_error; }

UXDF_API void* uxdf_open_memory(void) {
    UXDFCtx* c = ctx_create(NULL);
    if (!c) return NULL;
    char t[UXDF_NAME_MAX]; next_table(t, sizeof(t));
    UXDataFrame* df = df_new(c, t);
    ctx_unref(c);
    return df;
}

UXDF_API void* uxdf_open_database(const char* path) {
    UXDFCtx* c = ctx_create(path && *path ? path : NULL);
    if (!c) return NULL;
    char t[UXDF_NAME_MAX]; next_table(t, sizeof(t));
    UXDataFrame* df = df_new(c, t);
    ctx_unref(c);
    return df;
}

UXDF_API void uxdf_free(void* df_) {
    UXDataFrame* df = (UXDataFrame*)df_;
    if (!df) return;
    ctx_unref(df->ctx);
    free(df);
}

UXDF_API void* uxdf_load_csv(const char* path, int header) {
    UXDFCtx* c = ctx_create(NULL);
    if (!c) return NULL;
    char t[UXDF_NAME_MAX]; next_table(t, sizeof(t));
    UXDataFrame* df = df_new(c, t);
    ctx_unref(c);
    char pth[2048], sql[UXDF_SQL_MAX]; sql_escape_path(path, pth, sizeof(pth));
    snprintf(sql, sizeof(sql), "CREATE TEMP TABLE %s AS SELECT * FROM read_csv_auto('%s', header=%s)", t, pth, header ? "true" : "false");
    if (!exec_sql(df, sql)) { uxdf_free(df); return NULL; }
    return df;
}

UXDF_API void* uxdf_load_parquet(const char* path) {
    UXDFCtx* c = ctx_create(NULL);
    if (!c) return NULL;
    char t[UXDF_NAME_MAX]; next_table(t, sizeof(t));
    UXDataFrame* df = df_new(c, t);
    ctx_unref(c);
    char pth[2048], sql[UXDF_SQL_MAX]; sql_escape_path(path, pth, sizeof(pth));
    snprintf(sql, sizeof(sql), "CREATE TEMP TABLE %s AS SELECT * FROM read_parquet('%s')", t, pth);
    if (!exec_sql(df, sql)) { uxdf_free(df); return NULL; }
    return df;
}

UXDF_API int uxdf_exec(void* df_, const char* sql) { return exec_sql((UXDataFrame*)df_, sql); }

UXDF_API void* uxdf_query(void* df_, const char* sql) {
    UXDataFrame* df = (UXDataFrame*)df_;
    if (!df || !sql) return NULL;
    char t[UXDF_NAME_MAX]; next_table(t, sizeof(t));
    char q[UXDF_SQL_MAX]; snprintf(q, sizeof(q), "CREATE TEMP TABLE %s AS %s", t, sql);
    if (!exec_sql(df, q)) return NULL;
    return df_new(df->ctx, t);
}

UXDF_API long long uxdf_row_count(void* df_) {
    UXDataFrame* df=(UXDataFrame*)df_; if (!df) return -1;
    char sql[256]; snprintf(sql, sizeof(sql), "SELECT COUNT(*) FROM %s", df->table);
    duckdb_result res;
    if (p_duckdb_query(df->ctx->con, sql, &res) != DuckDBSuccess) { set_error(df, p_duckdb_result_error(&res)); p_duckdb_destroy_result(&res); return -1; }
    long long n = (long long)p_duckdb_value_int64(&res, 0, 0);
    p_duckdb_destroy_result(&res); return n;
}

UXDF_API int uxdf_col_count(void* df_) {
    UXDataFrame* df=(UXDataFrame*)df_; if (!df) return -1;
    char sql[256]; snprintf(sql, sizeof(sql), "SELECT * FROM %s LIMIT 0", df->table);
    duckdb_result res;
    if (p_duckdb_query(df->ctx->con, sql, &res) != DuckDBSuccess) { set_error(df, p_duckdb_result_error(&res)); p_duckdb_destroy_result(&res); return -1; }
    int n=(int)p_duckdb_column_count(&res); p_duckdb_destroy_result(&res); return n;
}

UXDF_API const char* uxdf_col_name(void* df_, int col) {
    UXDataFrame* df=(UXDataFrame*)df_; if (!df) return "";
    char sql[256]; snprintf(sql, sizeof(sql), "SELECT * FROM %s LIMIT 0", df->table);
    duckdb_result res;
    if (p_duckdb_query(df->ctx->con, sql, &res) != DuckDBSuccess) { set_error(df, p_duckdb_result_error(&res)); p_duckdb_destroy_result(&res); return ""; }
    const char* name = p_duckdb_column_name(&res, (idx_t)col);
    char* result = next_tmp_text();
    snprintf(result, 4096, "%s", name ? name : "");
    p_duckdb_destroy_result(&res); return result;
}

static int query_cell(UXDataFrame* df, long long row, int col, duckdb_result* res) {
    char sql[512]; snprintf(sql, sizeof(sql), "SELECT * FROM %s LIMIT 1 OFFSET %lld", df->table, row);
    return p_duckdb_query(df->ctx->con, sql, res) == DuckDBSuccess;
}

UXDF_API double uxdf_get_f64(void* df_, long long row, int col) {
    UXDataFrame* df=(UXDataFrame*)df_; if (!df) return 0.0;
    duckdb_result res;
    if (!query_cell(df, row, col, &res)) { set_error(df, p_duckdb_result_error(&res)); p_duckdb_destroy_result(&res); return 0.0; }
    double v = p_duckdb_value_is_null(&res, (idx_t)col, 0) ? 0.0 : p_duckdb_value_double(&res, (idx_t)col, 0);
    p_duckdb_destroy_result(&res); return v;
}

UXDF_API const char* uxdf_get_text(void* df_, long long row, int col) {
    UXDataFrame* df=(UXDataFrame*)df_; if (!df) return "";
    duckdb_result res;
    if (!query_cell(df, row, col, &res)) { set_error(df, p_duckdb_result_error(&res)); p_duckdb_destroy_result(&res); return ""; }
    char* result = next_tmp_text();
    if (p_duckdb_value_is_null(&res, (idx_t)col, 0)) { result[0]=0; }
    else {
        char* s = p_duckdb_value_varchar(&res, (idx_t)col, 0);
        snprintf(result, 4096, "%s", s ? s : "");
        if (s) p_duckdb_free(s);
    }
    p_duckdb_destroy_result(&res); return result;
}

static void* table_expr(UXDataFrame* df, const char* expr) {
    if (!df || !expr) return NULL;
    char t[UXDF_NAME_MAX]; next_table(t, sizeof(t));
    char sql[UXDF_SQL_MAX]; snprintf(sql, sizeof(sql), "CREATE TEMP TABLE %s AS %s", t, expr);
    if (!exec_sql(df, sql)) return NULL;
    return df_new(df->ctx, t);
}
UXDF_API void* uxdf_head(void* df_, long long n) { UXDataFrame* df=(UXDataFrame*)df_; char e[512]; snprintf(e,sizeof(e),"SELECT * FROM %s LIMIT %lld", df?df->table:"", n); return table_expr(df,e); }
UXDF_API void* uxdf_select(void* df_, const char* cols) { UXDataFrame* df=(UXDataFrame*)df_; char e[UXDF_SQL_MAX]; snprintf(e,sizeof(e),"SELECT %s FROM %s", cols?cols:"*", df?df->table:""); return table_expr(df,e); }
UXDF_API void* uxdf_filter(void* df_, const char* where_sql) { UXDataFrame* df=(UXDataFrame*)df_; char e[UXDF_SQL_MAX]; snprintf(e,sizeof(e),"SELECT * FROM %s WHERE %s", df?df->table:"", where_sql?where_sql:"1=1"); return table_expr(df,e); }
UXDF_API void* uxdf_order_by(void* df_, const char* order_sql) { UXDataFrame* df=(UXDataFrame*)df_; char e[UXDF_SQL_MAX]; snprintf(e,sizeof(e),"SELECT * FROM %s ORDER BY %s", df?df->table:"", order_sql?order_sql:"1"); return table_expr(df,e); }
UXDF_API void* uxdf_describe(void* df_) { UXDataFrame* df=(UXDataFrame*)df_; char e[UXDF_SQL_MAX]; snprintf(e,sizeof(e),"SUMMARIZE %s", df?df->table:""); return table_expr(df,e); }
UXDF_API void* uxdf_group_mean(void* df_, const char* group_col, const char* value_col) { UXDataFrame* df=(UXDataFrame*)df_; char e[UXDF_SQL_MAX]; snprintf(e,sizeof(e),"SELECT %s, AVG(%s) AS mean_%s FROM %s GROUP BY %s", group_col, value_col, value_col, df?df->table:"", group_col); return table_expr(df,e); }
UXDF_API void* uxdf_join_inner(void* left_, void* right_, const char* left_key, const char* right_key) { UXDataFrame* l=(UXDataFrame*)left_; UXDataFrame* r=(UXDataFrame*)right_; if(!l||!r||l->ctx!=r->ctx){ set_global_error("join requires frames from same DuckDB context"); return NULL; } char e[UXDF_SQL_MAX]; snprintf(e,sizeof(e),"SELECT * FROM %s l INNER JOIN %s r ON l.%s = r.%s", l->table, r->table, left_key, right_key); return table_expr(l,e); }

UXDF_API int uxdf_to_csv(void* df_, const char* path) { UXDataFrame* df=(UXDataFrame*)df_; char pth[2048], sql[UXDF_SQL_MAX]; sql_escape_path(path,pth,sizeof(pth)); snprintf(sql,sizeof(sql),"COPY %s TO '%s' (HEADER, DELIMITER ',')", df?df->table:"", pth); return exec_sql(df,sql); }
UXDF_API int uxdf_to_parquet(void* df_, const char* path) { UXDataFrame* df=(UXDataFrame*)df_; char pth[2048], sql[UXDF_SQL_MAX]; sql_escape_path(path,pth,sizeof(pth)); snprintf(sql,sizeof(sql),"COPY %s TO '%s' (FORMAT PARQUET)", df?df->table:"", pth); return exec_sql(df,sql); }

UXDF_API void* uxdf_to_f64_matrix(void* df_) {
    UXDataFrame* df=(UXDataFrame*)df_; if(!df) return NULL;
    long long rows=uxdf_row_count(df); int cols=uxdf_col_count(df); if(rows<0||cols<1) return NULL;
    UXDFMatrix* m=(UXDFMatrix*)calloc(1,sizeof(UXDFMatrix)); if(!m) return NULL;
    m->rows=rows; m->cols=cols; m->data=(double*)calloc((size_t)rows*(size_t)cols,sizeof(double));
    if(!m->data){ free(m); return NULL; }
    char sql[512]; snprintf(sql,sizeof(sql),"SELECT * FROM %s", df->table);
    duckdb_result res;
    if(p_duckdb_query(df->ctx->con, sql, &res)!=DuckDBSuccess){ set_error(df,p_duckdb_result_error(&res)); p_duckdb_destroy_result(&res); uxdf_matrix_free(m); return NULL; }
    for(long long r=0;r<rows;r++) for(int c=0;c<cols;c++) m->data[r*cols+c]=p_duckdb_value_is_null(&res,c,r)?0.0:p_duckdb_value_double(&res,c,r);
    p_duckdb_destroy_result(&res); return m;
}
UXDF_API void uxdf_matrix_free(void* m_) { UXDFMatrix* m=(UXDFMatrix*)m_; if(!m)return; free(m->data); free(m); }
UXDF_API long long uxdf_matrix_rows(void* m_) { UXDFMatrix* m=(UXDFMatrix*)m_; return m?m->rows:0; }
UXDF_API int uxdf_matrix_cols(void* m_) { UXDFMatrix* m=(UXDFMatrix*)m_; return m?m->cols:0; }
UXDF_API double* uxdf_matrix_data_ptr(void* m_) { UXDFMatrix* m=(UXDFMatrix*)m_; return m?m->data:NULL; }
UXDF_API double uxdf_matrix_get(void* m_, long long row, int col) { UXDFMatrix* m=(UXDFMatrix*)m_; if(!m||row<0||row>=m->rows||col<0||col>=m->cols) return 0.0; return m->data[row*m->cols+col]; }
