#include "../cbase_common/uxb_cbase.h"
#include <sqlite3.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

typedef struct {
    sqlite3 *db;
    char error[1024];
} uxsqlite_db;

typedef struct {
    sqlite3_stmt *stmt;
    uxsqlite_db *owner;
} uxsqlite_stmt;

static void set_error(uxsqlite_db *h, const char *msg) {
    if (!h) return;
    snprintf(h->error, sizeof(h->error), "%s", msg ? msg : "");
}

UXB_EXPORT const char *UXB_CALL uxsqlite_version(void) {
    return sqlite3_libversion();
}

UXB_EXPORT uxb_handle UXB_CALL uxsqlite_open(const char *path) {
    uxsqlite_db *h = (uxsqlite_db *)calloc(1, sizeof(*h));
    int rc;
    if (!h) return 0;
    rc = sqlite3_open_v2(
        path ? path : ":memory:",
        &h->db,
        SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX,
        NULL
    );
    if (rc != SQLITE_OK) {
        set_error(h, h->db ? sqlite3_errmsg(h->db) : "sqlite open failed");
        if (h->db) sqlite3_close_v2(h->db);
        free(h);
        return 0;
    }
    return (uxb_handle)(uintptr_t)h;
}

UXB_EXPORT uxb_handle UXB_CALL uxsqlite_open_memory(void) {
    return uxsqlite_open(":memory:");
}

UXB_EXPORT void UXB_CALL uxsqlite_close(uxb_handle handle) {
    uxsqlite_db *h = (uxsqlite_db *)(uintptr_t)handle;
    if (!h) return;
    if (h->db) sqlite3_close_v2(h->db);
    free(h);
}

UXB_EXPORT int32_t UXB_CALL uxsqlite_exec(uxb_handle handle, const char *sql) {
    uxsqlite_db *h = (uxsqlite_db *)(uintptr_t)handle;
    char *err = NULL;
    int rc;
    if (!h || !h->db || !sql) return SQLITE_MISUSE;
    rc = sqlite3_exec(h->db, sql, NULL, NULL, &err);
    if (rc != SQLITE_OK) {
        set_error(h, err ? err : sqlite3_errmsg(h->db));
        sqlite3_free(err);
    } else {
        set_error(h, "");
    }
    return rc;
}

UXB_EXPORT uxb_handle UXB_CALL uxsqlite_prepare(uxb_handle handle, const char *sql) {
    uxsqlite_db *h = (uxsqlite_db *)(uintptr_t)handle;
    uxsqlite_stmt *s;
    int rc;
    if (!h || !h->db || !sql) return 0;
    s = (uxsqlite_stmt *)calloc(1, sizeof(*s));
    if (!s) {
        set_error(h, "out of memory");
        return 0;
    }
    rc = sqlite3_prepare_v2(h->db, sql, -1, &s->stmt, NULL);
    if (rc != SQLITE_OK) {
        set_error(h, sqlite3_errmsg(h->db));
        free(s);
        return 0;
    }
    s->owner = h;
    return (uxb_handle)(uintptr_t)s;
}

UXB_EXPORT void UXB_CALL uxsqlite_stmt_finalize(uxb_handle statement) {
    uxsqlite_stmt *s = (uxsqlite_stmt *)(uintptr_t)statement;
    if (!s) return;
    if (s->stmt) sqlite3_finalize(s->stmt);
    free(s);
}

UXB_EXPORT int32_t UXB_CALL uxsqlite_bind_i64(
    uxb_handle statement, int32_t index1, int64_t value
) {
    uxsqlite_stmt *s = (uxsqlite_stmt *)(uintptr_t)statement;
    if (!s || !s->stmt) return SQLITE_MISUSE;
    return sqlite3_bind_int64(s->stmt, index1, (sqlite3_int64)value);
}

UXB_EXPORT int32_t UXB_CALL uxsqlite_bind_f64(
    uxb_handle statement, int32_t index1, double value
) {
    uxsqlite_stmt *s = (uxsqlite_stmt *)(uintptr_t)statement;
    if (!s || !s->stmt) return SQLITE_MISUSE;
    return sqlite3_bind_double(s->stmt, index1, value);
}

