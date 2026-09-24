#include "uxgraph.h"

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#ifdef UXGRAPH_USE_IGRAPH
#include <igraph.h>
#endif

typedef struct UXGraph {
    int directed;
    int vertices;
    int edge_count;
    int edge_cap;
    int *from;
    int *to;
#ifdef UXGRAPH_USE_IGRAPH
    igraph_t ig;
    int ig_initialized;
#endif
} UXGraph;

typedef struct UXGraphVec {
    int count;
    double *data;
} UXGraphVec;

static int uxg_valid_vertex(UXGraph *g, int v) {
    return g && v >= 0 && v < g->vertices;
}

static int uxg_reserve_edges(UXGraph *g, int need) {
    if (!g) return 0;
    if (need <= g->edge_cap) return 1;
    int new_cap = g->edge_cap ? g->edge_cap * 2 : 16;
    while (new_cap < need) new_cap *= 2;
    int *nf = (int*)realloc(g->from, sizeof(int) * new_cap);
    int *nt = (int*)realloc(g->to, sizeof(int) * new_cap);
    if (!nf || !nt) {
        free(nf);
        free(nt);
        return 0;
    }
    g->from = nf;
    g->to = nt;
    g->edge_cap = new_cap;
    return 1;
}

static UXGraphVec* uxg_vec_create(int count) {
    if (count < 0) return NULL;
    UXGraphVec *v = (UXGraphVec*)calloc(1, sizeof(UXGraphVec));
    if (!v) return NULL;
    v->count = count;
    if (count > 0) {
        v->data = (double*)calloc((size_t)count, sizeof(double));
        if (!v->data) {
            free(v);
            return NULL;
        }
    }
    return v;
}

UXG_API void* uxgraph_create(int vertices, int directed) {
    if (vertices < 0) vertices = 0;
    UXGraph *g = (UXGraph*)calloc(1, sizeof(UXGraph));
    if (!g) return NULL;
    g->directed = directed ? 1 : 0;
    g->vertices = vertices;
    g->edge_count = 0;
    g->edge_cap = 0;
    g->from = NULL;
    g->to = NULL;
#ifdef UXGRAPH_USE_IGRAPH
    if (igraph_empty(&g->ig, (igraph_integer_t)vertices, g->directed) == IGRAPH_SUCCESS) {
        g->ig_initialized = 1;
    } else {
        g->ig_initialized = 0;
    }
#endif
    return g;
}

UXG_API void uxgraph_free(void* handle) {
    UXGraph *g = (UXGraph*)handle;
    if (!g) return;
#ifdef UXGRAPH_USE_IGRAPH
    if (g->ig_initialized) igraph_destroy(&g->ig);
#endif
    free(g->from);
    free(g->to);
    free(g);
}

UXG_API int uxgraph_add_vertex(void* handle) {
    UXGraph *g = (UXGraph*)handle;
    if (!g) return -1;
    int id = g->vertices;
    g->vertices += 1;
#ifdef UXGRAPH_USE_IGRAPH
    if (g->ig_initialized) igraph_add_vertices(&g->ig, 1, NULL);
#endif
    return id;
}

UXG_API int uxgraph_add_vertices(void* handle, int count) {
    UXGraph *g = (UXGraph*)handle;
    if (!g || count < 0) return 0;
    int old = g->vertices;
    g->vertices += count;
#ifdef UXGRAPH_USE_IGRAPH
    if (g->ig_initialized && count > 0) igraph_add_vertices(&g->ig, count, NULL);
#endif
    return old;
}

UXG_API int uxgraph_add_edge(void* handle, int from_v, int to_v) {
    UXGraph *g = (UXGraph*)handle;
    if (!g || !uxg_valid_vertex(g, from_v) || !uxg_valid_vertex(g, to_v)) return 0;
    if (!uxg_reserve_edges(g, g->edge_count + 1)) return 0;
    g->from[g->edge_count] = from_v;
    g->to[g->edge_count] = to_v;
    g->edge_count += 1;
#ifdef UXGRAPH_USE_IGRAPH
    if (g->ig_initialized) igraph_add_edge(&g->ig, from_v, to_v);
#endif
    return 1;
}

