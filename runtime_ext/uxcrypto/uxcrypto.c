#include "../cbase_common/uxb_cbase.h"
#include <sodium.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

typedef struct {
    unsigned char *data;
    size_t size;
} uxcrypto_blob;

static UXB_THREAD_LOCAL char g_error[1024];
static UXB_THREAD_LOCAL char g_text[crypto_pwhash_STRBYTES + 128];

static int ensure_init(void) {
    if (sodium_init() < 0) {
        snprintf(g_error, sizeof(g_error), "libsodium initialization failed");
        return 0;
    }
    return 1;
}

UXB_EXPORT const char *UXB_CALL uxcrypto_version(void) {
    return sodium_version_string();
}

UXB_EXPORT int32_t UXB_CALL uxcrypto_init(void) {
    return ensure_init();
}

UXB_EXPORT uxb_handle UXB_CALL uxcrypto_random(uint64_t size) {
    uxcrypto_blob *b;
    if (!ensure_init()) return 0;
    if (size > SIZE_MAX) return 0;
    b = (uxcrypto_blob *)calloc(1, sizeof(*b));
    if (!b) return 0;
    b->data = (unsigned char *)sodium_malloc((size_t)size ? (size_t)size : 1);
    if (!b->data) { free(b); return 0; }
    b->size = (size_t)size;
    if (b->size) randombytes_buf(b->data, b->size);
    return (uxb_handle)(uintptr_t)b;
}

UXB_EXPORT const void *UXB_CALL uxcrypto_blob_data(uxb_handle blob) {
    uxcrypto_blob *b = (uxcrypto_blob *)(uintptr_t)blob;
    return b ? b->data : NULL;
}

UXB_EXPORT uint64_t UXB_CALL uxcrypto_blob_size(uxb_handle blob) {
    uxcrypto_blob *b = (uxcrypto_blob *)(uintptr_t)blob;
    return b ? (uint64_t)b->size : 0;
}

UXB_EXPORT void UXB_CALL uxcrypto_blob_free(uxb_handle blob) {
    uxcrypto_blob *b = (uxcrypto_blob *)(uintptr_t)blob;
    if (!b) return;
    if (b->data) {
        sodium_memzero(b->data, b->size);
        sodium_free(b->data);
    }
    free(b);
}

UXB_EXPORT const char *UXB_CALL uxcrypto_sha256_hex(
    const void *data, uint64_t size
) {
    unsigned char hash[crypto_hash_sha256_BYTES];
    if (!ensure_init() || (!data && size)) return "";
    crypto_hash_sha256(hash, (const unsigned char *)data, (unsigned long long)size);
    sodium_bin2hex(g_text, sizeof(g_text), hash, sizeof(hash));
    sodium_memzero(hash, sizeof(hash));
    return g_text;
}

UXB_EXPORT const char *UXB_CALL uxcrypto_sha256_text(const char *text) {
    if (!text) text = "";
    return uxcrypto_sha256_hex(text, (uint64_t)strlen(text));
}

UXB_EXPORT const char *UXB_CALL uxcrypto_password_hash(const char *password) {
    if (!ensure_init() || !password) return "";
    if (crypto_pwhash_str(
            g_text,
            password,
            (unsigned long long)strlen(password),
            crypto_pwhash_OPSLIMIT_INTERACTIVE,
            crypto_pwhash_MEMLIMIT_INTERACTIVE
        ) != 0) {
        snprintf(g_error, sizeof(g_error), "password hashing failed");
        return "";
    }
    return g_text;
}

UXB_EXPORT int32_t UXB_CALL uxcrypto_password_verify(
    const char *encoded_hash, const char *password
) {
    if (!ensure_init() || !encoded_hash || !password) return 0;
    return crypto_pwhash_str_verify(
        encoded_hash, password, (unsigned long long)strlen(password)
    ) == 0;
}

UXB_EXPORT uxb_handle UXB_CALL uxcrypto_secretbox_encrypt(
    const void *message, uint64_t message_size,
    const void *key, uint64_t key_size
) {
    uxcrypto_blob *b;
    unsigned char *nonce;
    unsigned char *cipher;
    if (!ensure_init() || (!message && message_size) || !key) return 0;
    if (key_size != crypto_secretbox_KEYBYTES) {
        snprintf(g_error, sizeof(g_error), "secretbox key must be 32 bytes");
        return 0;
    }

    b = (uxcrypto_blob *)calloc(1, sizeof(*b));
    if (!b) return 0;
    b->size =
        crypto_secretbox_NONCEBYTES +
        crypto_secretbox_MACBYTES +
        (size_t)message_size;
    b->data = (unsigned char *)sodium_malloc(b->size);
    if (!b->data) { free(b); return 0; }

    nonce = b->data;
    cipher = b->data + crypto_secretbox_NONCEBYTES;
    randombytes_buf(nonce, crypto_secretbox_NONCEBYTES);

    if (crypto_secretbox_easy(
            cipher,
            (const unsigned char *)message,
            (unsigned long long)message_size,
            nonce,
            (const unsigned char *)key
        ) != 0) {
        uxcrypto_blob_free((uxb_handle)(uintptr_t)b);
        return 0;
    }
    return (uxb_handle)(uintptr_t)b;
}

UXB_EXPORT uxb_handle UXB_CALL uxcrypto_secretbox_decrypt(
    const void *encrypted, uint64_t encrypted_size,
    const void *key, uint64_t key_size
) {
    uxcrypto_blob *b;
    const unsigned char *nonce;
    const unsigned char *cipher;
    size_t message_size;

    if (!ensure_init() || !encrypted || !key) return 0;
    if (key_size != crypto_secretbox_KEYBYTES) {
        snprintf(g_error, sizeof(g_error), "secretbox key must be 32 bytes");
        return 0;
    }
    if (encrypted_size <
        crypto_secretbox_NONCEBYTES + crypto_secretbox_MACBYTES) {
        snprintf(g_error, sizeof(g_error), "encrypted buffer is too short");
        return 0;
    }

    nonce = (const unsigned char *)encrypted;
    cipher = nonce + crypto_secretbox_NONCEBYTES;
    message_size =
        (size_t)encrypted_size -
        crypto_secretbox_NONCEBYTES -
        crypto_secretbox_MACBYTES;

    b = (uxcrypto_blob *)calloc(1, sizeof(*b));
    if (!b) return 0;
    b->data = (unsigned char *)sodium_malloc(message_size ? message_size : 1);
    if (!b->data) { free(b); return 0; }
    b->size = message_size;

    if (crypto_secretbox_open_easy(
            b->data,
            cipher,
            (unsigned long long)(
                encrypted_size - crypto_secretbox_NONCEBYTES
            ),
            nonce,
            (const unsigned char *)key
        ) != 0) {
        snprintf(g_error, sizeof(g_error), "authentication failed");
        uxcrypto_blob_free((uxb_handle)(uintptr_t)b);
        return 0;
    }
    return (uxb_handle)(uintptr_t)b;
}

UXB_EXPORT const char *UXB_CALL uxcrypto_error(void) {
    return g_error;
}
