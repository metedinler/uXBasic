#include "../cbase_common/uxb_cbase.h"
#include <zstd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

typedef struct {
    void *data;
    size_t size;
} uxcompress_blob;

static UXB_THREAD_LOCAL char g_error[1024];

static void set_zstd_error(size_t code) {
    snprintf(g_error, sizeof(g_error), "%s", ZSTD_getErrorName(code));
}

static void *read_file(const char *path, size_t *size_out) {
    FILE *fp;
    long n;
    void *data;
    if (!path || !size_out) return NULL;
    fp = fopen(path, "rb");
    if (!fp) return NULL;
    if (fseek(fp, 0, SEEK_END) != 0) { fclose(fp); return NULL; }
    n = ftell(fp);
    if (n < 0 || fseek(fp, 0, SEEK_SET) != 0) { fclose(fp); return NULL; }
    data = malloc((size_t)n ? (size_t)n : 1);
    if (!data) { fclose(fp); return NULL; }
    if (n > 0 && fread(data, 1, (size_t)n, fp) != (size_t)n) {
        free(data); fclose(fp); return NULL;
    }
    fclose(fp);
    *size_out = (size_t)n;
    return data;
}

static int write_file(const char *path, const void *data, size_t size) {
    FILE *fp = fopen(path, "wb");
    if (!fp) return 0;
    if (size && fwrite(data, 1, size, fp) != size) {
        fclose(fp);
        return 0;
    }
    fclose(fp);
    return 1;
}

UXB_EXPORT const char *UXB_CALL uxcompress_version(void) {
    return ZSTD_versionString();
}

UXB_EXPORT uxb_handle UXB_CALL uxcompress_buffer(
    const void *source, uint64_t source_size, int32_t level
) {
    uxcompress_blob *b;
    size_t bound;
    size_t result;
    if (!source && source_size != 0) return 0;
    b = (uxcompress_blob *)calloc(1, sizeof(*b));
    if (!b) return 0;
    bound = ZSTD_compressBound((size_t)source_size);
    b->data = malloc(bound ? bound : 1);
    if (!b->data) { free(b); return 0; }
    result = ZSTD_compress(
        b->data, bound, source, (size_t)source_size, level
    );
    if (ZSTD_isError(result)) {
        set_zstd_error(result);
        free(b->data);
        free(b);
        return 0;
    }
    b->size = result;
    g_error[0] = '\0';
    return (uxb_handle)(uintptr_t)b;
}

UXB_EXPORT uxb_handle UXB_CALL uxcompress_string(
    const char *source, int32_t level
) {
    if (!source) source = "";
    return uxcompress_buffer(source, (uint64_t)strlen(source), level);
}

UXB_EXPORT uxb_handle UXB_CALL uxdecompress_buffer(
    const void *source, uint64_t source_size, uint64_t expected_size
) {
    uxcompress_blob *b;
    unsigned long long frame_size;
    size_t target_size;
    size_t result;
    if (!source || source_size == 0) return 0;

    frame_size = ZSTD_getFrameContentSize(source, (size_t)source_size);
    if (expected_size) {
        target_size = (size_t)expected_size;
    } else if (
        frame_size != ZSTD_CONTENTSIZE_ERROR &&
        frame_size != ZSTD_CONTENTSIZE_UNKNOWN
    ) {
        target_size = (size_t)frame_size;
    } else {
        snprintf(
            g_error, sizeof(g_error),
            "decompressed size unknown; expected_size is required"
        );
        return 0;
    }

    b = (uxcompress_blob *)calloc(1, sizeof(*b));
    if (!b) return 0;
    b->data = malloc(target_size ? target_size : 1);
    if (!b->data) { free(b); return 0; }

    result = ZSTD_decompress(
        b->data, target_size, source, (size_t)source_size
    );
    if (ZSTD_isError(result)) {
        set_zstd_error(result);
        free(b->data);
        free(b);
        return 0;
    }
    b->size = result;
    g_error[0] = '\0';
    return (uxb_handle)(uintptr_t)b;
}

UXB_EXPORT const void *UXB_CALL uxcompress_blob_data(uxb_handle blob) {
    uxcompress_blob *b = (uxcompress_blob *)(uintptr_t)blob;
    return b ? b->data : NULL;
}

UXB_EXPORT uint64_t UXB_CALL uxcompress_blob_size(uxb_handle blob) {
    uxcompress_blob *b = (uxcompress_blob *)(uintptr_t)blob;
    return b ? (uint64_t)b->size : 0;
}

UXB_EXPORT void UXB_CALL uxcompress_blob_free(uxb_handle blob) {
    uxcompress_blob *b = (uxcompress_blob *)(uintptr_t)blob;
    if (!b) return;
    free(b->data);
    free(b);
}

UXB_EXPORT int32_t UXB_CALL uxcompress_file(
    const char *source_path, const char *target_path, int32_t level
) {
    size_t source_size = 0;
    void *source = read_file(source_path, &source_size);
    uxb_handle blob;
    uxcompress_blob *b;
    int ok;
    if (!source) {
        snprintf(g_error, sizeof(g_error), "cannot read source file");
        return 0;
    }
    blob = uxcompress_buffer(source, (uint64_t)source_size, level);
    free(source);
    if (!blob) return 0;
    b = (uxcompress_blob *)(uintptr_t)blob;
    ok = write_file(target_path, b->data, b->size);
    uxcompress_blob_free(blob);
    if (!ok) snprintf(g_error, sizeof(g_error), "cannot write target file");
    return ok;
}

UXB_EXPORT int32_t UXB_CALL uxdecompress_file(
    const char *source_path, const char *target_path
) {
    size_t source_size = 0;
    void *source = read_file(source_path, &source_size);
    uxb_handle blob;
    uxcompress_blob *b;
    int ok;
    if (!source) {
        snprintf(g_error, sizeof(g_error), "cannot read source file");
        return 0;
    }
    blob = uxdecompress_buffer(source, (uint64_t)source_size, 0);
    free(source);
    if (!blob) return 0;
    b = (uxcompress_blob *)(uintptr_t)blob;
    ok = write_file(target_path, b->data, b->size);
    uxcompress_blob_free(blob);
    if (!ok) snprintf(g_error, sizeof(g_error), "cannot write target file");
    return ok;
}

UXB_EXPORT const char *UXB_CALL uxcompress_error(void) {
    return g_error;
}
