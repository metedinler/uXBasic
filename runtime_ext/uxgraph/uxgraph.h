#ifndef UXGRAPH_H
#define UXGRAPH_H

#ifdef __cplusplus
extern "C" {
#endif

#if defined(_WIN32)
#define UXG_API __declspec(dllexport)
#else
#define UXG_API
#endif

UXG_API void*  uxgraph_create(int vertices, int directed);
UXG_API void   uxgraph_free(void* handle);
UXG_API int    uxgraph_add_vertex(void* handle);
UXG_API int    uxgraph_add_vertices(void* handle, int count);
UXG_API int    uxgraph_add_edge(void* handle, int from_v, int to_v);
UXG_API int    uxgraph_vcount(void* handle);
UXG_API int    uxgraph_ecount(void* handle);
UXG_API int    uxgraph_is_directed(void* handle);
UXG_API int    uxgraph_has_edge(void* handle, int from_v, int to_v);
UXG_API int    uxgraph_degree(void* handle, int v);
UXG_API int    uxgraph_in_degree(void* handle, int v);
UXG_API int    uxgraph_out_degree(void* handle, int v);
UXG_API double uxgraph_density(void* handle);
UXG_API int    uxgraph_self_loops(void* handle);
UXG_API int    uxgraph_components_count(void* handle);
UXG_API int    uxgraph_is_connected(void* handle);
UXG_API int    uxgraph_shortest_distance(void* handle, int source, int target);
UXG_API int    uxgraph_path_exists(void* handle, int source, int target);
UXG_API int    uxgraph_triangle_count(void* handle);
UXG_API double uxgraph_transitivity(void* handle);

UXG_API void*  uxgraph_degree_vector(void* handle, int mode);
UXG_API void*  uxgraph_bfs_distances(void* handle, int source);
UXG_API int    uxgraph_vec_count(void* vec_handle);
UXG_API double uxgraph_vec_get(void* vec_handle, int index);
UXG_API void   uxgraph_vec_free(void* vec_handle);

UXG_API int    uxgraph_write_edgelist_csv(void* handle, const char* path);
UXG_API void*  uxgraph_read_edgelist_csv(const char* path, int directed);

UXG_API void*  uxgraph_make_path(int vertices, int directed);
UXG_API void*  uxgraph_make_cycle(int vertices, int directed);
UXG_API void*  uxgraph_make_complete(int vertices, int directed);

#ifdef __cplusplus
}
#endif
#endif
