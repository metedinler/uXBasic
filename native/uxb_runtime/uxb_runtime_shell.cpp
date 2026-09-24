#include "uxb_runtime_shell.h"
#include "uxb_runtime_state.h"
#include <chrono>
#include <cstdio>
#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <sstream>
#include <string>
#include <thread>

#if defined(_WIN32)
#define WIN32_LEAN_AND_MEAN
#include <windows.h>

namespace uxb {
static void read_handle(HANDLE handle, std::string& target) {
    char buffer[4096];
    DWORD read_count = 0;
    while (ReadFile(handle, buffer, sizeof(buffer), &read_count, nullptr) && read_count > 0) {
        target.append(buffer, buffer + read_count);
    }
}

static std::string output_path_for_child(const std::string& path, const std::string& run_path) {
    if (path.empty() || run_path.empty()) return path;
    std::filesystem::path value(path);
    if (value.is_absolute()) return value.string();
    return (std::filesystem::path(run_path) / value).string();
}

static HANDLE open_child_output(const std::string& path, const std::string& run_path) {
    const std::string resolved = output_path_for_child(path, run_path);
    const char* target = resolved.empty() ? "NUL" : resolved.c_str();
    SECURITY_ATTRIBUTES sa{sizeof(SECURITY_ATTRIBUTES), nullptr, TRUE};
    const DWORD disposition = resolved.empty() ? OPEN_EXISTING : CREATE_ALWAYS;
    return CreateFileA(target, GENERIC_WRITE, FILE_SHARE_READ | FILE_SHARE_WRITE, &sa,
                       disposition, FILE_ATTRIBUTE_NORMAL, nullptr);
}

int run_shell_process(const std::string& command, const std::string& run_path, int timeout_ms,
                      std::string& out_text, std::string& err_text, int& exit_code) {
    if (command.empty()) { RuntimeState::instance().set_error("empty shell command"); return UXB_RT_FAILURE; }
    SECURITY_ATTRIBUTES sa{sizeof(SECURITY_ATTRIBUTES), nullptr, TRUE};
    HANDLE out_read=nullptr, out_write=nullptr, err_read=nullptr, err_write=nullptr;
    if (!CreatePipe(&out_read, &out_write, &sa, 0) || !CreatePipe(&err_read, &err_write, &sa, 0)) {
        RuntimeState::instance().set_error("CreatePipe failed"); return UXB_RT_FAILURE;
    }
    SetHandleInformation(out_read, HANDLE_FLAG_INHERIT, 0);
    SetHandleInformation(err_read, HANDLE_FLAG_INHERIT, 0);

    STARTUPINFOA si{}; si.cb = sizeof(si); si.dwFlags = STARTF_USESTDHANDLES;
    si.hStdOutput = out_write; si.hStdError = err_write; si.hStdInput = GetStdHandle(STD_INPUT_HANDLE);
    PROCESS_INFORMATION pi{};
    std::string command_line = "cmd.exe /d /s /c \"" + command + "\"";
    std::string mutable_command = command_line;
    const char* cwd = run_path.empty() ? nullptr : run_path.c_str();
    BOOL created = CreateProcessA(nullptr, mutable_command.data(), nullptr, nullptr, TRUE,
                                  CREATE_NO_WINDOW, nullptr, cwd, &si, &pi);
    CloseHandle(out_write); CloseHandle(err_write);
    if (!created) {
        CloseHandle(out_read); CloseHandle(err_read);
        RuntimeState::instance().set_error("CreateProcessA failed"); return UXB_RT_FAILURE;
    }

    std::thread out_reader(read_handle, out_read, std::ref(out_text));
    std::thread err_reader(read_handle, err_read, std::ref(err_text));
    DWORD wait_ms = timeout_ms > 0 ? static_cast<DWORD>(timeout_ms) : INFINITE;
    DWORD wait_result = WaitForSingleObject(pi.hProcess, wait_ms);
    if (wait_result == WAIT_TIMEOUT) {
        TerminateProcess(pi.hProcess, 124);
        WaitForSingleObject(pi.hProcess, INFINITE);
        RuntimeState::instance().set_error("shell timeout");
    }
    DWORD process_exit = 0;
    GetExitCodeProcess(pi.hProcess, &process_exit);
    exit_code = static_cast<int>(process_exit);
    CloseHandle(pi.hThread); CloseHandle(pi.hProcess);
    out_reader.join(); err_reader.join();
    CloseHandle(out_read); CloseHandle(err_read);
    return wait_result == WAIT_TIMEOUT ? UXB_RT_FAILURE : UXB_RT_SUCCESS;
}

int start_shell_process(const std::string& command, const std::string& run_path,
                        const std::string& out_path, const std::string& err_path,
                        int& exit_code) {
    if (command.empty()) {
        RuntimeState::instance().set_error("empty shell command");
        return UXB_RT_FAILURE;
    }

    HANDLE out_handle = open_child_output(out_path, run_path);
    HANDLE err_handle = open_child_output(err_path, run_path);
    if (out_handle == INVALID_HANDLE_VALUE || err_handle == INVALID_HANDLE_VALUE) {
        if (out_handle != INVALID_HANDLE_VALUE) CloseHandle(out_handle);
        if (err_handle != INVALID_HANDLE_VALUE) CloseHandle(err_handle);
        RuntimeState::instance().set_error("shell output file open failed");
        return UXB_RT_FAILURE;
    }

    STARTUPINFOA si{};
    si.cb = sizeof(si);
    si.dwFlags = STARTF_USESTDHANDLES;
    si.hStdOutput = out_handle;
    si.hStdError = err_handle;
    si.hStdInput = GetStdHandle(STD_INPUT_HANDLE);
    PROCESS_INFORMATION pi{};
    std::string command_line = "cmd.exe /d /s /c \"" + command + "\"";
    std::string mutable_command = command_line;
    const char* cwd = run_path.empty() ? nullptr : run_path.c_str();
    const BOOL created = CreateProcessA(
        nullptr, mutable_command.data(), nullptr, nullptr, TRUE,
        CREATE_NO_WINDOW | CREATE_NEW_PROCESS_GROUP, nullptr, cwd, &si, &pi);

    CloseHandle(out_handle);
    CloseHandle(err_handle);
    if (!created) {
        RuntimeState::instance().set_error("CreateProcessA nowait failed");
        return UXB_RT_FAILURE;
    }

    CloseHandle(pi.hThread);
    CloseHandle(pi.hProcess);
    exit_code = 0;
    return UXB_RT_SUCCESS;
}
} // namespace uxb
#else
namespace uxb {
int run_shell_process(const std::string& command, const std::string& run_path, int,
                      std::string& out_text, std::string& err_text, int& exit_code) {
    std::string full = command;
    if (!run_path.empty()) full = "cd \"" + run_path + "\" && " + command;
    full += " > .uxb_shell_stdout.tmp 2> .uxb_shell_stderr.tmp";
    exit_code = std::system(full.c_str());
    std::ifstream out_file(".uxb_shell_stdout.tmp");
    std::ifstream err_file(".uxb_shell_stderr.tmp");
    out_text.assign((std::istreambuf_iterator<char>(out_file)), std::istreambuf_iterator<char>());
    err_text.assign((std::istreambuf_iterator<char>(err_file)), std::istreambuf_iterator<char>());
    std::remove(".uxb_shell_stdout.tmp"); std::remove(".uxb_shell_stderr.tmp");
    return UXB_RT_SUCCESS;
}

int start_shell_process(const std::string& command, const std::string& run_path,
                        const std::string& out_path, const std::string& err_path,
                        int& exit_code) {
    if (command.empty()) {
        RuntimeState::instance().set_error("empty shell command");
        return UXB_RT_FAILURE;
    }
    std::string full;
    if (!run_path.empty()) full = "cd \"" + run_path + "\" && ";
    full += command;
    if (!out_path.empty()) full += " > \"" + out_path + "\"";
    else full += " > /dev/null";
    if (!err_path.empty()) full += " 2> \"" + err_path + "\"";
    else full += " 2> /dev/null";
    full += " &";
    exit_code = std::system(full.c_str());
    return exit_code == -1 ? UXB_RT_FAILURE : UXB_RT_SUCCESS;
}
}
#endif

namespace uxb {
int write_text_file(const std::string& path, const std::string& text) {
    if (path.empty()) {
        RuntimeState::instance().set_error("empty output path");
        return UXB_RT_FAILURE;
    }
    std::ofstream output(path, std::ios::binary | std::ios::trunc);
    if (!output) {
        RuntimeState::instance().set_error("output file open failed");
        return UXB_RT_FAILURE;
    }
    output.write(text.data(), static_cast<std::streamsize>(text.size()));
    if (!output) {
        RuntimeState::instance().set_error("output file write failed");
        return UXB_RT_FAILURE;
    }
    return UXB_RT_SUCCESS;
}
}
