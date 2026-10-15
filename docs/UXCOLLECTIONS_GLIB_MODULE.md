# uxcollections — GLib-backed collections wrapper

This module does not add new uXBasic keywords. It uses:

- `INCLUDE "libs/uxcollections/uxcollections.bas"`
- existing `CALL(DLL, ...)`
- namespace `uxcollections`
- external DLL: `uxcollections.dll`
- backend library: GLib 2.0

## MSYS2 dependency

Open MSYS2 UCRT64 shell:

```bash
pacman -Syu
pacman -S mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-glib2 pkgconf
```

## Included in this module

- List: GLib `GPtrArray`
- Stack/Queue/Deque: GLib `GQueue`
- Dict/Set: GLib `GHashTable`
- Sorted Tree: GLib `GTree`
- N-ary Node Tree: GLib `GNode`

## Not included here

- Graph: separate `uxgraph` module should wrap `igraph` C library.
- DataFrame/Table: separate `uxdataframe` module should wrap DuckDB/Arrow.
- Matrix: separate `uxmatrix` module.
