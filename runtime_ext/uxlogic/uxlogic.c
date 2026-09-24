#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define UX_EXPORT __declspec(dllexport)
typedef struct lua_State lua_State;
typedef long long lua_Integer;
typedef double lua_Number;
typedef int (__cdecl *lua_CFunction)(lua_State *);
typedef intptr_t lua_KContext;
typedef int (__cdecl *lua_KFunction)(lua_State *, int, lua_KContext);

static HMODULE uxLua;
static SRWLOCK uxLuaLoadLock = SRWLOCK_INIT;
static char uxError[1024];
static char uxText[16384];

static lua_State *(__cdecl *p_luaL_newstate)(void);
static void (__cdecl *p_luaL_openlibs)(lua_State *);
static void (__cdecl *p_lua_close)(lua_State *);
static int (__cdecl *p_luaL_loadstring)(lua_State *, const char *);
static int (__cdecl *p_luaL_loadfilex)(lua_State *, const char *, const char *);
static int (__cdecl *p_lua_pcallk)(lua_State *, int, int, int, lua_KContext, lua_KFunction);
static int (__cdecl *p_lua_getglobal)(lua_State *, const char *);
static void (__cdecl *p_lua_setglobal)(lua_State *, const char *);
static lua_Number (__cdecl *p_lua_tonumberx)(lua_State *, int, int *);
static const char *(__cdecl *p_lua_tolstring)(lua_State *, int, size_t *);
static void (__cdecl *p_lua_pushnumber)(lua_State *, lua_Number);
static const char *(__cdecl *p_lua_pushstring)(lua_State *, const char *);
static void (__cdecl *p_lua_settop)(lua_State *, int);

static FARPROC ux_symbol(HMODULE module, const char *name)
{
    FARPROC symbol = GetProcAddress(module, name);
    if (!symbol) snprintf(uxError, sizeof(uxError), "Lua symbol missing: %s", name);
    return symbol;
}

UX_EXPORT int uxlogic_version(void) { return 110; }
UX_EXPORT const char *uxlogic_last_error(void) { return uxError; }
UX_EXPORT const char *uxlogic_last_text(void) { return uxText; }

