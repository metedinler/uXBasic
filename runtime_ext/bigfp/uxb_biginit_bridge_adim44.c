/* BIGINIT bridge shared by the interpreter and generated native code. */

#include <stdlib.h>
#include <string.h>
#include "uxb_bigi_gmp.h"

extern void* uxb_bigf_init(int precision);
extern int uxb_bigf_from_str(const char* value, void* handle);
extern void uxb_bigf_to_str(void* handle, char* out, int out_len);
extern void uxb_bigf_free(void* handle);
extern void* uxb_bigd_init(int precision);
extern int uxb_bigd_from_str(const char* value, void* handle);
extern void uxb_bigd_to_str(void* handle, char* out, int out_len);
extern void uxb_bigd_free(void* handle);
extern void* uxb_ball_init(int precision);
extern int uxb_ball_from_str(const char* value, void* handle);
extern void uxb_ball_to_str(void* handle, char* out, int out_len);
extern void uxb_ball_free(void* handle);

static int kind_is(const char* kind, const char* expected) {
    return kind && expected && _stricmp(kind, expected) == 0;
}

void* __uxb_rt_biginit(const char* kind, const char* value, int precision) {
    if (!kind || !value) return NULL;

    if (kind_is(kind, "BIGI") || kind_is(kind, "BIGINT")) {
        void* p = uxb_bigi_init();
        if (!p) return NULL;
        if (!uxb_bigi_from_str(p, value, 10)) {
            uxb_bigi_free(p);
            return NULL;
        }
        return p;
    }

    if (kind_is(kind, "BIGF")) {
        void* p = uxb_bigf_init(precision);
        if (!p) return NULL;
        if (!uxb_bigf_from_str(value, p)) { uxb_bigf_free(p); return NULL; }
        return p;
    }

    if (kind_is(kind, "BIGD")) {
        void* p = uxb_bigd_init(precision);
        if (!p) return NULL;
        if (!uxb_bigd_from_str(value, p)) { uxb_bigd_free(p); return NULL; }
        return p;
    }

    if (kind_is(kind, "BALL")) {
        void* p = uxb_ball_init(precision);
        if (!p) return NULL;
        if (!uxb_ball_from_str(value, p)) { uxb_ball_free(p); return NULL; }
        return p;
    }

    return NULL;
}

int __uxb_rt_big_to_str(const char* kind, void* handle, char* out, int out_len) {
    if (!kind || !handle || !out || out_len <= 0) return 0;
    out[0] = 0;
    if (kind_is(kind, "BIGI") || kind_is(kind, "BIGINT"))
        return uxb_bigi_to_str(handle, out, out_len, 10);
    if (kind_is(kind, "BIGF")) uxb_bigf_to_str(handle, out, out_len);
    else if (kind_is(kind, "BIGD")) uxb_bigd_to_str(handle, out, out_len);
    else if (kind_is(kind, "BALL")) uxb_ball_to_str(handle, out, out_len);
    else return 0;
    return out[0] != 0;
}

void __uxb_rt_big_free(const char* kind, void* handle) {
    if (!kind || !handle) return;
    if (kind_is(kind, "BIGI") || kind_is(kind, "BIGINT")) uxb_bigi_free(handle);
    else if (kind_is(kind, "BIGF")) uxb_bigf_free(handle);
    else if (kind_is(kind, "BIGD")) uxb_bigd_free(handle);
    else if (kind_is(kind, "BALL")) uxb_ball_free(handle);
}

const char* __uxb_rt_biginit_text(const char* kind, const char* value, int precision) {
    enum { SLOT_COUNT = 8, SLOT_BYTES = 65536 };
    static _Thread_local char slots[SLOT_COUNT][SLOT_BYTES];
    static _Thread_local unsigned int next_slot;
    if (!kind || !value) return NULL;

    void* handle = __uxb_rt_biginit(kind, value, precision);
    if (!handle) return NULL;

    char verified[SLOT_BYTES];
    if (!__uxb_rt_big_to_str(kind, handle, verified, SLOT_BYTES)) {
        __uxb_rt_big_free(kind, handle);
        return NULL;
    }
    __uxb_rt_big_free(kind, handle);

    char* out = slots[next_slot++ % SLOT_COUNT];
    size_t n = strlen(value);
    if (n >= SLOT_BYTES) return NULL;
    memcpy(out, value, n + 1);
    return out;
}
