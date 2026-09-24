' uXBasic UXGRAPH wrapper
' External backend: uxgraph.dll over igraph C library where available.
' No new uXBasic keyword is introduced. Use INCLUDE + CALL(DLL) + NAMESPACE.

NAMESPACE uxgraph

CONST UXGRAPH_DLL = "uxgraph.dll"

FUNCTION Create(vertices AS I32, directed AS I32) AS U64
    RETURN CALL(DLL, "uxgraph.dll", "uxgraph_create", PTR, CDECL, "I32,I32", vertices, directed)
END FUNCTION

SUB Free(g AS U64)
    CALL(DLL, "uxgraph.dll", "uxgraph_free", VOID, CDECL, "PTR", g)
END SUB

FUNCTION AddVertex(g AS U64) AS I32
    RETURN CALL(DLL, "uxgraph.dll", "uxgraph_add_vertex", I32, CDECL, "PTR", g)
END FUNCTION

FUNCTION AddVertices(g AS U64, count AS I32) AS I32
    RETURN CALL(DLL, "uxgraph.dll", "uxgraph_add_vertices", I32, CDECL, "PTR,I32", g, count)
END FUNCTION

FUNCTION AddEdge(g AS U64, fromV AS I32, toV AS I32) AS I32
    RETURN CALL(DLL, "uxgraph.dll", "uxgraph_add_edge", I32, CDECL, "PTR,I32,I32", g, fromV, toV)
END FUNCTION

FUNCTION VCount(g AS U64) AS I32
    RETURN CALL(DLL, "uxgraph.dll", "uxgraph_vcount", I32, CDECL, "PTR", g)
END FUNCTION

FUNCTION ECount(g AS U64) AS I32
    RETURN CALL(DLL, "uxgraph.dll", "uxgraph_ecount", I32, CDECL, "PTR", g)
END FUNCTION

FUNCTION IsDirected(g AS U64) AS I32
    RETURN CALL(DLL, "uxgraph.dll", "uxgraph_is_directed", I32, CDECL, "PTR", g)
END FUNCTION

FUNCTION HasEdge(g AS U64, fromV AS I32, toV AS I32) AS I32
    RETURN CALL(DLL, "uxgraph.dll", "uxgraph_has_edge", I32, CDECL, "PTR,I32,I32", g, fromV, toV)
END FUNCTION

FUNCTION Degree(g AS U64, v AS I32) AS I32
    RETURN CALL(DLL, "uxgraph.dll", "uxgraph_degree", I32, CDECL, "PTR,I32", g, v)
END FUNCTION

FUNCTION InDegree(g AS U64, v AS I32) AS I32
    RETURN CALL(DLL, "uxgraph.dll", "uxgraph_in_degree", I32, CDECL, "PTR,I32", g, v)
END FUNCTION

FUNCTION OutDegree(g AS U64, v AS I32) AS I32
    RETURN CALL(DLL, "uxgraph.dll", "uxgraph_out_degree", I32, CDECL, "PTR,I32", g, v)
END FUNCTION

FUNCTION Density(g AS U64) AS F64
    RETURN CALL(DLL, "uxgraph.dll", "uxgraph_density", F64, CDECL, "PTR", g)
END FUNCTION

FUNCTION SelfLoops(g AS U64) AS I32
    RETURN CALL(DLL, "uxgraph.dll", "uxgraph_self_loops", I32, CDECL, "PTR", g)
END FUNCTION

FUNCTION Components(g AS U64) AS I32
    RETURN CALL(DLL, "uxgraph.dll", "uxgraph_components_count", I32, CDECL, "PTR", g)
END FUNCTION

FUNCTION IsConnected(g AS U64) AS I32
    RETURN CALL(DLL, "uxgraph.dll", "uxgraph_is_connected", I32, CDECL, "PTR", g)
END FUNCTION

FUNCTION ShortestDistance(g AS U64, source AS I32, target AS I32) AS I32
    RETURN CALL(DLL, "uxgraph.dll", "uxgraph_shortest_distance", I32, CDECL, "PTR,I32,I32", g, source, target)
END FUNCTION

FUNCTION PathExists(g AS U64, source AS I32, target AS I32) AS I32
    RETURN CALL(DLL, "uxgraph.dll", "uxgraph_path_exists", I32, CDECL, "PTR,I32,I32", g, source, target)
END FUNCTION

FUNCTION TriangleCount(g AS U64) AS I32
    RETURN CALL(DLL, "uxgraph.dll", "uxgraph_triangle_count", I32, CDECL, "PTR", g)
END FUNCTION

FUNCTION Transitivity(g AS U64) AS F64
    RETURN CALL(DLL, "uxgraph.dll", "uxgraph_transitivity", F64, CDECL, "PTR", g)
END FUNCTION

FUNCTION DegreeVector(g AS U64, mode AS I32) AS U64
    ' mode: 0=all, 1=in, 2=out
    RETURN CALL(DLL, "uxgraph.dll", "uxgraph_degree_vector", PTR, CDECL, "PTR,I32", g, mode)
END FUNCTION

FUNCTION BFSDistances(g AS U64, source AS I32) AS U64
    RETURN CALL(DLL, "uxgraph.dll", "uxgraph_bfs_distances", PTR, CDECL, "PTR,I32", g, source)
END FUNCTION

FUNCTION VecCount(v AS U64) AS I32
    RETURN CALL(DLL, "uxgraph.dll", "uxgraph_vec_count", I32, CDECL, "PTR", v)
END FUNCTION

FUNCTION VecGet(v AS U64, index AS I32) AS F64
    RETURN CALL(DLL, "uxgraph.dll", "uxgraph_vec_get", F64, CDECL, "PTR,I32", v, index)
END FUNCTION

SUB VecFree(v AS U64)
    CALL(DLL, "uxgraph.dll", "uxgraph_vec_free", VOID, CDECL, "PTR", v)
END SUB

FUNCTION WriteEdgeListCSV(g AS U64, path AS STRING) AS I32
    RETURN CALL(DLL, "uxgraph.dll", "uxgraph_write_edgelist_csv", I32, CDECL, "PTR,STRPTR", g, path)
END FUNCTION

FUNCTION ReadEdgeListCSV(path AS STRING, directed AS I32) AS U64
    RETURN CALL(DLL, "uxgraph.dll", "uxgraph_read_edgelist_csv", PTR, CDECL, "STRPTR,I32", path, directed)
END FUNCTION

FUNCTION MakePath(vertices AS I32, directed AS I32) AS U64
    RETURN CALL(DLL, "uxgraph.dll", "uxgraph_make_path", PTR, CDECL, "I32,I32", vertices, directed)
END FUNCTION

FUNCTION MakeCycle(vertices AS I32, directed AS I32) AS U64
    RETURN CALL(DLL, "uxgraph.dll", "uxgraph_make_cycle", PTR, CDECL, "I32,I32", vertices, directed)
END FUNCTION

FUNCTION MakeComplete(vertices AS I32, directed AS I32) AS U64
    RETURN CALL(DLL, "uxgraph.dll", "uxgraph_make_complete", PTR, CDECL, "I32,I32", vertices, directed)
END FUNCTION

END NAMESPACE
