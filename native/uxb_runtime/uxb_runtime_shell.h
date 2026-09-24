#pragma once
#include <string>
namespace uxb {
int run_shell_process(const std::string& command, const std::string& run_path, int timeout_ms,
                      std::string& out_text, std::string& err_text, int& exit_code);
int start_shell_process(const std::string& command, const std::string& run_path,
                        const std::string& out_path, const std::string& err_path,
                        int& exit_code);
int write_text_file(const std::string& path, const std::string& text);
}
