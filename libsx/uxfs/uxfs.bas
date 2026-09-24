' Auto-maintained uXBasic wrapper for uxfs.dll
NAMESPACE uxfs

CONST DLL_NAME = "uxfs.dll"

FUNCTION Version() AS STRING
    RETURN CALL(DLL, "uxfs.dll", "uxfs_version", STRPTR, CDECL)
END FUNCTION

FUNCTION Exists(path AS STRING) AS I32
    RETURN CALL(DLL, "uxfs.dll", "uxfs_exists", I32, CDECL, "STRPTR", path)
END FUNCTION

FUNCTION FileExists(path AS STRING) AS I32
    RETURN CALL(DLL, "uxfs.dll", "uxfs_file_exists", I32, CDECL, "STRPTR", path)
END FUNCTION

FUNCTION DirectoryExists(path AS STRING) AS I32
    RETURN CALL(DLL, "uxfs.dll", "uxfs_directory_exists", I32, CDECL, "STRPTR", path)
END FUNCTION

FUNCTION CreateDirectory(path AS STRING) AS I32
    RETURN CALL(DLL, "uxfs.dll", "uxfs_create_directory", I32, CDECL, "STRPTR", path)
END FUNCTION

FUNCTION CreateDirectories(path AS STRING) AS I32
    RETURN CALL(DLL, "uxfs.dll", "uxfs_create_directories", I32, CDECL, "STRPTR", path)
END FUNCTION

FUNCTION DeleteFile(path AS STRING) AS I32
    RETURN CALL(DLL, "uxfs.dll", "uxfs_delete_file", I32, CDECL, "STRPTR", path)
END FUNCTION

FUNCTION RemoveDirectory(path AS STRING) AS I32
    RETURN CALL(DLL, "uxfs.dll", "uxfs_remove_directory", I32, CDECL, "STRPTR", path)
END FUNCTION

FUNCTION CopyFile(source AS STRING,target AS STRING,overwrite AS I32) AS I32
    RETURN CALL(DLL, "uxfs.dll", "uxfs_copy_file", I32, CDECL, "STRPTR,STRPTR,I32", source,target,overwrite)
END FUNCTION

FUNCTION Move(source AS STRING,target AS STRING,overwrite AS I32) AS I32
    RETURN CALL(DLL, "uxfs.dll", "uxfs_move", I32, CDECL, "STRPTR,STRPTR,I32", source,target,overwrite)
END FUNCTION

FUNCTION FileSize(path AS STRING) AS I64
    RETURN CALL(DLL, "uxfs.dll", "uxfs_file_size", I64, CDECL, "STRPTR", path)
END FUNCTION

FUNCTION GetAttributes(path AS STRING) AS U32
    RETURN CALL(DLL, "uxfs.dll", "uxfs_get_attributes", U32, CDECL, "STRPTR", path)
END FUNCTION

FUNCTION SetAttributes(path AS STRING,attributes AS U32) AS I32
    RETURN CALL(DLL, "uxfs.dll", "uxfs_set_attributes", I32, CDECL, "STRPTR,U32", path,attributes)
END FUNCTION

FUNCTION ReadAllText(path AS STRING) AS STRING
    RETURN CALL(DLL, "uxfs.dll", "uxfs_read_all_text", STRPTR, CDECL, "STRPTR", path)
END FUNCTION

FUNCTION WriteAllText(path AS STRING,text AS STRING) AS I32
    RETURN CALL(DLL, "uxfs.dll", "uxfs_write_all_text", I32, CDECL, "STRPTR,STRPTR", path,text)
END FUNCTION

FUNCTION AppendText(path AS STRING,text AS STRING) AS I32
    RETURN CALL(DLL, "uxfs.dll", "uxfs_append_text", I32, CDECL, "STRPTR,STRPTR", path,text)
END FUNCTION

FUNCTION EnumOpen(pattern AS STRING) AS U64
    RETURN CALL(DLL, "uxfs.dll", "uxfs_enum_open", U64, CDECL, "STRPTR", pattern)
END FUNCTION

FUNCTION EnumNext(handle AS U64) AS I32
    RETURN CALL(DLL, "uxfs.dll", "uxfs_enum_next", I32, CDECL, "U64", handle)
END FUNCTION

FUNCTION EnumName(handle AS U64) AS STRING
    RETURN CALL(DLL, "uxfs.dll", "uxfs_enum_name", STRPTR, CDECL, "U64", handle)
END FUNCTION

FUNCTION EnumIsDirectory(handle AS U64) AS I32
    RETURN CALL(DLL, "uxfs.dll", "uxfs_enum_is_directory", I32, CDECL, "U64", handle)
END FUNCTION

FUNCTION EnumSize(handle AS U64) AS U64
    RETURN CALL(DLL, "uxfs.dll", "uxfs_enum_size", U64, CDECL, "U64", handle)
END FUNCTION

SUB EnumClose(handle AS U64)
    CALL(DLL, "uxfs.dll", "uxfs_enum_close", VOID, CDECL, "U64", handle)
END SUB

FUNCTION ErrorText() AS STRING
    RETURN CALL(DLL, "uxfs.dll", "uxfs_error", STRPTR, CDECL)
END FUNCTION

END NAMESPACE
