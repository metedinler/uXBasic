NAMESPACE uxcrypto

FUNCTION Version() AS STRING
    RETURN CALL(DLL, "uxcrypto.dll", "uxcrypto_version", STRPTR, CDECL)
END FUNCTION

FUNCTION Initialize() AS I32
    RETURN CALL(DLL, "uxcrypto.dll", "uxcrypto_init", I32, CDECL)
END FUNCTION

FUNCTION RandomBlob(size AS U64) AS U64
    RETURN CALL(DLL, "uxcrypto.dll", "uxcrypto_random", PTR, CDECL, "U64", size)
END FUNCTION

FUNCTION BlobData(blob AS U64) AS U64
    RETURN CALL(DLL, "uxcrypto.dll", "uxcrypto_blob_data", PTR, CDECL, "PTR", blob)
END FUNCTION

FUNCTION BlobSize(blob AS U64) AS U64
    RETURN CALL(DLL, "uxcrypto.dll", "uxcrypto_blob_size", U64, CDECL, "PTR", blob)
END FUNCTION

SUB BlobFree(blob AS U64)
    CALL(DLL, "uxcrypto.dll", "uxcrypto_blob_free", VOID, CDECL, "PTR", blob)
END SUB

FUNCTION Sha256Hex(dataPtr AS U64, size AS U64) AS STRING
    RETURN CALL(DLL, "uxcrypto.dll", "uxcrypto_sha256_hex", STRPTR, CDECL, "PTR,U64", dataPtr, size)
END FUNCTION

FUNCTION Sha256Text(text AS STRING) AS STRING
    RETURN CALL(DLL, "uxcrypto.dll", "uxcrypto_sha256_text", STRPTR, CDECL, "STRPTR", text)
END FUNCTION

FUNCTION PasswordHash(password AS STRING) AS STRING
    RETURN CALL(DLL, "uxcrypto.dll", "uxcrypto_password_hash", STRPTR, CDECL, "STRPTR", password)
END FUNCTION

FUNCTION PasswordVerify(encodedHash AS STRING, password AS STRING) AS I32
    RETURN CALL(DLL, "uxcrypto.dll", "uxcrypto_password_verify", I32, CDECL, "STRPTR,STRPTR", encodedHash, password)
END FUNCTION

FUNCTION SecretboxEncrypt(messagePtr AS U64, messageSize AS U64, keyPtr AS U64, keySize AS U64) AS U64
    RETURN CALL(DLL, "uxcrypto.dll", "uxcrypto_secretbox_encrypt", PTR, CDECL, "PTR,U64,PTR,U64", messagePtr, messageSize, keyPtr, keySize)
END FUNCTION

FUNCTION SecretboxDecrypt(encryptedPtr AS U64, encryptedSize AS U64, keyPtr AS U64, keySize AS U64) AS U64
    RETURN CALL(DLL, "uxcrypto.dll", "uxcrypto_secretbox_decrypt", PTR, CDECL, "PTR,U64,PTR,U64", encryptedPtr, encryptedSize, keyPtr, keySize)
END FUNCTION

FUNCTION ErrorText() AS STRING
    RETURN CALL(DLL, "uxcrypto.dll", "uxcrypto_error", STRPTR, CDECL)
END FUNCTION

END NAMESPACE
