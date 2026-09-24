#include "../cbase_common/uxb_cbase.h"
#include <curl/curl.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

typedef struct {
    CURL *easy;
    struct curl_slist *headers;
    char *response;
    size_t response_size;
    size_t response_capacity;
    char *body;
    char error[CURL_ERROR_SIZE];
    long status;
} uxhttp_handle;

static int g_curl_initialized = 0;

static char *dup_text(const char *s) {
    size_t n;
    char *p;
    if (!s) s = "";
    n = strlen(s);
    p = (char *)malloc(n + 1);
    if (!p) return NULL;
    memcpy(p, s, n + 1);
    return p;
}

static size_t write_memory(
    char *ptr, size_t size, size_t nmemb, void *userdata
) {
    uxhttp_handle *h = (uxhttp_handle *)userdata;
    size_t bytes = size * nmemb;
    size_t needed;
    char *next;
    if (!h || bytes == 0) return bytes;
    needed = h->response_size + bytes + 1;
    if (needed > h->response_capacity) {
        size_t cap = h->response_capacity ? h->response_capacity : 4096;
        while (cap < needed) cap *= 2;
        next = (char *)realloc(h->response, cap);
        if (!next) return 0;
        h->response = next;
        h->response_capacity = cap;
    }
    memcpy(h->response + h->response_size, ptr, bytes);
    h->response_size += bytes;
    h->response[h->response_size] = '\0';
    return bytes;
}

static void reset_response(uxhttp_handle *h) {
    if (!h) return;
    h->response_size = 0;
    h->status = 0;
    h->error[0] = '\0';
    if (h->response) h->response[0] = '\0';
}

UXB_EXPORT const char *UXB_CALL uxhttp_version(void) {
    return curl_version();
}

UXB_EXPORT uxb_handle UXB_CALL uxhttp_open(void) {
    uxhttp_handle *h;
    if (!g_curl_initialized) {
        if (curl_global_init(CURL_GLOBAL_DEFAULT) != CURLE_OK) return 0;
        g_curl_initialized = 1;
    }
    h = (uxhttp_handle *)calloc(1, sizeof(*h));
    if (!h) return 0;
    h->easy = curl_easy_init();
    if (!h->easy) {
        free(h);
        return 0;
    }
    curl_easy_setopt(h->easy, CURLOPT_ERRORBUFFER, h->error);
    curl_easy_setopt(h->easy, CURLOPT_WRITEFUNCTION, write_memory);
    curl_easy_setopt(h->easy, CURLOPT_WRITEDATA, h);
    curl_easy_setopt(h->easy, CURLOPT_USERAGENT, "uXBasic-uxhttp/1.0");
    curl_easy_setopt(h->easy, CURLOPT_NOSIGNAL, 1L);
    curl_easy_setopt(h->easy, CURLOPT_FOLLOWLOCATION, 1L);
    return (uxb_handle)(uintptr_t)h;
}

UXB_EXPORT void UXB_CALL uxhttp_close(uxb_handle handle) {
    uxhttp_handle *h = (uxhttp_handle *)(uintptr_t)handle;
    if (!h) return;
    if (h->headers) curl_slist_free_all(h->headers);
    if (h->easy) curl_easy_cleanup(h->easy);
    free(h->response);
    free(h->body);
    free(h);
}

UXB_EXPORT int32_t UXB_CALL uxhttp_set_url(
    uxb_handle handle, const char *url
) {
    uxhttp_handle *h = (uxhttp_handle *)(uintptr_t)handle;
    if (!h || !h->easy || !url) return 0;
    return curl_easy_setopt(h->easy, CURLOPT_URL, url) == CURLE_OK;
}

UXB_EXPORT int32_t UXB_CALL uxhttp_set_method(
    uxb_handle handle, const char *method
) {
    uxhttp_handle *h = (uxhttp_handle *)(uintptr_t)handle;
    if (!h || !h->easy || !method) return 0;

    curl_easy_setopt(h->easy, CURLOPT_NOBODY, 0L);
    curl_easy_setopt(h->easy, CURLOPT_HTTPGET, 0L);
    curl_easy_setopt(h->easy, CURLOPT_POST, 0L);

    if (_stricmp(method, "GET") == 0) {
        return curl_easy_setopt(h->easy, CURLOPT_HTTPGET, 1L) == CURLE_OK;
    }
    if (_stricmp(method, "POST") == 0) {
        return curl_easy_setopt(h->easy, CURLOPT_POST, 1L) == CURLE_OK;
    }
    if (_stricmp(method, "HEAD") == 0) {
        return curl_easy_setopt(h->easy, CURLOPT_NOBODY, 1L) == CURLE_OK;
    }
    return curl_easy_setopt(h->easy, CURLOPT_CUSTOMREQUEST, method) == CURLE_OK;
}

