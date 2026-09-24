/* ADIM44 BIGI runtime additions - GMP based.
   Build requirement: gmp.h and libgmp.
   This file must be added to the bigfp runtime build only when GMP is available. */

#include <stdlib.h>
#include <string.h>
#include "uxb_bigi_gmp.h"

#if defined(UXB_HAVE_GMP)
#include <gmp.h>

typedef struct uxb_bigi_s {
    mpz_t z;
} uxb_bigi_t;

void* uxb_bigi_init(void) {
    uxb_bigi_t* p = (uxb_bigi_t*)calloc(1, sizeof(uxb_bigi_t));
    if (!p) return NULL;
    mpz_init(p->z);
    return p;
}

void uxb_bigi_free(void* vp) {
    if (!vp) return;
    uxb_bigi_t* p = (uxb_bigi_t*)vp;
    mpz_clear(p->z);
    free(p);
}

int uxb_bigi_from_str(void* vp, const char* s, int base) {
    if (!vp || !s) return 0;
    if (base == 0) base = 10;
    uxb_bigi_t* p = (uxb_bigi_t*)vp;
    return mpz_set_str(p->z, s, base) == 0 ? 1 : 0;
}

int uxb_bigi_to_str(void* vp, char* out, int out_len, int base) {
    if (!vp || !out || out_len <= 0) return 0;
    if (base == 0) base = 10;
    uxb_bigi_t* p = (uxb_bigi_t*)vp;
    char* s = mpz_get_str(NULL, base, p->z);
    if (!s) return 0;
    int n = (int)strlen(s);
    if (n + 1 > out_len) {
        free(s);
        return 0;
    }
    memcpy(out, s, n + 1);
    free(s);
    return 1;
}

int uxb_bigi_add(void* out, void* a, void* b) {
    if (!out || !a || !b) return 0;
    mpz_add(((uxb_bigi_t*)out)->z, ((uxb_bigi_t*)a)->z, ((uxb_bigi_t*)b)->z);
    return 1;
}

int uxb_bigi_sub(void* out, void* a, void* b) {
    if (!out || !a || !b) return 0;
    mpz_sub(((uxb_bigi_t*)out)->z, ((uxb_bigi_t*)a)->z, ((uxb_bigi_t*)b)->z);
    return 1;
}

int uxb_bigi_mul(void* out, void* a, void* b) {
    if (!out || !a || !b) return 0;
    mpz_mul(((uxb_bigi_t*)out)->z, ((uxb_bigi_t*)a)->z, ((uxb_bigi_t*)b)->z);
    return 1;
}

int uxb_bigi_tdiv_q(void* out, void* a, void* b) {
    if (!out || !a || !b) return 0;
    if (mpz_sgn(((uxb_bigi_t*)b)->z) == 0) return 0;
    mpz_tdiv_q(((uxb_bigi_t*)out)->z, ((uxb_bigi_t*)a)->z, ((uxb_bigi_t*)b)->z);
    return 1;
}

int uxb_bigi_mod(void* out, void* a, void* b) {
    if (!out || !a || !b) return 0;
    if (mpz_sgn(((uxb_bigi_t*)b)->z) == 0) return 0;
    mpz_mod(((uxb_bigi_t*)out)->z, ((uxb_bigi_t*)a)->z, ((uxb_bigi_t*)b)->z);
    return 1;
}

int uxb_bigi_cmp(void* a, void* b) {
    if (!a || !b) return 0;
    return mpz_cmp(((uxb_bigi_t*)a)->z, ((uxb_bigi_t*)b)->z);
}

#else

/* GMP yoksa sahte başarı yok. Fonksiyonlar başarısız döner. */
void* uxb_bigi_init(void) { return NULL; }
void  uxb_bigi_free(void* p) { (void)p; }
int   uxb_bigi_from_str(void* p, const char* s, int base) { (void)p; (void)s; (void)base; return 0; }
int   uxb_bigi_to_str(void* p, char* out, int out_len, int base) { (void)p; (void)out; (void)out_len; (void)base; return 0; }
int   uxb_bigi_add(void* out, void* a, void* b) { (void)out; (void)a; (void)b; return 0; }
int   uxb_bigi_sub(void* out, void* a, void* b) { (void)out; (void)a; (void)b; return 0; }
int   uxb_bigi_mul(void* out, void* a, void* b) { (void)out; (void)a; (void)b; return 0; }
int   uxb_bigi_tdiv_q(void* out, void* a, void* b) { (void)out; (void)a; (void)b; return 0; }
int   uxb_bigi_mod(void* out, void* a, void* b) { (void)out; (void)a; (void)b; return 0; }
int   uxb_bigi_cmp(void* a, void* b) { (void)a; (void)b; return 0; }

#endif