UXB_EXPORT int32_t UXB_CALL uxsqlite_bind_text(
    uxb_handle statement, int32_t index1, const char *value
) {
    uxsqlite_stmt *s = (uxsqlite_stmt *)(uintptr_t)statement;
    if (!s || !s->stmt) return SQLITE_MISUSE;
    return sqlite3_bind_text(
        s->stmt, index1, value ? value : "", -1, SQLITE_TRANSIENT
    );
}

UXB_EXPORT int32_t UXB_CALL uxsqlite_step(uxb_handle statement) {
    uxsqlite_stmt *s = (uxsqlite_stmt *)(uintptr_t)statement;
    int rc;
    if (!s || !s->stmt) return SQLITE_MISUSE;
    rc = sqlite3_step(s->stmt);
    if (rc != SQLITE_ROW && rc != SQLITE_DONE && s->owner) {
        set_error(s->owner, sqlite3_errmsg(s->owner->db));
    }
    return rc;
}

UXB_EXPORT int32_t UXB_CALL uxsqlite_reset(uxb_handle statement) {
    uxsqlite_stmt *s = (uxsqlite_stmt *)(uintptr_t)statement;
    if (!s || !s->stmt) return SQLITE_MISUSE;
    sqlite3_clear_bindings(s->stmt);
    return sqlite3_reset(s->stmt);
}

UXB_EXPORT int32_t UXB_CALL uxsqlite_column_count(uxb_handle statement) {
    uxsqlite_stmt *s = (uxsqlite_stmt *)(uintptr_t)statement;
    return (s && s->stmt) ? sqlite3_column_count(s->stmt) : 0;
}

UXB_EXPORT int32_t UXB_CALL uxsqlite_column_type(
    uxb_handle statement, int32_t column0
) {
    uxsqlite_stmt *s = (uxsqlite_stmt *)(uintptr_t)statement;
    return (s && s->stmt) ? sqlite3_column_type(s->stmt, column0) : SQLITE_NULL;
}

UXB_EXPORT int64_t UXB_CALL uxsqlite_column_i64(
    uxb_handle statement, int32_t column0
) {
    uxsqlite_stmt *s = (uxsqlite_stmt *)(uintptr_t)statement;
    return (s && s->stmt)
        ? (int64_t)sqlite3_column_int64(s->stmt, column0)
        : 0;
}

UXB_EXPORT double UXB_CALL uxsqlite_column_f64(
    uxb_handle statement, int32_t column0
) {
    uxsqlite_stmt *s = (uxsqlite_stmt *)(uintptr_t)statement;
    return (s && s->stmt) ? sqlite3_column_double(s->stmt, column0) : 0.0;
}

UXB_EXPORT const char *UXB_CALL uxsqlite_column_text(
    uxb_handle statement, int32_t column0
) {
    uxsqlite_stmt *s = (uxsqlite_stmt *)(uintptr_t)statement;
    const unsigned char *p;
    if (!s || !s->stmt) return "";
    p = sqlite3_column_text(s->stmt, column0);
    return p ? (const char *)p : "";
}

UXB_EXPORT int64_t UXB_CALL uxsqlite_last_insert_rowid(uxb_handle handle) {
    uxsqlite_db *h = (uxsqlite_db *)(uintptr_t)handle;
    return (h && h->db) ? (int64_t)sqlite3_last_insert_rowid(h->db) : 0;
}

UXB_EXPORT int32_t UXB_CALL uxsqlite_changes(uxb_handle handle) {
    uxsqlite_db *h = (uxsqlite_db *)(uintptr_t)handle;
    return (h && h->db) ? sqlite3_changes(h->db) : 0;
}

UXB_EXPORT const char *UXB_CALL uxsqlite_error(uxb_handle handle) {
    uxsqlite_db *h = (uxsqlite_db *)(uintptr_t)handle;
    return h ? h->error : "invalid database handle";
}
