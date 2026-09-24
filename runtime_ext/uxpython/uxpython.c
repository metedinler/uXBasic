#ifndef _WIN32
#define _POSIX_C_SOURCE 200809L
#endif

#include "uxpython.h"

#include <errno.h>
#include <inttypes.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifdef _WIN32
#ifndef WIN32_LEAN_AND_MEAN
#define WIN32_LEAN_AND_MEAN
#endif
#include <windows.h>
#define PYCALL __cdecl
#else
#include <dlfcn.h>
#include <pthread.h>
#define PYCALL
#endif

typedef intptr_t Py_ssize_t;
typedef struct _object PyObject;
typedef struct _ts PyThreadState;
typedef int PyGILState_STATE;

#ifdef _WIN32
typedef HMODULE ux_library_t;
#else
typedef void *ux_library_t;
#endif

typedef struct PythonApi {
    ux_library_t library;
    char loaded_path[1024];
    int initialized;
    int finalized;
    PyThreadState *main_thread_state;

    void (PYCALL *Py_Initialize)(void);
    int (PYCALL *Py_IsInitialized)(void);
    int (PYCALL *Py_FinalizeEx)(void);
    PyThreadState *(PYCALL *PyEval_SaveThread)(void);
    PyGILState_STATE (PYCALL *PyGILState_Ensure)(void);
    void (PYCALL *PyGILState_Release)(PyGILState_STATE);

    PyObject *(PYCALL *PyImport_ImportModule)(const char *);
    PyObject *(PYCALL *PyObject_GetAttrString)(PyObject *, const char *);
    PyObject *(PYCALL *PyObject_Call)(PyObject *, PyObject *, PyObject *);
    PyObject *(PYCALL *PyObject_Str)(PyObject *);
    PyObject *(PYCALL *PyUnicode_FromString)(const char *);
    const char *(PYCALL *PyUnicode_AsUTF8)(PyObject *);
    PyObject *(PYCALL *PyTuple_New)(Py_ssize_t);
    int (PYCALL *PyTuple_SetItem)(PyObject *, Py_ssize_t, PyObject *);
    Py_ssize_t (PYCALL *PyList_Size)(PyObject *);
    PyObject *(PYCALL *PyList_AsTuple)(PyObject *);
    Py_ssize_t (PYCALL *PyDict_Size)(PyObject *);
    PyObject *(PYCALL *PySys_GetObject)(const char *);
    int (PYCALL *PyList_Insert)(PyObject *, Py_ssize_t, PyObject *);
    int64_t (PYCALL *PyLong_AsLongLong)(PyObject *);
    double (PYCALL *PyFloat_AsDouble)(PyObject *);
    PyObject *(PYCALL *PyErr_Occurred)(void);
    void (PYCALL *PyErr_Fetch)(PyObject **, PyObject **, PyObject **);
    void (PYCALL *PyErr_NormalizeException)(PyObject **, PyObject **, PyObject **);
    void (PYCALL *PyErr_Clear)(void);
    void (PYCALL *Py_IncRef)(PyObject *);
    void (PYCALL *Py_DecRef)(PyObject *);
    const char *(PYCALL *Py_GetVersion)(void);

    int *Py_IsolatedFlag;
    int *Py_IgnoreEnvironmentFlag;
    int *Py_NoSiteFlag;

    PyObject *json_module;
    PyObject *json_loads;
    PyObject *json_dumps;
    PyObject *json_dump_kwargs;
} PythonApi;

#define UXPYTHON_MAX_SESSIONS 64
#define UXPYTHON_MAX_OBJECTS 8192
#define UXPYTHON_ERROR_CAPACITY 8192

#ifdef _WIN32
static INIT_ONCE g_lock_once = INIT_ONCE_STATIC_INIT;
static CRITICAL_SECTION g_lock;
static BOOL CALLBACK uxpython_init_lock_once(PINIT_ONCE once, PVOID parameter, PVOID *context) {
    (void)once;
    (void)parameter;
    (void)context;
    InitializeCriticalSection(&g_lock);
    return TRUE;
}
static void lock_global(void) {
    InitOnceExecuteOnce(&g_lock_once, uxpython_init_lock_once, NULL, NULL);
    EnterCriticalSection(&g_lock);
}
static void unlock_global(void) { LeaveCriticalSection(&g_lock); }
#else
static pthread_mutex_t g_lock = PTHREAD_MUTEX_INITIALIZER;
static void lock_global(void) { pthread_mutex_lock(&g_lock); }
static void unlock_global(void) { pthread_mutex_unlock(&g_lock); }
#endif

typedef struct PythonSession {
    uint32_t generation;
    int active;
    int flags;
    char error[UXPYTHON_ERROR_CAPACITY];
} PythonSession;

typedef struct PythonObjectEntry {
    uint32_t generation;
    int active;
    uint32_t session_index;
    PyObject *object;
} PythonObjectEntry;

static PythonApi g_api;
static PythonSession g_sessions[UXPYTHON_MAX_SESSIONS];
static PythonObjectEntry g_objects[UXPYTHON_MAX_OBJECTS];
static char g_global_error[UXPYTHON_ERROR_CAPACITY];
static _Thread_local char *g_return_text;
static _Thread_local size_t g_return_capacity;

