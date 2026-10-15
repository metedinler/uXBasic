# UXGRAPH — igraph-backed graph/network library for uXBasic

This library follows the project rule:

> Do not add new uXBasic keywords. Prefer external C/C++ DLLs and wrap them through `.bas` include files.

## Backend

Primary backend:

```text
igraph C library
```

The wrapper DLL is:

```text
uxb/dist/runtime_ext/uxgraph.dll
```

## Install dependencies

Open MSYS2 UCRT64 shell:

```bash
pacman -Syu
pacman -S mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-igraph pkgconf
```

## Build

```bat
uxb\runtime_ext\uxgraph\build_uxgraph_dll.bat
```

Temporary fallback without igraph:

```bat
uxb\runtime_ext\uxgraph\build_uxgraph_fallback_dll.bat
```

Fallback is for smoke tests only. The intended production path is igraph.

## uXBasic usage

```basic
INCLUDE "libs/uxgraph/uxgraph.bas"

g = uxgraph.Create(5, 0)
uxgraph.AddEdge(g, 0, 1)
uxgraph.AddEdge(g, 1, 2)

PRINT uxgraph.VCount(g)
PRINT uxgraph.ECount(g)
PRINT uxgraph.ShortestDistance(g, 0, 2)

uxgraph.Free(g)
```

## Exposed operations

- Create/free graph
- Add vertices/edges
- Directed/undirected mode
- V/E count
- In/out/all degree
- Degree vector
- BFS distances
- Shortest unweighted distance
- Connectivity and component count
- Density
- Self-loop count
- Triangle count
- Global transitivity
- Edge-list CSV read/write
- Path/cycle/complete graph constructors

## Next expansion

igraph contains many more algorithms than this first wrapper exposes. Future wrappers should add:

- weighted shortest paths
- MST
- centrality: betweenness, closeness, eigenvector, PageRank
- community detection
- layout
- graph isomorphism
- bipartite algorithms
- flows and cuts
