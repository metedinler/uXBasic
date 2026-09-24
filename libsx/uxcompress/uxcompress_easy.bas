NAMESPACE uxcompress

FUNCTION Version() AS STRING
    RETURN CALL(DLL, "uxcompress.dll", "uxcompress_version", STRPTR, CDECL)
END FUNCTION

FUNCTION Compress(sourcePtr AS U64, sourceSize AS U64, level AS I32) AS U64
    RETURN CALL(DLL, "uxcompress.dll", "uxcompress_buffer", PTR, CDECL, "PTR,U64,I32", sourcePtr, sourceSize, level)
END FUNCTION

FUNCTION CompressText(sourceText AS STRING, level AS I32) AS U64
    RETURN CALL(DLL, "uxcompress.dll", "uxcompress_string", PTR, CDECL, "STRPTR,I32", sourceText, level)
END FUNCTION

FUNCTION Decompress(sourcePtr AS U64, sourceSize AS U64, expectedSize AS U64) AS U64
    RETURN CALL(DLL, "uxcompress.dll", "uxdecompress_buffer", PTR, CDECL, "PTR,U64,U64", sourcePtr, sourceSize, expectedSize)
END FUNCTION

FUNCTION BlobData(blob AS U64) AS U64
    RETURN CALL(DLL, "uxcompress.dll", "uxcompress_blob_data", PTR, CDECL, "PTR", blob)
END FUNCTION

FUNCTION BlobSize(blob AS U64) AS U64
    RETURN CALL(DLL, "uxcompress.dll", "uxcompress_blob_size", U64, CDECL, "PTR", blob)
END FUNCTION

SUB BlobFree(blob AS U64)
    CALL(DLL, "uxcompress.dll", "uxcompress_blob_free", VOID, CDECL, "PTR", blob)
END SUB

FUNCTION CompressFile(sourcePath AS STRING, targetPath AS STRING, level AS I32) AS I32
    RETURN CALL(DLL, "uxcompress.dll", "uxcompress_file", I32, CDECL, "STRPTR,STRPTR,I32", sourcePath, targetPath, level)
END FUNCTION

FUNCTION DecompressFile(sourcePath AS STRING, targetPath AS STRING) AS I32
    RETURN CALL(DLL, "uxcompress.dll", "uxdecompress_file", I32, CDECL, "STRPTR,STRPTR", sourcePath, targetPath)
END FUNCTION

FUNCTION ErrorText() AS STRING
    RETURN CALL(DLL, "uxcompress.dll", "uxcompress_error", STRPTR, CDECL)
END FUNCTION

END NAMESPACE
