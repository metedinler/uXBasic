' Auto-maintained uXBasic wrapper for uxpath.dll
NAMESPACE uxpath

CONST DLL_NAME = "uxpath.dll"

FUNCTION Version() AS STRING
    RETURN CALL(DLL, "uxpath.dll", "uxpath_version", STRPTR, CDECL)
END FUNCTION

FUNCTION Join(a AS STRING,b AS STRING) AS STRING
    RETURN CALL(DLL, "uxpath.dll", "uxpath_join", STRPTR, CDECL, "STRPTR,STRPTR", a,b)
END FUNCTION

FUNCTION Combine3(a AS STRING,b AS STRING,c AS STRING) AS STRING
    RETURN CALL(DLL, "uxpath.dll", "uxpath_combine3", STRPTR, CDECL, "STRPTR,STRPTR,STRPTR", a,b,c)
END FUNCTION

FUNCTION Full(path AS STRING) AS STRING
    RETURN CALL(DLL, "uxpath.dll", "uxpath_full", STRPTR, CDECL, "STRPTR", path)
END FUNCTION

FUNCTION Normalize(path AS STRING) AS STRING
    RETURN CALL(DLL, "uxpath.dll", "uxpath_normalize", STRPTR, CDECL, "STRPTR", path)
END FUNCTION

FUNCTION IsAbsolute(path AS STRING) AS I32
    RETURN CALL(DLL, "uxpath.dll", "uxpath_is_absolute", I32, CDECL, "STRPTR", path)
END FUNCTION

FUNCTION FileName(path AS STRING) AS STRING
    RETURN CALL(DLL, "uxpath.dll", "uxpath_filename", STRPTR, CDECL, "STRPTR", path)
END FUNCTION

FUNCTION DirectoryName(path AS STRING) AS STRING
    RETURN CALL(DLL, "uxpath.dll", "uxpath_directory", STRPTR, CDECL, "STRPTR", path)
END FUNCTION

FUNCTION Extension(path AS STRING) AS STRING
    RETURN CALL(DLL, "uxpath.dll", "uxpath_extension", STRPTR, CDECL, "STRPTR", path)
END FUNCTION

FUNCTION Stem(path AS STRING) AS STRING
    RETURN CALL(DLL, "uxpath.dll", "uxpath_stem", STRPTR, CDECL, "STRPTR", path)
END FUNCTION

FUNCTION ChangeExtension(path AS STRING,ext AS STRING) AS STRING
    RETURN CALL(DLL, "uxpath.dll", "uxpath_change_extension", STRPTR, CDECL, "STRPTR,STRPTR", path,ext)
END FUNCTION

FUNCTION HasExtension(path AS STRING,ext AS STRING) AS I32
    RETURN CALL(DLL, "uxpath.dll", "uxpath_has_extension", I32, CDECL, "STRPTR,STRPTR", path,ext)
END FUNCTION

FUNCTION IsInside(rootPath AS STRING,childPath AS STRING) AS I32
    RETURN CALL(DLL, "uxpath.dll", "uxpath_is_inside", I32, CDECL, "STRPTR,STRPTR", rootPath,childPath)
END FUNCTION

FUNCTION ErrorText() AS STRING
    RETURN CALL(DLL, "uxpath.dll", "uxpath_error", STRPTR, CDECL)
END FUNCTION

END NAMESPACE