UXG_API int uxgraph_vcount(void* handle) {
    UXGraph *g = (UXGraph*)handle;
    return g ? g->vertices : 0;
}

UXG_API int uxgraph_ecount(void* handle) {
    UXGraph *g = (UXGraph*)handle;
    return g ? g->edge_count : 0;
}

UXG_API int uxgraph_is_directed(void* handle) {
    UXGraph *g = (UXGraph*)handle;
    return g ? g->directed : 0;
}

UXG_API int uxgraph_has_edge(void* handle, int from_v, int to_v) {
    UXGraph *g = (UXGraph*)handle;
    if (!g) return 0;
    for (int i = 0; i < g->edge_count; ++i) {
        if (g->from[i] == from_v && g->to[i] == to_v) return 1;
        if (!g->directed && g->from[i] == to_v && g->to[i] == from_v) return 1;
    }
    return 0;
}

UXG_API int uxgraph_in_degree(void* handle, int v) {
    UXGraph *g = (UXGraph*)handle;
    if (!uxg_valid_vertex(g, v)) return 0;
    int d = 0;
    for (int i = 0; i < g->edge_count; ++i) {
        if (g->to[i] == v) d++;
        if (!g->directed && g->from[i] == v && g->to[i] != v) d++;
    }
    return d;
}

UXG_API int uxgraph_out_degree(void* handle, int v) {
    UXGraph *g = (UXGraph*)handle;
    if (!uxg_valid_vertex(g, v)) return 0;
    int d = 0;
    for (int i = 0; i < g->edge_count; ++i) {
        if (g->from[i] == v) d++;
        if (!g->directed && g->to[i] == v && g->from[i] != v) d++;
    }
    return d;
}

UXG_API int uxgraph_degree(void* handle, int v) {
    UXGraph *g = (UXGraph*)handle;
    if (!uxg_valid_vertex(g, v)) return 0;
    if (g->directed) return uxgraph_in_degree(handle, v) + uxgraph_out_degree(handle, v);
    return uxgraph_out_degree(handle, v);
}

UXG_API double uxgraph_density(void* handle) {
    UXGraph *g = (UXGraph*)handle;
    if (!g || g->vertices < 2) return 0.0;
    double n = (double)g->vertices;
    if (g->directed) return (double)g->edge_count / (n * (n - 1.0));
    return (double)g->edge_count / (n * (n - 1.0) / 2.0);
}

UXG_API int uxgraph_self_loops(void* handle) {
    UXGraph *g = (UXGraph*)handle;
    if (!g) return 0;
    int c = 0;
    for (int i = 0; i < g->edge_count; ++i) if (g->from[i] == g->to[i]) c++;
    return c;
}

static int uxg_fill_neighbors(UXGraph *g, int v, int *neighbors, int maxn) {
    int c = 0;
    for (int i = 0; i < g->edge_count; ++i) {
        if (g->from[i] == v && c < maxn) neighbors[c++] = g->to[i];
        if (!g->directed && g->to[i] == v && g->from[i] != v && c < maxn) neighbors[c++] = g->from[i];
        if (g->directed && g->to[i] == v && c < maxn) neighbors[c++] = g->from[i]; // weak traversal
    }
    return c;
}

