# uXBasic External Library Expansion Beyond The Initial 9

Beyond uxllama, uxregex, uxstringx, uxlua, uxprolog, uxos, uxnetcurl, uxrest and uxpreprocess, useful library families are:

1. uxsqlite — SQLite embedded database.
2. uxpostgres — PostgreSQL client via libpq.
3. uxodbc — ODBC database bridge.
4. uxjson — yyjson/cJSON based JSON parser/writer.
5. uxxml — libxml2 XML/HTML parser.
6. uxyaml — libyaml YAML parser.
7. uxcrypto — OpenSSL/libsodium hash, HMAC, crypto.
8. uxcompress — zlib, zstd, lz4, libarchive.
9. uxzip — libzip/minizip archive handling.
10. uxpdf — MuPDF/Poppler PDF text/page/image extraction.
11. uxocr — Tesseract OCR bridge.
12. uximage — stb_image/libpng/libjpeg-turbo/OpenCV image I/O.
13. uxvision — OpenCV computer vision.
14. uxaudioio — miniaudio/libsndfile/dr_wav audio I/O.
15. uxsignal — FFTW/KissFFT signal processing.
16. uxplot — gnuplot/plplot/ImPlot bridge.
17. uxgui — raylib/SDL2/WinAPI/ImGui GUI bridge.
18. uxgfx2d — raylib/SDL2/Cairo/Skia 2D graphics.
19. uxgfx3d — raylib/bgfx/OpenGL/Vulkan 3D graphics.
20. uxphysics — Box2D/Bullet physics.
21. uxoptimizer — NLopt/Ceres optimization.
22. uxsolver — GLPK/CBC linear/integer programming.
23. uxipc — ZeroMQ/nanomsg/named pipe IPC.
24. uxserial — serial port communication.
25. uxmodbus — industrial Modbus protocol.
26. uxexcel — libxlsxwriter / xlsxio.
27. uxgeospatial — GDAL/PROJ spatial data.
28. uxbiokit — FASTA/FASTQ/Bio sequence helpers.
29. uxgit — libgit2 repository integration.
30. uxplugin — generic dynamic plugin loader and registry.

Main rule: prefer external mature C/C++ libraries, then wrap with .bas INCLUDE and CALL(DLL/API). Write C code only when no stable external library exists or when a thin bridge is safer.