static const char *copy_return_text(const char *text) {
    if (text == NULL) text = "";
    size_t need = strlen(text) + 1U;
    if (need > g_return_capacity) {
        size_t capacity = need < 256U ? 256U : need;
        char *replacement = (char *)realloc(g_return_text, capacity);
        if (replacement == NULL) return "";
        g_return_text = replacement;
        g_return_capacity = capacity;
    }
    memcpy(g_return_text, text, need);
    return g_return_text;
}

static uint64_t make_token(uint32_t index, uint32_t generation) {
    return ((uint64_t)generation << 32) | (uint64_t)(index + 1U);
}

static int decode_token(uint64_t token, uint32_t limit, uint32_t *index_out, uint32_t *generation_out) {
    uint32_t low = (uint32_t)(token & UINT64_C(0xffffffff));
    uint32_t generation = (uint32_t)(token >> 32);
    if (low == 0U || low > limit || generation == 0U) return 0;
    *index_out = low - 1U;
    *generation_out = generation;
    return 1;
}

static void copy_text(char *destination, size_t capacity, const char *source) {
    if (capacity == 0U) return;
    if (source == NULL) source = "";
    size_t length = strlen(source);
    if (length >= capacity) length = capacity - 1U;
    memcpy(destination, source, length);
    destination[length] = '\0';
}

static void set_global_error(const char *message) {
    lock_global();
    copy_text(g_global_error, sizeof(g_global_error), message);
    unlock_global();
}

static int session_index_from_token(uint64_t token, uint32_t *index_out) {
    uint32_t index = 0;
    uint32_t generation = 0;
    if (!decode_token(token, UXPYTHON_MAX_SESSIONS, &index, &generation)) return 0;
    lock_global();
    int ok = g_sessions[index].active && g_sessions[index].generation == generation;
    unlock_global();
    if (ok) *index_out = index;
    return ok;
}

static void set_session_error_by_index(uint32_t index, const char *message) {
    lock_global();
    if (index < UXPYTHON_MAX_SESSIONS && g_sessions[index].active) {
        copy_text(g_sessions[index].error, sizeof(g_sessions[index].error), message);
    } else {
        copy_text(g_global_error, sizeof(g_global_error), message);
    }
    unlock_global();
}

static void clear_session_error_by_index(uint32_t index) {
    set_session_error_by_index(index, "");
}

static const char *set_session_text_by_index(uint32_t index, const char *text) {
    (void)index;
    return copy_return_text(text);
}

#ifdef _WIN32
static void set_process_env(const char *name, const char *value) {
    if (name != NULL && value != NULL && value[0] != '\0') _putenv_s(name, value);
}
#else
static void set_process_env(const char *name, const char *value) {
    if (name != NULL && value != NULL && value[0] != '\0') setenv(name, value, 1);
}
#endif

static void *library_symbol(ux_library_t library, const char *name) {
#ifdef _WIN32
    return (void *)(uintptr_t)GetProcAddress(library, name);
#else
    return dlsym(library, name);
#endif
}

static void close_library(ux_library_t library) {
    if (!library) return;
#ifdef _WIN32
    FreeLibrary(library);
#else
    dlclose(library);
#endif
}

static ux_library_t open_library_exact(const char *path) {
    if (path == NULL || path[0] == '\0') return (ux_library_t)0;
#ifdef _WIN32
    if (strchr(path, '\\') != NULL || strchr(path, '/') != NULL || strchr(path, ':') != NULL) {
        return LoadLibraryExA(path, NULL, LOAD_WITH_ALTERED_SEARCH_PATH);
    }
    return LoadLibraryA(path);
#else
    return dlopen(path, RTLD_NOW | RTLD_GLOBAL);
#endif
}

static ux_library_t open_python_library(const char *python_home, char *loaded_path, size_t loaded_capacity) {
    const char *environment_path = getenv("UXPYTHON_DLL");
    if (environment_path != NULL && environment_path[0] != '\0') {
        ux_library_t library = open_library_exact(environment_path);
        if (library) {
            copy_text(loaded_path, loaded_capacity, environment_path);
            return library;
        }
    }

#ifdef _WIN32
    static const char *names[] = {
        "python314.dll", "python313.dll", "python312.dll", "python311.dll",
        "python310.dll", "python39.dll", "python38.dll", "python3.dll"
    };
    const char separator = '\\';
#else
    static const char *names[] = {
        "libpython3.14.so", "libpython3.13.so", "libpython3.12.so", "libpython3.11.so",
        "libpython3.10.so", "libpython3.9.so", "libpython3.8.so", "libpython3.so"
    };
    const char separator = '/';
#endif
    size_t name_count = sizeof(names) / sizeof(names[0]);

    char candidate[2048];
    if (python_home != NULL && python_home[0] != '\0') {
        for (size_t i = 0; i < name_count; ++i) {
            size_t length = strlen(python_home);
            if (length > 0U && (python_home[length - 1U] == '/' || python_home[length - 1U] == '\\')) {
                snprintf(candidate, sizeof(candidate), "%s%s", python_home, names[i]);
            } else {
                snprintf(candidate, sizeof(candidate), "%s%c%s", python_home, separator, names[i]);
            }
            ux_library_t library = open_library_exact(candidate);
            if (library) {
                copy_text(loaded_path, loaded_capacity, candidate);
                return library;
            }
        }
    }

    for (size_t i = 0; i < name_count; ++i) {
        ux_library_t library = open_library_exact(names[i]);
        if (library) {
            copy_text(loaded_path, loaded_capacity, names[i]);
            return library;
        }
    }
    return (ux_library_t)0;
}