static int uxg_bfs_distance(UXGraph *g, int source, int target, int weak, double *dist_out) {
    if (!uxg_valid_vertex(g, source)) return -1;
    if (target >= 0 && !uxg_valid_vertex(g, target)) return -1;
    int n = g->vertices;
    int *q = (int*)malloc(sizeof(int) * n);
    int *dist = (int*)malloc(sizeof(int) * n);
    if (!q || !dist) { free(q); free(dist); return -1; }
    for (int i = 0; i < n; ++i) dist[i] = -1;
    int head = 0, tail = 0;
    q[tail++] = source;
    dist[source] = 0;
    while (head < tail) {
        int v = q[head++];
        if (target >= 0 && v == target) break;
        for (int e = 0; e < g->edge_count; ++e) {
            int u = -1;
            if (g->from[e] == v) u = g->to[e];
            else if ((!g->directed || weak) && g->to[e] == v) u = g->from[e];
            if (u >= 0 && dist[u] < 0) {
                dist[u] = dist[v] + 1;
                q[tail++] = u;
            }
        }
    }
    int d = target >= 0 ? dist[target] : 0;
    if (dist_out) {
        for (int i = 0; i < n; ++i) dist_out[i] = (double)dist[i];
    }
    free(q);
    free(dist);
    return d;
}

UXG_API int uxgraph_shortest_distance(void* handle, int source, int target) {
    UXGraph *g = (UXGraph*)handle;
    if (!g) return -1;
    return uxg_bfs_distance(g, source, target, 0, NULL);
}

UXG_API int uxgraph_path_exists(void* handle, int source, int target) {
    return uxgraph_shortest_distance(handle, source, target) >= 0 ? 1 : 0;
}

UXG_API void* uxgraph_bfs_distances(void* handle, int source) {
    UXGraph *g = (UXGraph*)handle;
    if (!g || !uxg_valid_vertex(g, source)) return NULL;
    UXGraphVec *v = uxg_vec_create(g->vertices);
    if (!v) return NULL;
    uxg_bfs_distance(g, source, -1, 0, v->data);
    return v;
}

UXG_API void* uxgraph_degree_vector(void* handle, int mode) {
    UXGraph *g = (UXGraph*)handle;
    if (!g) return NULL;
    UXGraphVec *v = uxg_vec_create(g->vertices);
    if (!v) return NULL;
    for (int i = 0; i < g->vertices; ++i) {
        if (mode == 1) v->data[i] = (double)uxgraph_in_degree(handle, i);
        else if (mode == 2) v->data[i] = (double)uxgraph_out_degree(handle, i);
        else v->data[i] = (double)uxgraph_degree(handle, i);
    }
    return v;
}

UXG_API int uxgraph_vec_count(void* vec_handle) {
    UXGraphVec *v = (UXGraphVec*)vec_handle;
    return v ? v->count : 0;
}

UXG_API double uxgraph_vec_get(void* vec_handle, int index) {
    UXGraphVec *v = (UXGraphVec*)vec_handle;
    if (!v || index < 0 || index >= v->count) return 0.0;
    return v->data[index];
}

UXG_API void uxgraph_vec_free(void* vec_handle) {
    UXGraphVec *v = (UXGraphVec*)vec_handle;
    if (!v) return;
    free(v->data);
    free(v);
}

UXG_API int uxgraph_components_count(void* handle) {
    UXGraph *g = (UXGraph*)handle;
    if (!g) return 0;
    int n = g->vertices;
    if (n == 0) return 0;
    int *seen = (int*)calloc((size_t)n, sizeof(int));
    int *q = (int*)malloc(sizeof(int) * n);
    if (!seen || !q) { free(seen); free(q); return 0; }

    int comps = 0;
    for (int s = 0; s < n; ++s) {
        if (seen[s]) continue;
        comps++;
        int head = 0, tail = 0;
        q[tail++] = s;
        seen[s] = 1;
        while (head < tail) {
            int v = q[head++];
            for (int e = 0; e < g->edge_count; ++e) {
                int u = -1;
                if (g->from[e] == v) u = g->to[e];
                else if (g->to[e] == v) u = g->from[e];
                if (u >= 0 && !seen[u]) {
                    seen[u] = 1;
                    q[tail++] = u;
                }
            }
        }
    }
    free(seen);
    free(q);
    return comps;
}

UXG_API int uxgraph_is_connected(void* handle) {
    UXGraph *g = (UXGraph*)handle;
    if (!g) return 0;
    if (g->vertices <= 1) return 1;
    return uxgraph_components_count(handle) == 1 ? 1 : 0;
}

