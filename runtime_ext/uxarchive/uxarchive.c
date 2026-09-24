#include "../cbase_common/uxb_cbase.h"
#include <archive.h>
#include <archive_entry.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <ctype.h>

static UXB_THREAD_LOCAL char g_error[1024];

static int unsafe_path(const char *path) {
    const char *p;
    const char *start;
    size_t len;
    if (!path || !*path) return 1;
    if (path[0] == '/' || path[0] == '\\') return 1;
    if (isalpha((unsigned char)path[0]) && path[1] == ':') return 1;

    p = path;
    while (*p) {
        while (*p == '/' || *p == '\\') p++;
        start = p;
        while (*p && *p != '/' && *p != '\\') p++;
        len = (size_t)(p - start);
        if (len == 2 && start[0] == '.' && start[1] == '.') return 1;
    }
    return 0;
}

static char *join_path(const char *root, const char *entry) {
    size_t a = strlen(root);
    size_t b = strlen(entry);
    char *out = (char *)malloc(a + b + 2);
    if (!out) return NULL;
    memcpy(out, root, a);
    if (a && root[a - 1] != '/' && root[a - 1] != '\\') {
        out[a++] = '\\';
    }
    memcpy(out + a, entry, b + 1);
    return out;
}

UXB_EXPORT const char *UXB_CALL uxarchive_version(void) {
    return archive_version_string();
}

UXB_EXPORT int64_t UXB_CALL uxarchive_count(const char *archive_path) {
    struct archive *a;
    struct archive_entry *entry;
    int64_t count = 0;
    int rc;
    if (!archive_path) return -1;
    a = archive_read_new();
    archive_read_support_filter_all(a);
    archive_read_support_format_all(a);
    rc = archive_read_open_filename(a, archive_path, 10240);
    if (rc != ARCHIVE_OK) {
        snprintf(g_error, sizeof(g_error), "%s", archive_error_string(a));
        archive_read_free(a);
        return -1;
    }
    while ((rc = archive_read_next_header(a, &entry)) == ARCHIVE_OK) {
        count++;
        archive_read_data_skip(a);
    }
    if (rc != ARCHIVE_EOF) {
        snprintf(g_error, sizeof(g_error), "%s", archive_error_string(a));
        count = -1;
    } else {
        g_error[0] = '\0';
    }
    archive_read_close(a);
    archive_read_free(a);
    return count;
}

UXB_EXPORT int64_t UXB_CALL uxarchive_extract_all(
    const char *archive_path, const char *destination
) {
    struct archive *a;
    struct archive_entry *entry;
    int64_t extracted = 0;
    int rc;
    int flags =
        ARCHIVE_EXTRACT_TIME |
        ARCHIVE_EXTRACT_PERM |
        ARCHIVE_EXTRACT_SECURE_NODOTDOT |
        ARCHIVE_EXTRACT_SECURE_SYMLINKS;

    if (!archive_path || !destination) return -1;

    a = archive_read_new();
    archive_read_support_filter_all(a);
    archive_read_support_format_all(a);

    rc = archive_read_open_filename(a, archive_path, 10240);
    if (rc != ARCHIVE_OK) {
        snprintf(g_error, sizeof(g_error), "%s", archive_error_string(a));
        archive_read_free(a);
        return -1;
    }

    while ((rc = archive_read_next_header(a, &entry)) == ARCHIVE_OK) {
        const char *entry_path = archive_entry_pathname(entry);
        char *target;

        if (unsafe_path(entry_path)) {
            snprintf(
                g_error, sizeof(g_error),
                "unsafe archive entry rejected: %s",
                entry_path ? entry_path : "(null)"
            );
            archive_read_close(a);
            archive_read_free(a);
            return -1;
        }

        target = join_path(destination, entry_path);
        if (!target) {
            snprintf(g_error, sizeof(g_error), "out of memory");
            archive_read_close(a);
            archive_read_free(a);
            return -1;
        }

        archive_entry_set_pathname(entry, target);
        free(target);

        rc = archive_read_extract(a, entry, flags);
        if (rc != ARCHIVE_OK) {
            snprintf(g_error, sizeof(g_error), "%s", archive_error_string(a));
            archive_read_close(a);
            archive_read_free(a);
            return -1;
        }
        extracted++;
    }

    if (rc != ARCHIVE_EOF) {
        snprintf(g_error, sizeof(g_error), "%s", archive_error_string(a));
        extracted = -1;
    } else {
        g_error[0] = '\0';
    }

    archive_read_close(a);
    archive_read_free(a);
    return extracted;
}

UXB_EXPORT const char *UXB_CALL uxarchive_error(void) {
    return g_error;
}