UXB_EXPORT int32_t UXB_CALL uxhttp_add_header(
    uxb_handle handle, const char *header
) {
    uxhttp_handle *h = (uxhttp_handle *)(uintptr_t)handle;
    struct curl_slist *next;
    if (!h || !header) return 0;
    next = curl_slist_append(h->headers, header);
    if (!next) return 0;
    h->headers = next;
    return 1;
}

UXB_EXPORT int32_t UXB_CALL uxhttp_set_body(
    uxb_handle handle, const char *body
) {
    uxhttp_handle *h = (uxhttp_handle *)(uintptr_t)handle;
    char *next;
    if (!h || !h->easy) return 0;
    next = dup_text(body);
    if (!next) return 0;
    free(h->body);
    h->body = next;
    if (curl_easy_setopt(h->easy, CURLOPT_POSTFIELDS, h->body) != CURLE_OK) {
        return 0;
    }
    return curl_easy_setopt(
        h->easy, CURLOPT_POSTFIELDSIZE_LARGE, (curl_off_t)strlen(h->body)
    ) == CURLE_OK;
}

UXB_EXPORT int32_t UXB_CALL uxhttp_set_timeout_ms(
    uxb_handle handle, int64_t timeout_ms
) {
    uxhttp_handle *h = (uxhttp_handle *)(uintptr_t)handle;
    if (!h || !h->easy || timeout_ms < 0) return 0;
    return curl_easy_setopt(
        h->easy, CURLOPT_TIMEOUT_MS, (long)timeout_ms
    ) == CURLE_OK;
}

UXB_EXPORT int32_t UXB_CALL uxhttp_set_follow_redirects(
    uxb_handle handle, int32_t enabled
) {
    uxhttp_handle *h = (uxhttp_handle *)(uintptr_t)handle;
    if (!h || !h->easy) return 0;
    return curl_easy_setopt(
        h->easy, CURLOPT_FOLLOWLOCATION, enabled ? 1L : 0L
    ) == CURLE_OK;
}

UXB_EXPORT int32_t UXB_CALL uxhttp_perform(uxb_handle handle) {
    uxhttp_handle *h = (uxhttp_handle *)(uintptr_t)handle;
    CURLcode rc;
    if (!h || !h->easy) return (int32_t)CURLE_FAILED_INIT;
    reset_response(h);
    curl_easy_setopt(h->easy, CURLOPT_HTTPHEADER, h->headers);
    rc = curl_easy_perform(h->easy);
    if (rc == CURLE_OK) {
        curl_easy_getinfo(h->easy, CURLINFO_RESPONSE_CODE, &h->status);
    } else if (h->error[0] == '\0') {
        snprintf(h->error, sizeof(h->error), "%s", curl_easy_strerror(rc));
    }
    return (int32_t)rc;
}

UXB_EXPORT int64_t UXB_CALL uxhttp_status(uxb_handle handle) {
    uxhttp_handle *h = (uxhttp_handle *)(uintptr_t)handle;
    return h ? (int64_t)h->status : 0;
}

UXB_EXPORT const char *UXB_CALL uxhttp_response_text(uxb_handle handle) {
    uxhttp_handle *h = (uxhttp_handle *)(uintptr_t)handle;
    return (h && h->response) ? h->response : "";
}

UXB_EXPORT uint64_t UXB_CALL uxhttp_response_size(uxb_handle handle) {
    uxhttp_handle *h = (uxhttp_handle *)(uintptr_t)handle;
    return h ? (uint64_t)h->response_size : 0;
}

UXB_EXPORT int32_t UXB_CALL uxhttp_save_response(
    uxb_handle handle, const char *path
) {
    uxhttp_handle *h = (uxhttp_handle *)(uintptr_t)handle;
    FILE *fp;
    if (!h || !path) return 0;
    fp = fopen(path, "wb");
    if (!fp) {
        snprintf(h->error, sizeof(h->error), "cannot open output file");
        return 0;
    }
    if (h->response_size &&
        fwrite(h->response, 1, h->response_size, fp) != h->response_size) {
        fclose(fp);
        snprintf(h->error, sizeof(h->error), "cannot write output file");
        return 0;
    }
    fclose(fp);
    return 1;
}

UXB_EXPORT const char *UXB_CALL uxhttp_error(uxb_handle handle) {
    uxhttp_handle *h = (uxhttp_handle *)(uintptr_t)handle;
    return h ? h->error : "invalid http handle";
}
