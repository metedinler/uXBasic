# Collection roadmap

Decision:

1. Use existing uXBasic LIST/DICT/SET/ARRAY for internal interpreter/MIR where already implemented.
2. Add `uxcollections` external GLib-backed module for general purpose compiled/runtime DLL collections.
3. Do not write graph/dataframe from scratch inside this module.
4. Next modules:
   - `uxgraph`: igraph-backed graph/network algorithms.
   - `uxdataframe`: DuckDB/Arrow-backed dataframe/table operations.
   - `uxmatrix`: BLAS/LAPACK/OpenBLAS-backed matrix/linear algebra.
