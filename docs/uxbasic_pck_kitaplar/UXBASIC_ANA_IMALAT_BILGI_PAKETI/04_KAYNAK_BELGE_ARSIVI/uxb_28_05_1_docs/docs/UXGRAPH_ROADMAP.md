# UXGRAPH roadmap

This is the second external-library style package after `uxcollections`.

## Package order

1. `uxcollections` — GLib containers
2. `uxgraph` — igraph graph/network algorithms
3. `uxdataframe` — DuckDB/Arrow data tables
4. `uxmatrix` — OpenBLAS/LAPACK matrix algebra
5. `uxnum` / `uxpoly`
6. `uxaimath`
7. `uxai`

## Rule for all future packages

- Prefer existing C/C++ libraries.
- Wrap through DLL and `.bas` INCLUDE.
- Expose all useful functions incrementally.
- Do not add domain-specific uXBasic keywords.
- Keep namespace isolation.
