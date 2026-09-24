#include "../cbase_common/uxb_cbase.h"
#define PCRE2_CODE_UNIT_WIDTH 8
#include <pcre2.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

typedef struct {
    pcre2_code *code;
    pcre2_match_data *match;
    int last_rc;
    char *last_text;
    char error[1024];
} uxregex_handle;

UXB_EXPORT const char *UXB_CALL uxregex_version(void) {
    static UXB_THREAD_LOCAL char version[64];
    version[0] = '\0';
    pcre2_config(PCRE2_CONFIG_VERSION, version);
    return version;
}

UXB_EXPORT uxb_handle UXB_CALL uxregex_compile(
    const char *pattern, uint32_t options
) {
    uxregex_handle *h;
    int errcode;
    PCRE2_SIZE erroffset;
    PCRE2_UCHAR msg[512];

    if (!pattern) return 0;
    h = (uxregex_handle *)calloc(1, sizeof(*h));
    if (!h) return 0;

    h->code = pcre2_compile(
        (PCRE2_SPTR)pattern,
        PCRE2_ZERO_TERMINATED,
        options,
        &errcode,
        &erroffset,
        NULL
    );
    if (!h->code) {
        pcre2_get_error_message(errcode, msg, sizeof(msg));
        snprintf(
            h->error, sizeof(h->error), "%s at offset %llu",
            (char *)msg, (unsigned long long)erroffset
        );
        free(h);
        return 0;
    }
    h->match = pcre2_match_data_create_from_pattern(h->code, NULL);
    if (!h->match) {
        pcre2_code_free(h->code);
        free(h);
        return 0;
    }
    return (uxb_handle)(uintptr_t)h;
}

UXB_EXPORT void UXB_CALL uxregex_free(uxb_handle handle) {
    uxregex_handle *h = (uxregex_handle *)(uintptr_t)handle;
    if (!h) return;
    free(h->last_text);
    if (h->match) pcre2_match_data_free(h->match);
    if (h->code) pcre2_code_free(h->code);
    free(h);
}

UXB_EXPORT int32_t UXB_CALL uxregex_match(
    uxb_handle handle, const char *subject,
    uint64_t start_offset, uint32_t options
) {
    uxregex_handle *h = (uxregex_handle *)(uintptr_t)handle;
    if (!h || !h->code || !h->match || !subject) return PCRE2_ERROR_NULL;
    h->last_rc = pcre2_match(
        h->code,
        (PCRE2_SPTR)subject,
        strlen(subject),
        (PCRE2_SIZE)start_offset,
        options,
        h->match,
        NULL
    );
    if (h->last_rc < 0 && h->last_rc != PCRE2_ERROR_NOMATCH) {
        PCRE2_UCHAR msg[512];
        pcre2_get_error_message(h->last_rc, msg, sizeof(msg));
        snprintf(h->error, sizeof(h->error), "%s", (char *)msg);
    } else {
        h->error[0] = '\0';
    }
    return h->last_rc;
}

UXB_EXPORT int32_t UXB_CALL uxregex_is_match(
    uxb_handle handle, const char *subject
) {
    return uxregex_match(handle, subject, 0, 0) >= 0;
}

UXB_EXPORT int32_t UXB_CALL uxregex_group_count(uxb_handle handle) {
    uxregex_handle *h = (uxregex_handle *)(uintptr_t)handle;
    return h ? h->last_rc : 0;
}

UXB_EXPORT int64_t UXB_CALL uxregex_group_start(
    uxb_handle handle, int32_t group
) {
    uxregex_handle *h = (uxregex_handle *)(uintptr_t)handle;
    PCRE2_SIZE *ov;
    if (!h || h->last_rc <= group || group < 0) return -1;
    ov = pcre2_get_ovector_pointer(h->match);
    if (ov[group * 2] == PCRE2_UNSET) return -1;
    return (int64_t)ov[group * 2];
}

UXB_EXPORT int64_t UXB_CALL uxregex_group_end(
    uxb_handle handle, int32_t group
) {
    uxregex_handle *h = (uxregex_handle *)(uintptr_t)handle;
    PCRE2_SIZE *ov;
    if (!h || h->last_rc <= group || group < 0) return -1;
    ov = pcre2_get_ovector_pointer(h->match);
    if (ov[group * 2 + 1] == PCRE2_UNSET) return -1;
    return (int64_t)ov[group * 2 + 1];
}

UXB_EXPORT const char *UXB_CALL uxregex_group_text(
    uxb_handle handle, const char *subject, int32_t group
) {
    uxregex_handle *h = (uxregex_handle *)(uintptr_t)handle;
    PCRE2_SIZE *ov;
    size_t n;
    if (!h || !subject || h->last_rc <= group || group < 0) return "";
    ov = pcre2_get_ovector_pointer(h->match);
    if (ov[group * 2] == PCRE2_UNSET || ov[group * 2 + 1] == PCRE2_UNSET) {
        return "";
    }
    n = (size_t)(ov[group * 2 + 1] - ov[group * 2]);
    free(h->last_text);
    h->last_text = (char *)malloc(n + 1);
    if (!h->last_text) return "";
    memcpy(h->last_text, subject + ov[group * 2], n);
    h->last_text[n] = '\0';
    return h->last_text;
}

UXB_EXPORT const char *UXB_CALL uxregex_error(uxb_handle handle) {
    uxregex_handle *h = (uxregex_handle *)(uintptr_t)handle;
    return h ? h->error : "invalid regex handle";
}