UXG_API int uxgraph_triangle_count(void* handle) {
    UXGraph *g = (UXGraph*)handle;
    if (!g) return 0;
    int n = g->vertices;
    int tri = 0;
    for (int i = 0; i < n; ++i) {
        for (int j = i + 1; j < n; ++j) {
            if (!uxgraph_has_edge(g, i, j)) continue;
            for (int k = j + 1; k < n; ++k) {
                if (uxgraph_has_edge(g, i, k) && uxgraph_has_edge(g, j, k)) tri++;
            }
        }
    }
    return tri;
}

UXG_API double uxgraph_transitivity(void* handle) {
    UXGraph *g = (UXGraph*)handle;
    if (!g) return 0.0;
    double triplets = 0.0;
    for (int i = 0; i < g->vertices; ++i) {
        double d = (double)uxgraph_degree(g, i);
        triplets += d * (d - 1.0) / 2.0;
    }
    if (triplets <= 0.0) return 0.0;
    return 3.0 * (double)uxgraph_triangle_count(g) / triplets;
}

UXG_API int uxgraph_write_edgelist_csv(void* handle, const char* path) {
    UXGraph *g = (UXGraph*)handle;
    if (!g || !path) return 0;
    FILE *f = fopen(path, "w");
    if (!f) return 0;
    fprintf(f, "from,to\n");
    for (int i = 0; i < g->edge_count; ++i) {
        fprintf(f, "%d,%d\n", g->from[i], g->to[i]);
    }
    fclose(f);
    return 1;
}

UXG_API void* uxgraph_read_edgelist_csv(const char* path, int directed) {
    if (!path) return NULL;
    FILE *f = fopen(path, "r");
    if (!f) return NULL;

    int cap = 128, count = 0, maxv = -1;
    int *from = (int*)malloc(sizeof(int) * cap);
    int *to = (int*)malloc(sizeof(int) * cap);
    if (!from || !to) { fclose(f); free(from); free(to); return NULL; }

    char line[256];
    while (fgets(line, sizeof(line), f)) {
        int a, b;
        if (sscanf(line, "%d,%d", &a, &b) == 2) {
            if (count >= cap) {
                cap *= 2;
                int *nf = (int*)realloc(from, sizeof(int) * cap);
                int *nt = (int*)realloc(to, sizeof(int) * cap);
                if (!nf || !nt) { free(nf); free(nt); free(from); free(to); fclose(f); return NULL; }
                from = nf; to = nt;
            }
            from[count] = a; to[count] = b; count++;
            if (a > maxv) maxv = a;
            if (b > maxv) maxv = b;
        }
    }
    fclose(f);

    UXGraph *g = (UXGraph*)uxgraph_create(maxv + 1, directed);
    if (!g) { free(from); free(to); return NULL; }
    for (int i = 0; i < count; ++i) uxgraph_add_edge(g, from[i], to[i]);
    free(from);
    free(to);
    return g;
}

UXG_API void* uxgraph_make_path(int vertices, int directed) {
    UXGraph *g = (UXGraph*)uxgraph_create(vertices, directed);
    if (!g) return NULL;
    for (int i = 0; i < vertices - 1; ++i) uxgraph_add_edge(g, i, i + 1);
    return g;
}

UXG_API void* uxgraph_make_cycle(int vertices, int directed) {
    UXGraph *g = (UXGraph*)uxgraph_make_path(vertices, directed);
    if (!g) return NULL;
    if (vertices > 1) uxgraph_add_edge(g, vertices - 1, 0);
    return g;
}

UXG_API void* uxgraph_make_complete(int vertices, int directed) {
    UXGraph *g = (UXGraph*)uxgraph_create(vertices, directed);
    if (!g) return NULL;
    for (int i = 0; i < vertices; ++i) {
        for (int j = 0; j < vertices; ++j) {
            if (i == j) continue;
            if (!directed && j <= i) continue;
            uxgraph_add_edge(g, i, j);
        }
    }
    return g;
}