#define LOAD_REQUIRED(field, type) do { \
    g_api.field = (type)library_symbol(g_api.library, #field); \
    if (g_api.field == NULL) { \
        char message[512]; \
        snprintf(message, sizeof(message), "Python runtime export missing: %s", #field); \
        set_global_error(message); \
        return 0; \
    } \
} while (0)

static int load_python_api(const char *python_home) {
    memset(&g_api, 0, sizeof(g_api));
    g_api.library = open_python_library(python_home, g_api.loaded_path, sizeof(g_api.loaded_path));
    if (!g_api.library) {
        set_global_error("Python runtime library not found; set UXPYTHON_DLL or pass Python home");
        return 0;
    }

    LOAD_REQUIRED(Py_Initialize, void (PYCALL *)(void));
    LOAD_REQUIRED(Py_IsInitialized, int (PYCALL *)(void));
    LOAD_REQUIRED(Py_FinalizeEx, int (PYCALL *)(void));
    LOAD_REQUIRED(PyEval_SaveThread, PyThreadState *(PYCALL *)(void));
    LOAD_REQUIRED(PyGILState_Ensure, PyGILState_STATE (PYCALL *)(void));
    LOAD_REQUIRED(PyGILState_Release, void (PYCALL *)(PyGILState_STATE));
    LOAD_REQUIRED(PyImport_ImportModule, PyObject *(PYCALL *)(const char *));
    LOAD_REQUIRED(PyObject_GetAttrString, PyObject *(PYCALL *)(PyObject *, const char *));
    LOAD_REQUIRED(PyObject_Call, PyObject *(PYCALL *)(PyObject *, PyObject *, PyObject *));
    LOAD_REQUIRED(PyObject_Str, PyObject *(PYCALL *)(PyObject *));
    LOAD_REQUIRED(PyUnicode_FromString, PyObject *(PYCALL *)(const char *));
    LOAD_REQUIRED(PyUnicode_AsUTF8, const char *(PYCALL *)(PyObject *));
    LOAD_REQUIRED(PyTuple_New, PyObject *(PYCALL *)(Py_ssize_t));
    LOAD_REQUIRED(PyTuple_SetItem, int (PYCALL *)(PyObject *, Py_ssize_t, PyObject *));
    LOAD_REQUIRED(PyList_Size, Py_ssize_t (PYCALL *)(PyObject *));
    LOAD_REQUIRED(PyList_AsTuple, PyObject *(PYCALL *)(PyObject *));
    LOAD_REQUIRED(PyDict_Size, Py_ssize_t (PYCALL *)(PyObject *));
    LOAD_REQUIRED(PySys_GetObject, PyObject *(PYCALL *)(const char *));
    LOAD_REQUIRED(PyList_Insert, int (PYCALL *)(PyObject *, Py_ssize_t, PyObject *));
    LOAD_REQUIRED(PyLong_AsLongLong, int64_t (PYCALL *)(PyObject *));
    LOAD_REQUIRED(PyFloat_AsDouble, double (PYCALL *)(PyObject *));
    LOAD_REQUIRED(PyErr_Occurred, PyObject *(PYCALL *)(void));
    LOAD_REQUIRED(PyErr_Fetch, void (PYCALL *)(PyObject **, PyObject **, PyObject **));
    LOAD_REQUIRED(PyErr_NormalizeException, void (PYCALL *)(PyObject **, PyObject **, PyObject **));
    LOAD_REQUIRED(PyErr_Clear, void (PYCALL *)(void));
    LOAD_REQUIRED(Py_IncRef, void (PYCALL *)(PyObject *));
    LOAD_REQUIRED(Py_DecRef, void (PYCALL *)(PyObject *));
    LOAD_REQUIRED(Py_GetVersion, const char *(PYCALL *)(void));

    g_api.Py_IsolatedFlag = (int *)library_symbol(g_api.library, "Py_IsolatedFlag");
    g_api.Py_IgnoreEnvironmentFlag = (int *)library_symbol(g_api.library, "Py_IgnoreEnvironmentFlag");
    g_api.Py_NoSiteFlag = (int *)library_symbol(g_api.library, "Py_NoSiteFlag");
    return 1;
}

static void capture_python_error(uint32_t session_index, const char *prefix) {
    char message[UXPYTHON_ERROR_CAPACITY];
    message[0] = '\0';
    if (!g_api.PyErr_Occurred()) {
        snprintf(message, sizeof(message), "%s", prefix != NULL ? prefix : "Python call failed");
        set_session_error_by_index(session_index, message);
        return;
    }

    PyObject *type = NULL;
    PyObject *value = NULL;
    PyObject *traceback = NULL;
    g_api.PyErr_Fetch(&type, &value, &traceback);
    g_api.PyErr_NormalizeException(&type, &value, &traceback);

    const char *type_text = "PythonError";
    const char *value_text = "";
    PyObject *type_string = type ? g_api.PyObject_Str(type) : NULL;
    PyObject *value_string = value ? g_api.PyObject_Str(value) : NULL;
    if (type_string) {
        const char *text = g_api.PyUnicode_AsUTF8(type_string);
        if (text) type_text = text;
    }
    if (value_string) {
        const char *text = g_api.PyUnicode_AsUTF8(value_string);
        if (text) value_text = text;
    }

    snprintf(message, sizeof(message), "%s: %s: %s",
             prefix != NULL ? prefix : "Python call failed", type_text, value_text);

    if (type_string) g_api.Py_DecRef(type_string);
    if (value_string) g_api.Py_DecRef(value_string);
    if (type) g_api.Py_DecRef(type);
    if (value) g_api.Py_DecRef(value);
    if (traceback) g_api.Py_DecRef(traceback);
    g_api.PyErr_Clear();
    set_session_error_by_index(session_index, message);
}

static PyObject *call_one_argument(PyObject *callable, PyObject *argument) {
    PyObject *args = g_api.PyTuple_New(1);
    if (!args) {
        if (argument) g_api.Py_DecRef(argument);
        return NULL;
    }
    if (g_api.PyTuple_SetItem(args, 0, argument) != 0) {
        g_api.Py_DecRef(args);
        return NULL;
    }
    PyObject *result = g_api.PyObject_Call(callable, args, NULL);
    g_api.Py_DecRef(args);
    return result;
}

static PyObject *json_load_text(const char *json_text) {
    PyObject *text = g_api.PyUnicode_FromString(json_text != NULL ? json_text : "null");
    if (!text) return NULL;
    return call_one_argument(g_api.json_loads, text);
}

static int add_python_path_with_gil(const char *path) {
    if (path == NULL || path[0] == '\0') return 1;
    PyObject *path_list = g_api.PySys_GetObject("path");
    if (!path_list) return 0;
    PyObject *path_text = g_api.PyUnicode_FromString(path);
    if (!path_text) return 0;
    int rc = g_api.PyList_Insert(path_list, 0, path_text);
    g_api.Py_DecRef(path_text);
    return rc == 0;
}

static int initialize_python_runtime(const char *python_home, const char *venv_path, const char *module_path, int flags) {
    lock_global();
    int already_initialized = g_api.initialized;
    int already_finalized = g_api.finalized;
    unlock_global();

    if (already_finalized) {
        set_global_error("Python runtime was finalized and cannot be initialized again in this process");
        return 0;
    }

    if (!already_initialized) {
        if (!load_python_api(python_home)) {
            if (g_api.library) close_library(g_api.library);
            memset(&g_api, 0, sizeof(g_api));
            return 0;
        }

        if ((flags & UXPYTHON_FLAG_ISOLATED) != 0) {
            if (!g_api.Py_IsolatedFlag) {
                set_global_error("requested isolated mode is unavailable in the loaded Python runtime");
                close_library(g_api.library);
                memset(&g_api, 0, sizeof(g_api));
                return 0;
            }
            *g_api.Py_IsolatedFlag = 1;
        }
        if ((flags & UXPYTHON_FLAG_IGNORE_ENVIRONMENT) != 0) {
            if (!g_api.Py_IgnoreEnvironmentFlag) {
                set_global_error("requested environment isolation is unavailable in the loaded Python runtime");
                close_library(g_api.library);
                memset(&g_api, 0, sizeof(g_api));
                return 0;
            }
            *g_api.Py_IgnoreEnvironmentFlag = 1;
        }
        if ((flags & UXPYTHON_FLAG_NO_SITE) != 0) {
            if (!g_api.Py_NoSiteFlag) {
                set_global_error("requested site-module suppression is unavailable in the loaded Python runtime");
                close_library(g_api.library);
                memset(&g_api, 0, sizeof(g_api));
                return 0;
            }
            *g_api.Py_NoSiteFlag = 1;
        }

        set_process_env("PYTHONHOME", python_home);
        g_api.Py_Initialize();
        if (!g_api.Py_IsInitialized()) {
            set_global_error("Py_Initialize did not initialize the Python runtime");
            close_library(g_api.library);
            memset(&g_api, 0, sizeof(g_api));
            return 0;
        }

        g_api.json_module = g_api.PyImport_ImportModule("json");
        if (!g_api.json_module) {
            capture_python_error(UINT32_MAX, "cannot import Python json module");
            g_api.Py_FinalizeEx();
            close_library(g_api.library);
            memset(&g_api, 0, sizeof(g_api));
            return 0;
        }
        g_api.json_loads = g_api.PyObject_GetAttrString(g_api.json_module, "loads");
        g_api.json_dumps = g_api.PyObject_GetAttrString(g_api.json_module, "dumps");
        if (!g_api.json_loads || !g_api.json_dumps) {
            capture_python_error(UINT32_MAX, "cannot resolve json.loads/json.dumps");
            if (g_api.json_loads) g_api.Py_DecRef(g_api.json_loads);
            if (g_api.json_dumps) g_api.Py_DecRef(g_api.json_dumps);
            g_api.Py_DecRef(g_api.json_module);
            g_api.Py_FinalizeEx();
            close_library(g_api.library);
            memset(&g_api, 0, sizeof(g_api));
            return 0;
        }
        g_api.json_dump_kwargs = json_load_text("{\"ensure_ascii\": false, \"allow_nan\": true}");
        if (!g_api.json_dump_kwargs || g_api.PyDict_Size(g_api.json_dump_kwargs) < 0) {
            capture_python_error(UINT32_MAX, "cannot construct JSON output options");
            if (g_api.json_dump_kwargs) g_api.Py_DecRef(g_api.json_dump_kwargs);
            g_api.Py_DecRef(g_api.json_loads);
            g_api.Py_DecRef(g_api.json_dumps);
            g_api.Py_DecRef(g_api.json_module);
            g_api.Py_FinalizeEx();
            close_library(g_api.library);
            memset(&g_api, 0, sizeof(g_api));
            return 0;
        }

        if (!add_python_path_with_gil(module_path)) {
            capture_python_error(UINT32_MAX, "cannot add module path");
            g_api.main_thread_state = g_api.PyEval_SaveThread();
            lock_global();
            g_api.initialized = 1;
            unlock_global();
            return 0;
        }
        if (venv_path != NULL && venv_path[0] != '\0') {
            char site_packages[2048];
#ifdef _WIN32
            snprintf(site_packages, sizeof(site_packages), "%s\\Lib\\site-packages", venv_path);
#else
            snprintf(site_packages, sizeof(site_packages), "%s/lib/python3/site-packages", venv_path);
#endif
            if (!add_python_path_with_gil(site_packages)) {
                capture_python_error(UINT32_MAX, "cannot add virtual-environment site-packages");
                g_api.main_thread_state = g_api.PyEval_SaveThread();
                lock_global();
                g_api.initialized = 1;
                unlock_global();
                return 0;
            }
        }

        g_api.main_thread_state = g_api.PyEval_SaveThread();
        lock_global();
        g_api.initialized = 1;
        unlock_global();
        return 1;
    }

    PyGILState_STATE gil = g_api.PyGILState_Ensure();
    int ok = add_python_path_with_gil(module_path);
    if (ok && venv_path != NULL && venv_path[0] != '\0') {
        char site_packages[2048];
#ifdef _WIN32
        snprintf(site_packages, sizeof(site_packages), "%s\\Lib\\site-packages", venv_path);
#else
        snprintf(site_packages, sizeof(site_packages), "%s/lib/python3/site-packages", venv_path);
#endif
        ok = add_python_path_with_gil(site_packages);
    }
    if (!ok) capture_python_error(UINT32_MAX, "cannot extend Python module path");
    g_api.PyGILState_Release(gil);
    return ok;
}

static uint64_t allocate_session(int flags) {
    uint64_t token = 0;
    lock_global();
    for (uint32_t i = 0; i < UXPYTHON_MAX_SESSIONS; ++i) {
        if (!g_sessions[i].active) {
            uint32_t generation = g_sessions[i].generation + 1U;
            if (generation == 0U) generation = 1U;
            memset(&g_sessions[i], 0, sizeof(g_sessions[i]));
            g_sessions[i].generation = generation;
            g_sessions[i].active = 1;
            g_sessions[i].flags = flags;
            token = make_token(i, generation);
            break;
        }
    }
    unlock_global();
    if (token == 0) set_global_error("Python session table is full");
    return token;
}

static uint64_t store_object(uint32_t session_index, PyObject *object) {
    if (!object) return 0;
    uint64_t token = 0;
    lock_global();
    for (uint32_t i = 0; i < UXPYTHON_MAX_OBJECTS; ++i) {
        if (!g_objects[i].active) {
            uint32_t generation = g_objects[i].generation + 1U;
            if (generation == 0U) generation = 1U;
            g_objects[i].generation = generation;
            g_objects[i].active = 1;
            g_objects[i].session_index = session_index;
            g_objects[i].object = object;
            token = make_token(i, generation);
            break;
        }
    }
    unlock_global();
    if (token == 0) {
        set_session_error_by_index(session_index, "Python object table is full");
        g_api.Py_DecRef(object);
    }
    return token;
}

static PyObject *acquire_object(uint32_t session_index, uint64_t token) {
    uint32_t index = 0;
    uint32_t generation = 0;
    if (!decode_token(token, UXPYTHON_MAX_OBJECTS, &index, &generation)) {
        set_session_error_by_index(session_index, "invalid Python object handle");
        return NULL;
    }
    lock_global();
    PythonObjectEntry *entry = &g_objects[index];
    PyObject *object = NULL;
    if (entry->active && entry->generation == generation && entry->session_index == session_index) {
        object = entry->object;
        g_api.Py_IncRef(object);
    }
    unlock_global();
    if (!object) set_session_error_by_index(session_index, "stale or foreign Python object handle");
    return object;
}

static PyObject *call_json_object(uint32_t session_index, PyObject *callable, const char *args_json, const char *kwargs_json) {
    PyObject *args_list = json_load_text((args_json && args_json[0]) ? args_json : "[]");
    if (!args_list) {
        capture_python_error(session_index, "cannot decode positional arguments JSON");
        return NULL;
    }
    if (g_api.PyList_Size(args_list) < 0) {
        g_api.PyErr_Clear();
        g_api.Py_DecRef(args_list);
        set_session_error_by_index(session_index, "positional arguments JSON must decode to a list");
        return NULL;
    }
    PyObject *args_tuple = g_api.PyList_AsTuple(args_list);
    g_api.Py_DecRef(args_list);
    if (!args_tuple) {
        capture_python_error(session_index, "cannot convert positional arguments to a Python tuple");
        return NULL;
    }

    PyObject *kwargs = json_load_text((kwargs_json && kwargs_json[0]) ? kwargs_json : "{}");
    if (!kwargs) {
        g_api.Py_DecRef(args_tuple);
        capture_python_error(session_index, "cannot decode keyword arguments JSON");
        return NULL;
    }
    if (g_api.PyDict_Size(kwargs) < 0) {
        g_api.PyErr_Clear();
        g_api.Py_DecRef(args_tuple);
        g_api.Py_DecRef(kwargs);
        set_session_error_by_index(session_index, "keyword arguments JSON must decode to an object");
        return NULL;
    }

    PyObject *result = g_api.PyObject_Call(callable, args_tuple, kwargs);
    g_api.Py_DecRef(args_tuple);
    g_api.Py_DecRef(kwargs);
    if (!result) capture_python_error(session_index, "Python callable raised an exception");
    return result;
}

int uxpython_version(void) { return 100; }

uint64_t uxpython_open(const char *python_home, const char *venv_path, const char *module_path, int flags) {
    if (!initialize_python_runtime(python_home, venv_path, module_path, flags)) return 0;
    uint64_t token = allocate_session(flags);
    if (token != 0) {
        uint32_t index = 0;
        if (session_index_from_token(token, &index)) clear_session_error_by_index(index);
    }
    return token;
}

int uxpython_close(uint64_t session) {
    uint32_t session_index = 0;
    if (!session_index_from_token(session, &session_index)) {
        set_global_error("invalid Python session handle");
        return 0;
    }

    PyGILState_STATE gil = g_api.PyGILState_Ensure();
    PyObject **release_list = (PyObject **)calloc(UXPYTHON_MAX_OBJECTS, sizeof(PyObject *));
    if (release_list == NULL) {
        g_api.PyGILState_Release(gil);
        set_session_error_by_index(session_index, "out of memory while closing Python session");
        return 0;
    }
    size_t release_count = 0U;
    lock_global();
    for (uint32_t i = 0; i < UXPYTHON_MAX_OBJECTS; ++i) {
        if (g_objects[i].active && g_objects[i].session_index == session_index) {
            release_list[release_count++] = g_objects[i].object;
            g_objects[i].active = 0;
            g_objects[i].object = NULL;
            g_objects[i].session_index = 0;
        }
    }
    g_sessions[session_index].active = 0;
    g_sessions[session_index].error[0] = '\0';
    unlock_global();
    for (size_t i = 0; i < release_count; ++i) g_api.Py_DecRef(release_list[i]);
    free(release_list);
    g_api.PyGILState_Release(gil);
    return 1;
}

int uxpython_is_ready(uint64_t session) {
    uint32_t index = 0;
    return session_index_from_token(session, &index) && g_api.initialized && g_api.Py_IsInitialized();
}

int uxpython_add_path(uint64_t session, const char *path) {
    uint32_t session_index = 0;
    if (!session_index_from_token(session, &session_index)) {
        set_global_error("invalid Python session handle");
        return 0;
    }
    if (path == NULL || path[0] == '\0') {
        set_session_error_by_index(session_index, "Python path cannot be empty");
        return 0;
    }
    PyGILState_STATE gil = g_api.PyGILState_Ensure();
    int ok = add_python_path_with_gil(path);
    if (!ok) capture_python_error(session_index, "cannot add Python module path");
    else clear_session_error_by_index(session_index);
    g_api.PyGILState_Release(gil);
    return ok;
}

const char * uxpython_last_error(uint64_t session) {
    char local[UXPYTHON_ERROR_CAPACITY];
    local[0] = '\0';
    if (session == 0) {
        lock_global();
        copy_text(local, sizeof(local), g_global_error);
        unlock_global();
        return copy_return_text(local);
    }
    uint32_t index = 0;
    if (!session_index_from_token(session, &index)) return copy_return_text("invalid Python session handle");
    lock_global();
    copy_text(local, sizeof(local), g_sessions[index].error);
    unlock_global();
    return copy_return_text(local);
}

const char * uxpython_runtime_version(uint64_t session) {
    uint32_t index = 0;
    if (!session_index_from_token(session, &index)) return "";
    PyGILState_STATE gil = g_api.PyGILState_Ensure();
    const char *version = g_api.Py_GetVersion();
    const char *result = set_session_text_by_index(index, version ? version : "");
    g_api.PyGILState_Release(gil);
    return result;
}

uint64_t uxpython_import(uint64_t session, const char *module_name) {
    uint32_t session_index = 0;
    if (!session_index_from_token(session, &session_index)) {
        set_global_error("invalid Python session handle");
        return 0;
    }
    if (!module_name || module_name[0] == '\0') {
        set_session_error_by_index(session_index, "Python module name cannot be empty");
        return 0;
    }
    PyGILState_STATE gil = g_api.PyGILState_Ensure();
    PyObject *module = g_api.PyImport_ImportModule(module_name);
    uint64_t handle = 0;
    if (!module) capture_python_error(session_index, "cannot import Python module");
    else {
        clear_session_error_by_index(session_index);
        handle = store_object(session_index, module);
    }
    g_api.PyGILState_Release(gil);
    return handle;
}

uint64_t uxpython_get_attr(uint64_t session, uint64_t object_handle, const char *attribute_name) {
    uint32_t session_index = 0;
    if (!session_index_from_token(session, &session_index)) {
        set_global_error("invalid Python session handle");
        return 0;
    }
    if (!attribute_name || attribute_name[0] == '\0') {
        set_session_error_by_index(session_index, "Python attribute name cannot be empty");
        return 0;
    }
    PyGILState_STATE gil = g_api.PyGILState_Ensure();
    PyObject *object = acquire_object(session_index, object_handle);
    uint64_t handle = 0;
    if (object) {
        PyObject *attribute = g_api.PyObject_GetAttrString(object, attribute_name);
        g_api.Py_DecRef(object);
        if (!attribute) capture_python_error(session_index, "cannot read Python attribute");
        else {
            clear_session_error_by_index(session_index);
            handle = store_object(session_index, attribute);
        }
    }
    g_api.PyGILState_Release(gil);
    return handle;
}

uint64_t uxpython_call_json(uint64_t session, uint64_t callable_handle, const char *args_json, const char *kwargs_json) {
    uint32_t session_index = 0;
    if (!session_index_from_token(session, &session_index)) {
        set_global_error("invalid Python session handle");
        return 0;
    }
    PyGILState_STATE gil = g_api.PyGILState_Ensure();
    PyObject *callable = acquire_object(session_index, callable_handle);
    uint64_t handle = 0;
    if (callable) {
        PyObject *result = call_json_object(session_index, callable, args_json, kwargs_json);
        g_api.Py_DecRef(callable);
        if (result) {
            clear_session_error_by_index(session_index);
            handle = store_object(session_index, result);
        }
    }
    g_api.PyGILState_Release(gil);
    return handle;
}

uint64_t uxpython_call_module_json(uint64_t session, const char *module_name, const char *function_name, const char *args_json, const char *kwargs_json) {
    uint32_t session_index = 0;
    if (!session_index_from_token(session, &session_index)) {
        set_global_error("invalid Python session handle");
        return 0;
    }
    if (!module_name || !function_name || module_name[0] == '\0' || function_name[0] == '\0') {
        set_session_error_by_index(session_index, "Python module and function names are required");
        return 0;
    }

    PyGILState_STATE gil = g_api.PyGILState_Ensure();
    PyObject *module = g_api.PyImport_ImportModule(module_name);
    PyObject *callable = NULL;
    PyObject *result = NULL;
    uint64_t handle = 0;
    if (!module) capture_python_error(session_index, "cannot import Python module");
    else {
        callable = g_api.PyObject_GetAttrString(module, function_name);
        if (!callable) capture_python_error(session_index, "cannot resolve Python function");
        else result = call_json_object(session_index, callable, args_json, kwargs_json);
    }
    if (callable) g_api.Py_DecRef(callable);
    if (module) g_api.Py_DecRef(module);
    if (result) {
        clear_session_error_by_index(session_index);
        handle = store_object(session_index, result);
    }
    g_api.PyGILState_Release(gil);
    return handle;
}

int64_t uxpython_to_i64(uint64_t session, uint64_t object_handle) {
    uint32_t session_index = 0;
    if (!session_index_from_token(session, &session_index)) {
        set_global_error("invalid Python session handle");
        return 0;
    }
    PyGILState_STATE gil = g_api.PyGILState_Ensure();
    PyObject *object = acquire_object(session_index, object_handle);
    int64_t value = 0;
    if (object) {
        value = g_api.PyLong_AsLongLong(object);
        g_api.Py_DecRef(object);
        if (g_api.PyErr_Occurred()) capture_python_error(session_index, "Python value is not an integer");
        else clear_session_error_by_index(session_index);
    }
    g_api.PyGILState_Release(gil);
    return value;
}

double uxpython_to_f64(uint64_t session, uint64_t object_handle) {
    uint32_t session_index = 0;
    if (!session_index_from_token(session, &session_index)) {
        set_global_error("invalid Python session handle");
        return 0.0;
    }
    PyGILState_STATE gil = g_api.PyGILState_Ensure();
    PyObject *object = acquire_object(session_index, object_handle);
    double value = 0.0;
    if (object) {
        value = g_api.PyFloat_AsDouble(object);
        g_api.Py_DecRef(object);
        if (g_api.PyErr_Occurred()) capture_python_error(session_index, "Python value is not numeric");
        else clear_session_error_by_index(session_index);
    }
    g_api.PyGILState_Release(gil);
    return value;
}

const char * uxpython_to_string(uint64_t session, uint64_t object_handle) {
    uint32_t session_index = 0;
    if (!session_index_from_token(session, &session_index)) {
        set_global_error("invalid Python session handle");
        return "";
    }
    PyGILState_STATE gil = g_api.PyGILState_Ensure();
    PyObject *object = acquire_object(session_index, object_handle);
    const char *result = "";
    if (object) {
        PyObject *string_object = g_api.PyObject_Str(object);
        g_api.Py_DecRef(object);
        if (!string_object) capture_python_error(session_index, "cannot convert Python value to string");
        else {
            const char *text = g_api.PyUnicode_AsUTF8(string_object);
            if (!text) capture_python_error(session_index, "cannot encode Python string as UTF-8");
            else {
                clear_session_error_by_index(session_index);
                result = set_session_text_by_index(session_index, text);
            }
            g_api.Py_DecRef(string_object);
        }
    }
    g_api.PyGILState_Release(gil);
    return result;
}

const char * uxpython_to_json(uint64_t session, uint64_t object_handle) {
    uint32_t session_index = 0;
    if (!session_index_from_token(session, &session_index)) {
        set_global_error("invalid Python session handle");
        return "";
    }
    PyGILState_STATE gil = g_api.PyGILState_Ensure();
    PyObject *object = acquire_object(session_index, object_handle);
    const char *result = "";
    if (object) {
        PyObject *args = g_api.PyTuple_New(1);
        if (!args) {
            g_api.Py_DecRef(object);
            capture_python_error(session_index, "cannot prepare JSON conversion");
        } else {
            if (g_api.PyTuple_SetItem(args, 0, object) != 0) {
                g_api.Py_DecRef(args);
                capture_python_error(session_index, "cannot prepare JSON conversion argument");
            } else {
                PyObject *json_text = g_api.PyObject_Call(g_api.json_dumps, args, g_api.json_dump_kwargs);
                g_api.Py_DecRef(args);
                if (!json_text) capture_python_error(session_index, "Python value is not JSON serializable");
                else {
                    const char *text = g_api.PyUnicode_AsUTF8(json_text);
                    if (!text) capture_python_error(session_index, "cannot encode JSON as UTF-8");
                    else {
                        clear_session_error_by_index(session_index);
                        result = set_session_text_by_index(session_index, text);
                    }
                    g_api.Py_DecRef(json_text);
                }
            }
        }
    }
    g_api.PyGILState_Release(gil);
    return result;
}

int uxpython_release(uint64_t session, uint64_t object_handle) {
    uint32_t session_index = 0;
    if (!session_index_from_token(session, &session_index)) {
        set_global_error("invalid Python session handle");
        return 0;
    }
    uint32_t object_index = 0;
    uint32_t generation = 0;
    if (!decode_token(object_handle, UXPYTHON_MAX_OBJECTS, &object_index, &generation)) {
        set_session_error_by_index(session_index, "invalid Python object handle");
        return 0;
    }

    PyGILState_STATE gil = g_api.PyGILState_Ensure();
    PyObject *object = NULL;
    lock_global();
    PythonObjectEntry *entry = &g_objects[object_index];
    if (entry->active && entry->generation == generation && entry->session_index == session_index) {
        object = entry->object;
        entry->active = 0;
        entry->object = NULL;
        entry->session_index = 0;
    }
    unlock_global();
    if (!object) set_session_error_by_index(session_index, "stale or foreign Python object handle");
    else {
        g_api.Py_DecRef(object);
        clear_session_error_by_index(session_index);
    }
    g_api.PyGILState_Release(gil);
    return object ? 1 : 0;
}

int uxpython_shutdown(void) {
    lock_global();
    for (uint32_t i = 0; i < UXPYTHON_MAX_SESSIONS; ++i) {
        if (g_sessions[i].active) {
            copy_text(g_global_error, sizeof(g_global_error), "cannot shut down Python while sessions are active");
            unlock_global();
            return 0;
        }
    }
    int initialized = g_api.initialized;
    unlock_global();
    if (!initialized) return 1;

    PyGILState_STATE gil = g_api.PyGILState_Ensure();
    (void)gil;
    if (g_api.json_dump_kwargs) g_api.Py_DecRef(g_api.json_dump_kwargs);
    if (g_api.json_loads) g_api.Py_DecRef(g_api.json_loads);
    if (g_api.json_dumps) g_api.Py_DecRef(g_api.json_dumps);
    if (g_api.json_module) g_api.Py_DecRef(g_api.json_module);
    int rc = g_api.Py_FinalizeEx();
    ux_library_t library = g_api.library;
    memset(&g_api, 0, sizeof(g_api));
    g_api.finalized = 1;
    close_library(library);
    return rc == 0 ? 1 : 0;
}