UX_EXPORT int uxlogic_lua_load(const char *dllPath)
{
    HMODULE candidate;
    AcquireSRWLockExclusive(&uxLuaLoadLock);
    uxError[0] = '\0';
    if (uxLua) {
        ReleaseSRWLockExclusive(&uxLuaLoadLock);
        return 1;
    }
    candidate = LoadLibraryA((dllPath && dllPath[0]) ? dllPath : "lua54.dll");
    if (!candidate) {
        snprintf(uxError, sizeof(uxError), "LoadLibrary failed for %s (%lu)",
                 (dllPath && dllPath[0]) ? dllPath : "lua54.dll",
                 (unsigned long)GetLastError());
        ReleaseSRWLockExclusive(&uxLuaLoadLock);
        return 0;
    }
#define UX_LUA_LOAD(name) do { \
    FARPROC resolved = ux_symbol(candidate, #name); \
    memcpy(&p_##name, &resolved, sizeof(p_##name)); \
    if (!p_##name) goto load_failed; \
} while (0)
    UX_LUA_LOAD(luaL_newstate);
    UX_LUA_LOAD(luaL_openlibs);
    UX_LUA_LOAD(lua_close);
    UX_LUA_LOAD(luaL_loadstring);
    UX_LUA_LOAD(luaL_loadfilex);
    UX_LUA_LOAD(lua_pcallk);
    UX_LUA_LOAD(lua_getglobal);
    UX_LUA_LOAD(lua_setglobal);
    UX_LUA_LOAD(lua_tonumberx);
    UX_LUA_LOAD(lua_tolstring);
    UX_LUA_LOAD(lua_pushnumber);
    UX_LUA_LOAD(lua_pushstring);
    UX_LUA_LOAD(lua_settop);
#undef UX_LUA_LOAD
    /* Publish only after every entry point is available. A failed candidate
       must not make a retry (or lua_new) observe a loaded Lua runtime. */
    uxLua = candidate;
    ReleaseSRWLockExclusive(&uxLuaLoadLock);
    return 1;
load_failed:
    FreeLibrary(candidate);
    p_luaL_newstate = NULL;
    p_luaL_openlibs = NULL;
    p_lua_close = NULL;
    p_luaL_loadstring = NULL;
    p_luaL_loadfilex = NULL;
    p_lua_pcallk = NULL;
    p_lua_getglobal = NULL;
    p_lua_setglobal = NULL;
    p_lua_tonumberx = NULL;
    p_lua_tolstring = NULL;
    p_lua_pushnumber = NULL;
    p_lua_pushstring = NULL;
    p_lua_settop = NULL;
    ReleaseSRWLockExclusive(&uxLuaLoadLock);
    return 0;
}

UX_EXPORT unsigned long long uxlogic_lua_new(void)
{
    if (!uxlogic_lua_load(NULL)) return 0;
    lua_State *state = p_luaL_newstate();
    if (state) p_luaL_openlibs(state);
    return (unsigned long long)(uintptr_t)state;
}

UX_EXPORT void uxlogic_lua_close(unsigned long long handle)
{
    if (handle && p_lua_close) p_lua_close((lua_State *)(uintptr_t)handle);
}

static int ux_lua_finish(lua_State *state, int loadStatus)
{
    int status = loadStatus;
    if (status == 0) status = p_lua_pcallk(state, 0, -1, 0, 0, NULL);
    if (status != 0) {
        const char *message = p_lua_tolstring(state, -1, NULL);
        snprintf(uxError, sizeof(uxError), "%s", message ? message : "Lua error");
        p_lua_settop(state, -2);
        return 0;
    }
    return 1;
}

UX_EXPORT int uxlogic_lua_do_string(unsigned long long handle, const char *code)
{
    lua_State *state = (lua_State *)(uintptr_t)handle;
    return (state && code) ? ux_lua_finish(state, p_luaL_loadstring(state, code)) : 0;
}

UX_EXPORT int uxlogic_lua_do_file(unsigned long long handle, const char *path)
{
    lua_State *state = (lua_State *)(uintptr_t)handle;
    return (state && path) ? ux_lua_finish(state, p_luaL_loadfilex(state, path, NULL)) : 0;
}

UX_EXPORT double uxlogic_lua_get_number(unsigned long long handle, const char *name)
{
    lua_State *state = (lua_State *)(uintptr_t)handle;
    int isNumber = 0;
    if (!state || !name) return 0.0;
    p_lua_getglobal(state, name);
    double value = p_lua_tonumberx(state, -1, &isNumber);
    p_lua_settop(state, -2);
    return isNumber ? value : 0.0;
}

UX_EXPORT const char *uxlogic_lua_get_string(unsigned long long handle, const char *name)
{
    lua_State *state = (lua_State *)(uintptr_t)handle;
    uxText[0] = '\0';
    if (!state || !name) return uxText;
    p_lua_getglobal(state, name);
    const char *value = p_lua_tolstring(state, -1, NULL);
    if (value) snprintf(uxText, sizeof(uxText), "%s", value);
    p_lua_settop(state, -2);
    return uxText;
}

UX_EXPORT void uxlogic_lua_set_number(unsigned long long handle, const char *name, double value)
{
    lua_State *state = (lua_State *)(uintptr_t)handle;
    if (!state || !name) return;
    p_lua_pushnumber(state, value);
    p_lua_setglobal(state, name);
}

static int ux_has_unsafe_shell_text(const char *value)
{
    if (!value || !value[0]) return 1;
    return strchr(value, '"') != NULL || strchr(value, '\r') != NULL || strchr(value, '\n') != NULL;
}

static int ux_resolve_swipl(char *output, size_t outputSize)
{
    const char *configured = getenv("UXB_SWIPL");
    DWORD found;
    if (configured && configured[0] && GetFileAttributesA(configured) != INVALID_FILE_ATTRIBUTES) {
        snprintf(output, outputSize, "%s", configured);
        return 1;
    }
    found = SearchPathA(NULL, "swipl.exe", NULL, (DWORD)outputSize, output, NULL);
    if (found > 0 && found < outputSize) return 1;
    configured = getenv("ProgramFiles");
    if (configured && configured[0]) {
        snprintf(output, outputSize, "%s\\swipl\\bin\\swipl.exe", configured);
        if (GetFileAttributesA(output) != INVALID_FILE_ATTRIBUTES) return 1;
    }
    snprintf(uxError, sizeof(uxError), "swipl.exe not found; set UXB_SWIPL or add SWI-Prolog to PATH");
    return 0;
}

UX_EXPORT int uxlogic_prolog_query_ex(const char *swiplPath, const char *scriptPath, const char *goal)
{
    char command[8192];
    SECURITY_ATTRIBUTES security;
    STARTUPINFOA startup;
    PROCESS_INFORMATION process;
    HANDLE readPipe = NULL;
    HANDLE writePipe = NULL;
    DWORD bytesRead = 0;
    DWORD exitCode = 1;
    char discard[1024];
    size_t used = 0;

    uxText[0] = '\0';
    uxError[0] = '\0';
    if (ux_has_unsafe_shell_text(swiplPath) || ux_has_unsafe_shell_text(scriptPath) || ux_has_unsafe_shell_text(goal)) {
        snprintf(uxError, sizeof(uxError), "SWI-Prolog path/script/goal contains an unsupported quote or newline");
        return 0;
    }
    snprintf(command, sizeof(command), "\"%s\" -q -s \"%s\" -g \"%s\" -t halt", swiplPath, scriptPath, goal);

    ZeroMemory(&security, sizeof(security));
    security.nLength = sizeof(security);
    security.bInheritHandle = TRUE;
    if (!CreatePipe(&readPipe, &writePipe, &security, 0) ||
        !SetHandleInformation(readPipe, HANDLE_FLAG_INHERIT, 0)) {
        snprintf(uxError, sizeof(uxError), "SWI-Prolog output pipe could not be created (%lu)", (unsigned long)GetLastError());
        if (readPipe) CloseHandle(readPipe);
        if (writePipe) CloseHandle(writePipe);
        return 0;
    }

    ZeroMemory(&startup, sizeof(startup));
    startup.cb = sizeof(startup);
    startup.dwFlags = STARTF_USESTDHANDLES;
    startup.hStdOutput = writePipe;
    startup.hStdError = writePipe;
    startup.hStdInput = GetStdHandle(STD_INPUT_HANDLE);
    ZeroMemory(&process, sizeof(process));

    if (!CreateProcessA(NULL, command, NULL, NULL, TRUE, CREATE_NO_WINDOW, NULL, NULL, &startup, &process)) {
        snprintf(uxError, sizeof(uxError), "SWI-Prolog process could not start (%lu)", (unsigned long)GetLastError());
        CloseHandle(readPipe);
        CloseHandle(writePipe);
        return 0;
    }
    CloseHandle(writePipe);
    writePipe = NULL;

    while (ReadFile(readPipe, discard, sizeof(discard), &bytesRead, NULL) && bytesRead > 0) {
        size_t available = sizeof(uxText) - used - 1;
        size_t copyBytes = bytesRead < available ? (size_t)bytesRead : available;
        if (copyBytes > 0) {
            memcpy(uxText + used, discard, copyBytes);
            used += copyBytes;
            uxText[used] = '\0';
        }
    }
    WaitForSingleObject(process.hProcess, INFINITE);
    GetExitCodeProcess(process.hProcess, &exitCode);
    CloseHandle(readPipe);
    CloseHandle(process.hThread);
    CloseHandle(process.hProcess);

    if (exitCode != 0) {
        snprintf(uxError, sizeof(uxError), "SWI-Prolog exit=%lu: %.800s", (unsigned long)exitCode, uxText);
        return 0;
    }
    return 1;
}

UX_EXPORT int uxlogic_prolog_query(const char *scriptPath, const char *goal)
{
    char swipl[MAX_PATH * 2];
    if (!ux_resolve_swipl(swipl, sizeof(swipl))) return 0;
    return uxlogic_prolog_query_ex(swipl, scriptPath, goal);
}

UX_EXPORT double uxlogic_fuzzy_triangle(double x, double a, double b, double c)
{
    if (a > b || b > c || a == c) return 0.0;
    if (x == b) return 1.0;
    if (x <= a || x >= c) return 0.0;
    if (x < b) return (b == a) ? 1.0 : (x - a) / (b - a);
    return (c == b) ? 1.0 : (c - x) / (c - b);
}

UX_EXPORT double uxlogic_fuzzy_trapezoid(double x, double a, double b, double c, double d)
{
    if (a > b || b > c || c > d || a == d) return 0.0;
    if (x < a || x > d) return 0.0;
    if (x >= b && x <= c) return 1.0;
    if (x < b) return (b == a) ? 1.0 : (x - a) / (b - a);
    return (d == c) ? 1.0 : (d - x) / (d - c);
}

UX_EXPORT double uxlogic_fuzzy_and(double a, double b) { return a < b ? a : b; }
UX_EXPORT double uxlogic_fuzzy_or(double a, double b) { return a > b ? a : b; }
UX_EXPORT double uxlogic_fuzzy_not(double value) { return 1.0 - value; }
UX_EXPORT double uxlogic_fuzzy_weighted(double value1, double weight1,
                                        double value2, double weight2)
{
    double total = weight1 + weight2;
    return total == 0.0 ? 0.0 : (value1 * weight1 + value2 * weight2) / total;
}
