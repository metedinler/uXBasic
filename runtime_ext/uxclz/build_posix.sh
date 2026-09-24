#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p build
${CXX:-g++} -std=c++17 -O2 -Wall -Wextra -Wpedantic -fPIC -DUXCLZ_BUILD_DLL -Iinclude -shared src/uxclz.cpp -o build/libuxclz.so
${CXX:-g++} -std=c++17 -O2 -Wall -Wextra -Wpedantic -Iinclude tests/uxclz_smoke.cpp -Lbuild -luxclz -Wl,-rpath,'$ORIGIN' -o build/uxclz_smoke
build/uxclz_smoke
