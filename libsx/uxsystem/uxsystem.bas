' Auto-maintained uXBasic wrapper for uxsystem.dll
NAMESPACE uxsystem

CONST DLL_NAME = "uxsystem.dll"

FUNCTION Version() AS STRING
    RETURN CALL(DLL, "uxsystem.dll", "uxsystem_version", STRPTR, CDECL)
END FUNCTION

FUNCTION ComputerName() AS STRING
    RETURN CALL(DLL, "uxsystem.dll", "uxsystem_computer_name", STRPTR, CDECL)
END FUNCTION

FUNCTION UserName() AS STRING
    RETURN CALL(DLL, "uxsystem.dll", "uxsystem_user_name", STRPTR, CDECL)
END FUNCTION

FUNCTION WindowsDirectory() AS STRING
    RETURN CALL(DLL, "uxsystem.dll", "uxsystem_windows_directory", STRPTR, CDECL)
END FUNCTION

FUNCTION SystemDirectory() AS STRING
    RETURN CALL(DLL, "uxsystem.dll", "uxsystem_system_directory", STRPTR, CDECL)
END FUNCTION

FUNCTION TempDirectory() AS STRING
    RETURN CALL(DLL, "uxsystem.dll", "uxsystem_temp_directory", STRPTR, CDECL)
END FUNCTION

FUNCTION CurrentDirectory() AS STRING
    RETURN CALL(DLL, "uxsystem.dll", "uxsystem_current_directory", STRPTR, CDECL)
END FUNCTION

FUNCTION SetCurrentDirectory(path AS STRING) AS I32
    RETURN CALL(DLL, "uxsystem.dll", "uxsystem_set_current_directory", I32, CDECL, "STRPTR", path)
END FUNCTION

FUNCTION ExecutablePath() AS STRING
    RETURN CALL(DLL, "uxsystem.dll", "uxsystem_executable_path", STRPTR, CDECL)
END FUNCTION

FUNCTION EnvironmentGet(name AS STRING) AS STRING
    RETURN CALL(DLL, "uxsystem.dll", "uxsystem_environment_get", STRPTR, CDECL, "STRPTR", name)
END FUNCTION

FUNCTION EnvironmentSet(name AS STRING,value AS STRING) AS I32
    RETURN CALL(DLL, "uxsystem.dll", "uxsystem_environment_set", I32, CDECL, "STRPTR,STRPTR", name,value)
END FUNCTION

FUNCTION EnvironmentDelete(name AS STRING) AS I32
    RETURN CALL(DLL, "uxsystem.dll", "uxsystem_environment_delete", I32, CDECL, "STRPTR", name)
END FUNCTION

FUNCTION CpuCount() AS I32
    RETURN CALL(DLL, "uxsystem.dll", "uxsystem_cpu_count", I32, CDECL)
END FUNCTION

FUNCTION Architecture() AS I32
    RETURN CALL(DLL, "uxsystem.dll", "uxsystem_architecture", I32, CDECL)
END FUNCTION

FUNCTION MemoryTotal() AS U64
    RETURN CALL(DLL, "uxsystem.dll", "uxsystem_memory_total", U64, CDECL)
END FUNCTION

FUNCTION MemoryAvailable() AS U64
    RETURN CALL(DLL, "uxsystem.dll", "uxsystem_memory_available", U64, CDECL)
END FUNCTION

FUNCTION MemoryLoadPercent() AS I32
    RETURN CALL(DLL, "uxsystem.dll", "uxsystem_memory_load_percent", I32, CDECL)
END FUNCTION

FUNCTION Is64Bit() AS I32
    RETURN CALL(DLL, "uxsystem.dll", "uxsystem_is_64bit", I32, CDECL)
END FUNCTION

FUNCTION IsAdministrator() AS I32
    RETURN CALL(DLL, "uxsystem.dll", "uxsystem_is_admin", I32, CDECL)
END FUNCTION

FUNCTION ProcessId() AS U32
    RETURN CALL(DLL, "uxsystem.dll", "uxsystem_process_id", U32, CDECL)
END FUNCTION

FUNCTION ThreadId() AS U32
    RETURN CALL(DLL, "uxsystem.dll", "uxsystem_thread_id", U32, CDECL)
END FUNCTION

FUNCTION TickCountMs() AS U64
    RETURN CALL(DLL, "uxsystem.dll", "uxsystem_tick_count_ms", U64, CDECL)
END FUNCTION

FUNCTION ScreenWidth() AS I32
    RETURN CALL(DLL, "uxsystem.dll", "uxsystem_screen_width", I32, CDECL)
END FUNCTION

FUNCTION ScreenHeight() AS I32
    RETURN CALL(DLL, "uxsystem.dll", "uxsystem_screen_height", I32, CDECL)
END FUNCTION

FUNCTION ErrorText() AS STRING
    RETURN CALL(DLL, "uxsystem.dll", "uxsystem_error", STRPTR, CDECL)
END FUNCTION

END NAMESPACE