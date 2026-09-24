// uXBasic uxcollections.dll - GLib-backed collection wrapper
// Provides List/Stack/Queue/Deque/Dict/Set/Tree/Node primitives as DLL calls.
// Graph and DataFrame are intentionally separate modules: uxgraph (igraph) and uxdataframe (DuckDB/Arrow).
#include <glib.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <math.h>
#include <ctype.h>

#if defined(_WIN32)
#include <windows.h>
#define UX_EXPORT __declspec(dllexport)
#else
#define UX_EXPORT
#endif

typedef enum { UXV_NULL=0, UXV_I64=1, UXV_F64=2, UXV_STR=3, UXV_PTR=4 } UXVKind;
typedef struct UXValue { UXVKind kind; int64_t i64; double f64; void* ptr; char* str; } UXValue;

typedef enum { C_LIST=1, C_STACK=2, C_QUEUE=3, C_DEQUE=4, C_DICT=5, C_SET=6, C_TREE=7, C_NODE=8 } UXCKind;
typedef struct UXCollection { UXCKind kind; void* obj; } UXCollection;

static UXValue* val_new_null(void){ UXValue* v=(UXValue*)g_malloc0(sizeof(UXValue)); return v; }
static UXValue* val_new_i64(int64_t x){ UXValue* v=val_new_null(); v->kind=UXV_I64; v->i64=x; return v; }
static UXValue* val_new_f64(double x){ UXValue* v=val_new_null(); v->kind=UXV_F64; v->f64=x; return v; }
static UXValue* val_new_ptr(void* x){ UXValue* v=val_new_null(); v->kind=UXV_PTR; v->ptr=x; return v; }
static UXValue* val_new_str(const char* s){ UXValue* v=val_new_null(); v->kind=UXV_STR; v->str=g_strdup(s?s:""); return v; }
static void val_free(gpointer p){ UXValue* v=(UXValue*)p; if(!v) return; if(v->kind==UXV_STR) g_free(v->str); g_free(v); }
static UXCollection* coll_new(UXCKind k, void* obj){ UXCollection* c=(UXCollection*)g_malloc0(sizeof(UXCollection)); c->kind=k; c->obj=obj; return c; }
static UXCollection* as_coll(void* h, UXCKind k){ UXCollection* c=(UXCollection*)h; if(!c || c->kind!=k) return NULL; return c; }
static GPtrArray* as_list(void* h){ UXCollection* c=as_coll(h,C_LIST); return c?(GPtrArray*)c->obj:NULL; }
static GQueue* as_queue_kind(void* h, UXCKind k){ UXCollection* c=as_coll(h,k); return c?(GQueue*)c->obj:NULL; }
// DICT/SET need insertion-order iteration (to match the AST/MIR interpreters'
// own LIST/DICT/SET FOR EACH semantics) but GLib's GHashTable enumeration
// order is unspecified -- so each ordered hash keeps its own key list
// alongside the table, holding independent g_strdup'd copies of the keys
// (never the table's own key pointers) so a g_hash_table_replace on an
// existing key can never leave a dangling entry in the order list.
typedef struct { GHashTable* table; GPtrArray* orderedKeys; } UXOrderedHash;
static UXOrderedHash* ohash_new(GDestroyNotify valFree){
    UXOrderedHash* oh=(UXOrderedHash*)g_malloc0(sizeof(UXOrderedHash));
    oh->table=g_hash_table_new_full(g_str_hash,g_str_equal,g_free,valFree);
    oh->orderedKeys=g_ptr_array_new_with_free_func(g_free);
    return oh;
}
static void ohash_free(UXOrderedHash* oh){ if(!oh) return; g_hash_table_destroy(oh->table); g_ptr_array_free(oh->orderedKeys,TRUE); g_free(oh); }
static void ohash_set(UXOrderedHash* oh, const char* k, gpointer val){
    if(!g_hash_table_contains(oh->table,k)) g_ptr_array_add(oh->orderedKeys,g_strdup(k));
    g_hash_table_replace(oh->table,g_strdup(k),val);
}
static int ohash_remove(UXOrderedHash* oh, const char* k){
    if(!g_hash_table_remove(oh->table,k)) return 0;
    guint i;
    for(i=0;i<oh->orderedKeys->len;i++){ if(g_strcmp0((const char*)g_ptr_array_index(oh->orderedKeys,i),k)==0){ g_ptr_array_remove_index(oh->orderedKeys,i); break; } }
    return 1;
}
static const char* ohash_key_at(UXOrderedHash* oh, int64_t idx){ if(!oh||idx<0||idx>=(int64_t)oh->orderedKeys->len) return NULL; return (const char*)g_ptr_array_index(oh->orderedKeys,(guint)idx); }
static UXOrderedHash* as_ohash(void* h, UXCKind k){ UXCollection* c=as_coll(h,k); return c?(UXOrderedHash*)c->obj:NULL; }
static GHashTable* as_hash(void* h, UXCKind k){ UXCollection* c=as_coll(h,k); return c?(GHashTable*)c->obj:NULL; }
static GTree* as_tree(void* h){ UXCollection* c=as_coll(h,C_TREE); return c?(GTree*)c->obj:NULL; }
static int str_cmp(gconstpointer a, gconstpointer b, gpointer user_data){ (void)user_data; return g_strcmp0((const char*)a,(const char*)b); }
static void node_destroy(gpointer data){ val_free(data); }

UX_EXPORT int uxcollections_version(void){ return 1; }
UX_EXPORT int uxcollections_uses_glib(void){ return 1; }

// ---------- LIST ----------
UX_EXPORT void* uxc_list_new(void){ return coll_new(C_LIST, g_ptr_array_new_with_free_func(val_free)); }
UX_EXPORT void uxc_list_free(void* h){ UXCollection* c=as_coll(h,C_LIST); if(!c) return; g_ptr_array_free((GPtrArray*)c->obj, TRUE); g_free(c); }
UX_EXPORT int64_t uxc_list_count(void* h){ GPtrArray* a=as_list(h); return a?(int64_t)a->len:0; }
UX_EXPORT void uxc_list_clear(void* h){ GPtrArray* a=as_list(h); if(a) g_ptr_array_set_size(a,0); }
UX_EXPORT void uxc_list_push_i64(void* h,int64_t x){ GPtrArray* a=as_list(h); if(a) g_ptr_array_add(a,val_new_i64(x)); }
UX_EXPORT void uxc_list_push_f64(void* h,double x){ GPtrArray* a=as_list(h); if(a) g_ptr_array_add(a,val_new_f64(x)); }
UX_EXPORT void uxc_list_push_str(void* h,const char* s){ GPtrArray* a=as_list(h); if(a) g_ptr_array_add(a,val_new_str(s)); }
UX_EXPORT int uxc_list_remove_at(void* h,int64_t idx){ GPtrArray* a=as_list(h); if(!a||idx<0||idx>=(int64_t)a->len) return 0; g_ptr_array_remove_index(a,(guint)idx); return 1; }
static UXValue* list_val(void* h,int64_t idx){ GPtrArray* a=as_list(h); if(!a||idx<0||idx>=(int64_t)a->len) return NULL; return (UXValue*)g_ptr_array_index(a,(guint)idx); }
UX_EXPORT int64_t uxc_list_get_i64(void* h,int64_t idx){ UXValue* v=list_val(h,idx); if(!v) return 0; if(v->kind==UXV_I64) return v->i64; if(v->kind==UXV_F64) return (int64_t)v->f64; return 0; }
UX_EXPORT double uxc_list_get_f64(void* h,int64_t idx){ UXValue* v=list_val(h,idx); if(!v) return 0; if(v->kind==UXV_F64) return v->f64; if(v->kind==UXV_I64) return (double)v->i64; return 0; }
UX_EXPORT const char* uxc_list_get_str(void* h,int64_t idx){ UXValue* v=list_val(h,idx); if(!v) return ""; if(v->kind==UXV_STR) return v->str?v->str:""; return ""; }
UX_EXPORT int uxc_list_set_i64(void* h,int64_t idx,int64_t x){ GPtrArray* a=as_list(h); if(!a||idx<0||idx>=(int64_t)a->len) return 0; val_free(g_ptr_array_index(a,(guint)idx)); g_ptr_array_index(a,(guint)idx)=val_new_i64(x); return 1; }
UX_EXPORT int uxc_list_set_f64(void* h,int64_t idx,double x){ GPtrArray* a=as_list(h); if(!a||idx<0||idx>=(int64_t)a->len) return 0; val_free(g_ptr_array_index(a,(guint)idx)); g_ptr_array_index(a,(guint)idx)=val_new_f64(x); return 1; }
UX_EXPORT int uxc_list_set_str(void* h,int64_t idx,const char* s){ GPtrArray* a=as_list(h); if(!a||idx<0||idx>=(int64_t)a->len) return 0; val_free(g_ptr_array_index(a,(guint)idx)); g_ptr_array_index(a,(guint)idx)=val_new_str(s); return 1; }
UX_EXPORT int uxc_list_get_kind(void* h,int64_t idx){ UXValue* v=list_val(h,idx); return v?v->kind:UXV_NULL; }

static UXValue* val_clone(UXValue* v){ if(!v) return val_new_i64(0); if(v->kind==UXV_STR) return val_new_str(v->str); if(v->kind==UXV_F64) return val_new_f64(v->f64); return val_new_i64(v->i64); }
static double val_num(UXValue* v){ if(!v) return 0; return (v->kind==UXV_F64)?v->f64:(double)v->i64; }

// ---------- LIST: sorting ----------
static gint uxc_cmp_num_asc(gconstpointer a, gconstpointer b, gpointer user_data){ (void)user_data; double da=val_num(*(UXValue**)a); double db=val_num(*(UXValue**)b); return (da>db)-(da<db); }
static gint uxc_cmp_str_asc(gconstpointer a, gconstpointer b, gpointer user_data){ (void)user_data; UXValue* va=*(UXValue**)a; UXValue* vb=*(UXValue**)b; const char* sa=(va->kind==UXV_STR&&va->str)?va->str:""; const char* sb=(vb->kind==UXV_STR&&vb->str)?vb->str:""; return g_strcmp0(sa,sb); }
UX_EXPORT void uxc_list_sort(void* h){ GPtrArray* a=as_list(h); if(a) g_ptr_array_sort_with_data(a,uxc_cmp_num_asc,NULL); }
UX_EXPORT void uxc_list_sort_alpha(void* h){ GPtrArray* a=as_list(h); if(a) g_ptr_array_sort_with_data(a,uxc_cmp_str_asc,NULL); }
UX_EXPORT void uxc_list_reverse(void* h){ GPtrArray* a=as_list(h); if(!a) return; guint n=a->len,i; for(i=0;i<n/2;i++){ gpointer t=a->pdata[i]; a->pdata[i]=a->pdata[n-1-i]; a->pdata[n-1-i]=t; } }

// ---------- LIST: statistics ----------
UX_EXPORT double uxc_list_sum(void* h){ GPtrArray* a=as_list(h); if(!a) return 0; double s=0; guint i; for(i=0;i<a->len;i++) s+=val_num((UXValue*)g_ptr_array_index(a,i)); return s; }
UX_EXPORT double uxc_list_average(void* h){ GPtrArray* a=as_list(h); if(!a||a->len==0) return 0; return uxc_list_sum(h)/(double)a->len; }
UX_EXPORT double uxc_list_min(void* h){ GPtrArray* a=as_list(h); if(!a||a->len==0) return 0; double m=val_num((UXValue*)g_ptr_array_index(a,0)); guint i; for(i=1;i<a->len;i++){ double x=val_num((UXValue*)g_ptr_array_index(a,i)); if(x<m) m=x; } return m; }
UX_EXPORT double uxc_list_max(void* h){ GPtrArray* a=as_list(h); if(!a||a->len==0) return 0; double m=val_num((UXValue*)g_ptr_array_index(a,0)); guint i; for(i=1;i<a->len;i++){ double x=val_num((UXValue*)g_ptr_array_index(a,i)); if(x>m) m=x; } return m; }
UX_EXPORT double uxc_list_range(void* h){ return uxc_list_max(h)-uxc_list_min(h); }
static int uxc_dcmp(const void* a, const void* b){ double da=*(const double*)a, db=*(const double*)b; return (da>db)-(da<db); }
static double* uxc_list_sorted_doubles(void* h, guint* nOut){ GPtrArray* a=as_list(h); guint n=a?a->len:0; *nOut=n; if(n==0) return NULL; double* buf=(double*)g_malloc(sizeof(double)*n); guint i; for(i=0;i<n;i++) buf[i]=val_num((UXValue*)g_ptr_array_index(a,i)); qsort(buf,n,sizeof(double),uxc_dcmp); return buf; }
UX_EXPORT double uxc_list_median(void* h){ guint n; double* buf=uxc_list_sorted_doubles(h,&n); if(n==0) return 0; double r=(n%2==1)?buf[n/2]:(buf[n/2-1]+buf[n/2])/2.0; g_free(buf); return r; }
UX_EXPORT double uxc_list_percentile(void* h, double p){ guint n; double* buf=uxc_list_sorted_doubles(h,&n); if(n==0) return 0; if(p<0) p=0; if(p>100) p=100; double idx=(p/100.0)*(double)(n-1); guint lo=(guint)idx; guint hi=(lo+1<n)?lo+1:lo; double frac=idx-(double)lo; double r=buf[lo]+(buf[hi]-buf[lo])*frac; g_free(buf); return r; }
UX_EXPORT double uxc_list_variance(void* h){ GPtrArray* a=as_list(h); if(!a||a->len==0) return 0; double mean=uxc_list_average(h); double sq=0; guint i; for(i=0;i<a->len;i++){ double d=val_num((UXValue*)g_ptr_array_index(a,i))-mean; sq+=d*d; } return sq/(double)a->len; }
UX_EXPORT double uxc_list_stddev(void* h){ return sqrt(uxc_list_variance(h)); }
UX_EXPORT double uxc_list_stderr(void* h){ GPtrArray* a=as_list(h); guint n=a?a->len:0; if(n==0) return 0; return uxc_list_stddev(h)/sqrt((double)n); }
UX_EXPORT double uxc_list_mode(void* h){ GPtrArray* a=as_list(h); if(!a||a->len==0) return 0; guint n=a->len,i,j; double bestVal=0; guint bestCount=0; for(i=0;i<n;i++){ double v=val_num((UXValue*)g_ptr_array_index(a,i)); guint count=0; for(j=0;j<n;j++){ if(val_num((UXValue*)g_ptr_array_index(a,j))==v) count++; } if(count>bestCount){ bestCount=count; bestVal=v; } } return bestVal; }

// ---------- LIST: text ----------
UX_EXPORT const char* uxc_list_join(void* h, const char* sep){ GPtrArray* a=as_list(h); static __declspec(thread) char buf[8192]; buf[0]=0; if(!a) return buf; GString* gs=g_string_new(""); guint i; for(i=0;i<a->len;i++){ UXValue* v=(UXValue*)g_ptr_array_index(a,i); if(i>0) g_string_append(gs,sep?sep:""); if(v->kind==UXV_STR&&v->str) g_string_append(gs,v->str); else if(v->kind==UXV_I64){ char tmp[32]; snprintf(tmp,sizeof(tmp),"%lld",(long long)v->i64); g_string_append(gs,tmp); } else if(v->kind==UXV_F64){ char tmp[64]; snprintf(tmp,sizeof(tmp),"%g",v->f64); g_string_append(gs,tmp); } } strncpy(buf,gs->str,sizeof(buf)-1); buf[sizeof(buf)-1]=0; g_string_free(gs,TRUE); return buf; }
UX_EXPORT void* uxc_list_split_to_list(const char* text, const char* sep){ GPtrArray* dst=g_ptr_array_new_with_free_func(val_free); if(text){ gchar** parts=g_strsplit(text,(sep&&sep[0])?sep:" ",-1); int i; for(i=0;parts[i]!=NULL;i++) g_ptr_array_add(dst,val_new_str(parts[i])); g_strfreev(parts); } return coll_new(C_LIST,dst); }
static void* uxc_list_map_str(void* h, void (*xform)(char*)){ GPtrArray* src=as_list(h); GPtrArray* dst=g_ptr_array_new_with_free_func(val_free); if(src){ guint i; for(i=0;i<src->len;i++){ UXValue* v=(UXValue*)g_ptr_array_index(src,i); const char* s=(v->kind==UXV_STR&&v->str)?v->str:""; char* copy=g_strdup(s); if(xform) xform(copy); g_ptr_array_add(dst,val_new_str(copy)); g_free(copy); } } return coll_new(C_LIST,dst); }
static void uxc_xform_upper(char* s){ for(;*s;s++) *s=(char)toupper((unsigned char)*s); }
static void uxc_xform_lower(char* s){ for(;*s;s++) *s=(char)tolower((unsigned char)*s); }
static void uxc_xform_capitalize(char* s){ if(s[0]) s[0]=(char)toupper((unsigned char)s[0]); }
static void uxc_xform_trim(char* s){ g_strstrip(s); }
UX_EXPORT void* uxc_list_to_upper(void* h){ return uxc_list_map_str(h,uxc_xform_upper); }
UX_EXPORT void* uxc_list_to_lower(void* h){ return uxc_list_map_str(h,uxc_xform_lower); }
UX_EXPORT void* uxc_list_capitalize(void* h){ return uxc_list_map_str(h,uxc_xform_capitalize); }
UX_EXPORT void* uxc_list_trim(void* h){ return uxc_list_map_str(h,uxc_xform_trim); }
UX_EXPORT void* uxc_list_filter_by_prefix(void* h, const char* prefix){ GPtrArray* src=as_list(h); GPtrArray* dst=g_ptr_array_new_with_free_func(val_free); if(src){ guint i; for(i=0;i<src->len;i++){ UXValue* v=(UXValue*)g_ptr_array_index(src,i); if(v->kind==UXV_STR&&v->str&&g_str_has_prefix(v->str,prefix?prefix:"")) g_ptr_array_add(dst,val_new_str(v->str)); } } return coll_new(C_LIST,dst); }
UX_EXPORT void* uxc_list_filter_by_suffix(void* h, const char* suffix){ GPtrArray* src=as_list(h); GPtrArray* dst=g_ptr_array_new_with_free_func(val_free); if(src){ guint i; for(i=0;i<src->len;i++){ UXValue* v=(UXValue*)g_ptr_array_index(src,i); if(v->kind==UXV_STR&&v->str&&g_str_has_suffix(v->str,suffix?suffix:"")) g_ptr_array_add(dst,val_new_str(v->str)); } } return coll_new(C_LIST,dst); }
UX_EXPORT void* uxc_list_filter_contains(void* h, const char* needle){ GPtrArray* src=as_list(h); GPtrArray* dst=g_ptr_array_new_with_free_func(val_free); if(src){ guint i; for(i=0;i<src->len;i++){ UXValue* v=(UXValue*)g_ptr_array_index(src,i); if(v->kind==UXV_STR&&v->str&&needle&&strstr(v->str,needle)) g_ptr_array_add(dst,val_new_str(v->str)); } } return coll_new(C_LIST,dst); }

// ---------- LIST: search / structural ----------
UX_EXPORT int64_t uxc_list_index_of_i64(void* h, int64_t x){ GPtrArray* a=as_list(h); if(!a) return -1; guint i; for(i=0;i<a->len;i++){ UXValue* v=(UXValue*)g_ptr_array_index(a,i); if(v->kind==UXV_I64&&v->i64==x) return (int64_t)i; } return -1; }
UX_EXPORT int64_t uxc_list_index_of_f64(void* h, double x){ GPtrArray* a=as_list(h); if(!a) return -1; guint i; for(i=0;i<a->len;i++){ UXValue* v=(UXValue*)g_ptr_array_index(a,i); if(v->kind==UXV_F64&&v->f64==x) return (int64_t)i; } return -1; }
UX_EXPORT int64_t uxc_list_index_of_str(void* h, const char* s){ GPtrArray* a=as_list(h); if(!a) return -1; guint i; for(i=0;i<a->len;i++){ UXValue* v=(UXValue*)g_ptr_array_index(a,i); if(v->kind==UXV_STR&&g_strcmp0(v->str,s)==0) return (int64_t)i; } return -1; }
UX_EXPORT int uxc_list_contains_i64(void* h, int64_t x){ return uxc_list_index_of_i64(h,x)>=0; }
UX_EXPORT int uxc_list_contains_f64(void* h, double x){ return uxc_list_index_of_f64(h,x)>=0; }
UX_EXPORT int uxc_list_contains_str(void* h, const char* s){ return uxc_list_index_of_str(h,s)>=0; }
UX_EXPORT int64_t uxc_list_count_value_i64(void* h, int64_t x){ GPtrArray* a=as_list(h); if(!a) return 0; int64_t c=0; guint i; for(i=0;i<a->len;i++){ UXValue* v=(UXValue*)g_ptr_array_index(a,i); if(v->kind==UXV_I64&&v->i64==x) c++; } return c; }
UX_EXPORT int64_t uxc_list_count_value_f64(void* h, double x){ GPtrArray* a=as_list(h); if(!a) return 0; int64_t c=0; guint i; for(i=0;i<a->len;i++){ UXValue* v=(UXValue*)g_ptr_array_index(a,i); if(v->kind==UXV_F64&&v->f64==x) c++; } return c; }
UX_EXPORT int64_t uxc_list_count_value_str(void* h, const char* s){ GPtrArray* a=as_list(h); if(!a) return 0; int64_t c=0; guint i; for(i=0;i<a->len;i++){ UXValue* v=(UXValue*)g_ptr_array_index(a,i); if(v->kind==UXV_STR&&g_strcmp0(v->str,s)==0) c++; } return c; }
UX_EXPORT void* uxc_list_slice(void* h, int64_t start, int64_t end){ GPtrArray* src=as_list(h); GPtrArray* dst=g_ptr_array_new_with_free_func(val_free); if(src){ int64_t n=(int64_t)src->len; if(start<0) start=0; if(end>n) end=n; int64_t i; for(i=start;i<end;i++) g_ptr_array_add(dst,val_clone((UXValue*)g_ptr_array_index(src,(guint)i))); } return coll_new(C_LIST,dst); }
UX_EXPORT void uxc_list_extend(void* dstH, void* srcH){ GPtrArray* dst=as_list(dstH); GPtrArray* src=as_list(srcH); if(!dst||!src) return; guint i; for(i=0;i<src->len;i++) g_ptr_array_add(dst,val_clone((UXValue*)g_ptr_array_index(src,i))); }
UX_EXPORT int uxc_list_insert_at_i64(void* h, int64_t idx, int64_t x){ GPtrArray* a=as_list(h); if(!a||idx<0||idx>(int64_t)a->len) return 0; g_ptr_array_insert(a,(gint)idx,val_new_i64(x)); return 1; }
UX_EXPORT int uxc_list_insert_at_f64(void* h, int64_t idx, double x){ GPtrArray* a=as_list(h); if(!a||idx<0||idx>(int64_t)a->len) return 0; g_ptr_array_insert(a,(gint)idx,val_new_f64(x)); return 1; }
UX_EXPORT int uxc_list_insert_at_str(void* h, int64_t idx, const char* s){ GPtrArray* a=as_list(h); if(!a||idx<0||idx>(int64_t)a->len) return 0; g_ptr_array_insert(a,(gint)idx,val_new_str(s)); return 1; }
UX_EXPORT void* uxc_list_unique(void* h){ GPtrArray* src=as_list(h); GPtrArray* dst=g_ptr_array_new_with_free_func(val_free); if(src){ guint i,j; for(i=0;i<src->len;i++){ UXValue* v=(UXValue*)g_ptr_array_index(src,i); int dup=0; for(j=0;j<dst->len;j++){ UXValue* w=(UXValue*)g_ptr_array_index(dst,j); if(w->kind!=v->kind) continue; if(v->kind==UXV_I64&&w->i64==v->i64){dup=1;break;} if(v->kind==UXV_F64&&w->f64==v->f64){dup=1;break;} if(v->kind==UXV_STR&&g_strcmp0(w->str,v->str)==0){dup=1;break;} } if(!dup) g_ptr_array_add(dst,val_clone(v)); } } return coll_new(C_LIST,dst); }
UX_EXPORT void* uxc_list_clone(void* h){ GPtrArray* src=as_list(h); GPtrArray* dst=g_ptr_array_new_with_free_func(val_free); if(src){ guint i; for(i=0;i<src->len;i++) g_ptr_array_add(dst,val_clone((UXValue*)g_ptr_array_index(src,i))); } return coll_new(C_LIST,dst); }

// ---------- QUEUE / STACK / DEQUE ----------
static void free_queue_values(GQueue* q){ if(!q) return; while(!g_queue_is_empty(q)) val_free(g_queue_pop_head(q)); g_queue_free(q); }
UX_EXPORT void* uxc_stack_new(void){ return coll_new(C_STACK,g_queue_new()); }
UX_EXPORT void* uxc_queue_new(void){ return coll_new(C_QUEUE,g_queue_new()); }
UX_EXPORT void* uxc_deque_new(void){ return coll_new(C_DEQUE,g_queue_new()); }
UX_EXPORT void uxc_stack_free(void* h){ UXCollection* c=as_coll(h,C_STACK); if(c){ free_queue_values((GQueue*)c->obj); g_free(c);} }
UX_EXPORT void uxc_queue_free(void* h){ UXCollection* c=as_coll(h,C_QUEUE); if(c){ free_queue_values((GQueue*)c->obj); g_free(c);} }
UX_EXPORT void uxc_deque_free(void* h){ UXCollection* c=as_coll(h,C_DEQUE); if(c){ free_queue_values((GQueue*)c->obj); g_free(c);} }
UX_EXPORT int64_t uxc_stack_count(void* h){ GQueue* q=as_queue_kind(h,C_STACK); return q?g_queue_get_length(q):0; }
UX_EXPORT int64_t uxc_queue_count(void* h){ GQueue* q=as_queue_kind(h,C_QUEUE); return q?g_queue_get_length(q):0; }
UX_EXPORT int64_t uxc_deque_count(void* h){ GQueue* q=as_queue_kind(h,C_DEQUE); return q?g_queue_get_length(q):0; }
UX_EXPORT void uxc_stack_push_f64(void* h,double x){ GQueue* q=as_queue_kind(h,C_STACK); if(q) g_queue_push_head(q,val_new_f64(x)); }
UX_EXPORT double uxc_stack_pop_f64(void* h){ GQueue* q=as_queue_kind(h,C_STACK); if(!q||g_queue_is_empty(q)) return 0; UXValue* v=(UXValue*)g_queue_pop_head(q); double r=(v->kind==UXV_F64)?v->f64:(double)v->i64; val_free(v); return r; }
UX_EXPORT void uxc_stack_push_i64(void* h,int64_t x){ GQueue* q=as_queue_kind(h,C_STACK); if(q) g_queue_push_head(q,val_new_i64(x)); }
UX_EXPORT int64_t uxc_stack_pop_i64(void* h){ GQueue* q=as_queue_kind(h,C_STACK); if(!q||g_queue_is_empty(q)) return 0; UXValue* v=(UXValue*)g_queue_pop_head(q); int64_t r=(v->kind==UXV_I64)?v->i64:(int64_t)v->f64; val_free(v); return r; }
UX_EXPORT void uxc_stack_push_str(void* h,const char* s){ GQueue* q=as_queue_kind(h,C_STACK); if(q) g_queue_push_head(q,val_new_str(s)); }
UX_EXPORT const char* uxc_stack_pop_str(void* h){ GQueue* q=as_queue_kind(h,C_STACK); if(!q||g_queue_is_empty(q)) return ""; UXValue* v=(UXValue*)g_queue_pop_head(q); static __declspec(thread) char buf[4096]; buf[0]=0; if(v->kind==UXV_STR && v->str) { strncpy(buf,v->str,sizeof(buf)-1); buf[sizeof(buf)-1]=0; } val_free(v); return buf; }
UX_EXPORT int uxc_stack_peek_kind(void* h){ GQueue* q=as_queue_kind(h,C_STACK); if(!q||g_queue_is_empty(q)) return UXV_NULL; UXValue* v=(UXValue*)g_queue_peek_head(q); return v?v->kind:UXV_NULL; }
UX_EXPORT void uxc_queue_push_f64(void* h,double x){ GQueue* q=as_queue_kind(h,C_QUEUE); if(q) g_queue_push_tail(q,val_new_f64(x)); }
UX_EXPORT double uxc_queue_pop_f64(void* h){ GQueue* q=as_queue_kind(h,C_QUEUE); if(!q||g_queue_is_empty(q)) return 0; UXValue* v=(UXValue*)g_queue_pop_head(q); double r=(v->kind==UXV_F64)?v->f64:(double)v->i64; val_free(v); return r; }
UX_EXPORT void uxc_queue_push_i64(void* h,int64_t x){ GQueue* q=as_queue_kind(h,C_QUEUE); if(q) g_queue_push_tail(q,val_new_i64(x)); }
UX_EXPORT int64_t uxc_queue_pop_i64(void* h){ GQueue* q=as_queue_kind(h,C_QUEUE); if(!q||g_queue_is_empty(q)) return 0; UXValue* v=(UXValue*)g_queue_pop_head(q); int64_t r=(v->kind==UXV_I64)?v->i64:(int64_t)v->f64; val_free(v); return r; }
UX_EXPORT void uxc_queue_push_str(void* h,const char* s){ GQueue* q=as_queue_kind(h,C_QUEUE); if(q) g_queue_push_tail(q,val_new_str(s)); }
UX_EXPORT const char* uxc_queue_pop_str(void* h){ GQueue* q=as_queue_kind(h,C_QUEUE); if(!q||g_queue_is_empty(q)) return ""; UXValue* v=(UXValue*)g_queue_pop_head(q); static __declspec(thread) char buf[4096]; buf[0]=0; if(v->kind==UXV_STR && v->str) { strncpy(buf,v->str,sizeof(buf)-1); buf[sizeof(buf)-1]=0; } val_free(v); return buf; }
UX_EXPORT int uxc_queue_peek_kind(void* h){ GQueue* q=as_queue_kind(h,C_QUEUE); if(!q||g_queue_is_empty(q)) return UXV_NULL; UXValue* v=(UXValue*)g_queue_peek_head(q); return v?v->kind:UXV_NULL; }
UX_EXPORT void uxc_deque_push_front_f64(void* h,double x){ GQueue* q=as_queue_kind(h,C_DEQUE); if(q) g_queue_push_head(q,val_new_f64(x)); }
UX_EXPORT void uxc_deque_push_back_f64(void* h,double x){ GQueue* q=as_queue_kind(h,C_DEQUE); if(q) g_queue_push_tail(q,val_new_f64(x)); }
UX_EXPORT double uxc_deque_pop_front_f64(void* h){ GQueue* q=as_queue_kind(h,C_DEQUE); if(!q||g_queue_is_empty(q)) return 0; UXValue* v=(UXValue*)g_queue_pop_head(q); double r=(v->kind==UXV_F64)?v->f64:(double)v->i64; val_free(v); return r; }
UX_EXPORT double uxc_deque_pop_back_f64(void* h){ GQueue* q=as_queue_kind(h,C_DEQUE); if(!q||g_queue_is_empty(q)) return 0; UXValue* v=(UXValue*)g_queue_pop_tail(q); double r=(v->kind==UXV_F64)?v->f64:(double)v->i64; val_free(v); return r; }
UX_EXPORT void uxc_deque_push_front_i64(void* h,int64_t x){ GQueue* q=as_queue_kind(h,C_DEQUE); if(q) g_queue_push_head(q,val_new_i64(x)); }
UX_EXPORT void uxc_deque_push_back_i64(void* h,int64_t x){ GQueue* q=as_queue_kind(h,C_DEQUE); if(q) g_queue_push_tail(q,val_new_i64(x)); }
UX_EXPORT int64_t uxc_deque_pop_front_i64(void* h){ GQueue* q=as_queue_kind(h,C_DEQUE); if(!q||g_queue_is_empty(q)) return 0; UXValue* v=(UXValue*)g_queue_pop_head(q); int64_t r=(v->kind==UXV_I64)?v->i64:(int64_t)v->f64; val_free(v); return r; }
UX_EXPORT int64_t uxc_deque_pop_back_i64(void* h){ GQueue* q=as_queue_kind(h,C_DEQUE); if(!q||g_queue_is_empty(q)) return 0; UXValue* v=(UXValue*)g_queue_pop_tail(q); int64_t r=(v->kind==UXV_I64)?v->i64:(int64_t)v->f64; val_free(v); return r; }
UX_EXPORT void uxc_deque_push_front_str(void* h,const char* s){ GQueue* q=as_queue_kind(h,C_DEQUE); if(q) g_queue_push_head(q,val_new_str(s)); }
UX_EXPORT void uxc_deque_push_back_str(void* h,const char* s){ GQueue* q=as_queue_kind(h,C_DEQUE); if(q) g_queue_push_tail(q,val_new_str(s)); }
UX_EXPORT const char* uxc_deque_pop_front_str(void* h){ GQueue* q=as_queue_kind(h,C_DEQUE); if(!q||g_queue_is_empty(q)) return ""; UXValue* v=(UXValue*)g_queue_pop_head(q); static __declspec(thread) char buf[4096]; buf[0]=0; if(v->kind==UXV_STR && v->str) { strncpy(buf,v->str,sizeof(buf)-1); buf[sizeof(buf)-1]=0; } val_free(v); return buf; }
UX_EXPORT const char* uxc_deque_pop_back_str(void* h){ GQueue* q=as_queue_kind(h,C_DEQUE); if(!q||g_queue_is_empty(q)) return ""; UXValue* v=(UXValue*)g_queue_pop_tail(q); static __declspec(thread) char buf[4096]; buf[0]=0; if(v->kind==UXV_STR && v->str) { strncpy(buf,v->str,sizeof(buf)-1); buf[sizeof(buf)-1]=0; } val_free(v); return buf; }
UX_EXPORT int uxc_deque_peek_front_kind(void* h){ GQueue* q=as_queue_kind(h,C_DEQUE); if(!q||g_queue_is_empty(q)) return UXV_NULL; UXValue* v=(UXValue*)g_queue_peek_head(q); return v?v->kind:UXV_NULL; }
UX_EXPORT int uxc_deque_peek_back_kind(void* h){ GQueue* q=as_queue_kind(h,C_DEQUE); if(!q||g_queue_is_empty(q)) return UXV_NULL; UXValue* v=(UXValue*)g_queue_peek_tail(q); return v?v->kind:UXV_NULL; }

// ---------- STACK/QUEUE/DEQUE: peek by type, empty/clear/clone/contains/toList/pushRange/rotate ----------
UX_EXPORT int64_t uxc_stack_peek_i64(void* h){ GQueue* q=as_queue_kind(h,C_STACK); if(!q||g_queue_is_empty(q)) return 0; UXValue* v=(UXValue*)g_queue_peek_head(q); return (v->kind==UXV_I64)?v->i64:(int64_t)v->f64; }
UX_EXPORT double uxc_stack_peek_f64(void* h){ GQueue* q=as_queue_kind(h,C_STACK); if(!q||g_queue_is_empty(q)) return 0; UXValue* v=(UXValue*)g_queue_peek_head(q); return (v->kind==UXV_F64)?v->f64:(double)v->i64; }
UX_EXPORT const char* uxc_stack_peek_str(void* h){ GQueue* q=as_queue_kind(h,C_STACK); static __declspec(thread) char buf[4096]; buf[0]=0; if(!q||g_queue_is_empty(q)) return buf; UXValue* v=(UXValue*)g_queue_peek_head(q); if(v->kind==UXV_STR&&v->str){ strncpy(buf,v->str,sizeof(buf)-1); buf[sizeof(buf)-1]=0; } return buf; }
UX_EXPORT int64_t uxc_queue_peek_i64(void* h){ GQueue* q=as_queue_kind(h,C_QUEUE); if(!q||g_queue_is_empty(q)) return 0; UXValue* v=(UXValue*)g_queue_peek_head(q); return (v->kind==UXV_I64)?v->i64:(int64_t)v->f64; }
UX_EXPORT double uxc_queue_peek_f64(void* h){ GQueue* q=as_queue_kind(h,C_QUEUE); if(!q||g_queue_is_empty(q)) return 0; UXValue* v=(UXValue*)g_queue_peek_head(q); return (v->kind==UXV_F64)?v->f64:(double)v->i64; }
UX_EXPORT const char* uxc_queue_peek_str(void* h){ GQueue* q=as_queue_kind(h,C_QUEUE); static __declspec(thread) char buf[4096]; buf[0]=0; if(!q||g_queue_is_empty(q)) return buf; UXValue* v=(UXValue*)g_queue_peek_head(q); if(v->kind==UXV_STR&&v->str){ strncpy(buf,v->str,sizeof(buf)-1); buf[sizeof(buf)-1]=0; } return buf; }
UX_EXPORT int64_t uxc_deque_peek_front_i64(void* h){ GQueue* q=as_queue_kind(h,C_DEQUE); if(!q||g_queue_is_empty(q)) return 0; UXValue* v=(UXValue*)g_queue_peek_head(q); return (v->kind==UXV_I64)?v->i64:(int64_t)v->f64; }
UX_EXPORT double uxc_deque_peek_front_f64(void* h){ GQueue* q=as_queue_kind(h,C_DEQUE); if(!q||g_queue_is_empty(q)) return 0; UXValue* v=(UXValue*)g_queue_peek_head(q); return (v->kind==UXV_F64)?v->f64:(double)v->i64; }
UX_EXPORT const char* uxc_deque_peek_front_str(void* h){ GQueue* q=as_queue_kind(h,C_DEQUE); static __declspec(thread) char buf[4096]; buf[0]=0; if(!q||g_queue_is_empty(q)) return buf; UXValue* v=(UXValue*)g_queue_peek_head(q); if(v->kind==UXV_STR&&v->str){ strncpy(buf,v->str,sizeof(buf)-1); buf[sizeof(buf)-1]=0; } return buf; }
UX_EXPORT int64_t uxc_deque_peek_back_i64(void* h){ GQueue* q=as_queue_kind(h,C_DEQUE); if(!q||g_queue_is_empty(q)) return 0; UXValue* v=(UXValue*)g_queue_peek_tail(q); return (v->kind==UXV_I64)?v->i64:(int64_t)v->f64; }
UX_EXPORT double uxc_deque_peek_back_f64(void* h){ GQueue* q=as_queue_kind(h,C_DEQUE); if(!q||g_queue_is_empty(q)) return 0; UXValue* v=(UXValue*)g_queue_peek_tail(q); return (v->kind==UXV_F64)?v->f64:(double)v->i64; }
UX_EXPORT const char* uxc_deque_peek_back_str(void* h){ GQueue* q=as_queue_kind(h,C_DEQUE); static __declspec(thread) char buf[4096]; buf[0]=0; if(!q||g_queue_is_empty(q)) return buf; UXValue* v=(UXValue*)g_queue_peek_tail(q); if(v->kind==UXV_STR&&v->str){ strncpy(buf,v->str,sizeof(buf)-1); buf[sizeof(buf)-1]=0; } return buf; }

UX_EXPORT int uxc_stack_is_empty(void* h){ return uxc_stack_count(h)==0; }
UX_EXPORT int uxc_queue_is_empty(void* h){ return uxc_queue_count(h)==0; }
UX_EXPORT int uxc_deque_is_empty(void* h){ return uxc_deque_count(h)==0; }
UX_EXPORT void uxc_stack_clear(void* h){ GQueue* q=as_queue_kind(h,C_STACK); if(q) while(!g_queue_is_empty(q)) val_free(g_queue_pop_head(q)); }
UX_EXPORT void uxc_queue_clear(void* h){ GQueue* q=as_queue_kind(h,C_QUEUE); if(q) while(!g_queue_is_empty(q)) val_free(g_queue_pop_head(q)); }
UX_EXPORT void uxc_deque_clear(void* h){ GQueue* q=as_queue_kind(h,C_DEQUE); if(q) while(!g_queue_is_empty(q)) val_free(g_queue_pop_head(q)); }

static void* uxc_queue_kind_clone(void* h, UXCKind kind){ GQueue* src=as_queue_kind(h,kind); GQueue* dst=g_queue_new(); if(src){ GList* l=src->head; for(;l!=NULL;l=l->next) g_queue_push_tail(dst,val_clone((UXValue*)l->data)); } return coll_new(kind,dst); }
UX_EXPORT void* uxc_stack_clone(void* h){ return uxc_queue_kind_clone(h,C_STACK); }
UX_EXPORT void* uxc_queue_clone(void* h){ return uxc_queue_kind_clone(h,C_QUEUE); }
UX_EXPORT void* uxc_deque_clone(void* h){ return uxc_queue_kind_clone(h,C_DEQUE); }

static int uxc_queue_kind_contains_i64(void* h, UXCKind kind, int64_t x){ GQueue* q=as_queue_kind(h,kind); if(!q) return 0; GList* l=q->head; for(;l;l=l->next){ UXValue* v=(UXValue*)l->data; if(v->kind==UXV_I64&&v->i64==x) return 1; } return 0; }
static int uxc_queue_kind_contains_f64(void* h, UXCKind kind, double x){ GQueue* q=as_queue_kind(h,kind); if(!q) return 0; GList* l=q->head; for(;l;l=l->next){ UXValue* v=(UXValue*)l->data; if(v->kind==UXV_F64&&v->f64==x) return 1; } return 0; }
static int uxc_queue_kind_contains_str(void* h, UXCKind kind, const char* s){ GQueue* q=as_queue_kind(h,kind); if(!q) return 0; GList* l=q->head; for(;l;l=l->next){ UXValue* v=(UXValue*)l->data; if(v->kind==UXV_STR&&g_strcmp0(v->str,s)==0) return 1; } return 0; }
UX_EXPORT int uxc_stack_contains_i64(void* h, int64_t x){ return uxc_queue_kind_contains_i64(h,C_STACK,x); }
UX_EXPORT int uxc_stack_contains_f64(void* h, double x){ return uxc_queue_kind_contains_f64(h,C_STACK,x); }
UX_EXPORT int uxc_stack_contains_str(void* h, const char* s){ return uxc_queue_kind_contains_str(h,C_STACK,s); }
UX_EXPORT int uxc_queue_contains_i64(void* h, int64_t x){ return uxc_queue_kind_contains_i64(h,C_QUEUE,x); }
UX_EXPORT int uxc_queue_contains_f64(void* h, double x){ return uxc_queue_kind_contains_f64(h,C_QUEUE,x); }
UX_EXPORT int uxc_queue_contains_str(void* h, const char* s){ return uxc_queue_kind_contains_str(h,C_QUEUE,s); }
UX_EXPORT int uxc_deque_contains_i64(void* h, int64_t x){ return uxc_queue_kind_contains_i64(h,C_DEQUE,x); }
UX_EXPORT int uxc_deque_contains_f64(void* h, double x){ return uxc_queue_kind_contains_f64(h,C_DEQUE,x); }
UX_EXPORT int uxc_deque_contains_str(void* h, const char* s){ return uxc_queue_kind_contains_str(h,C_DEQUE,s); }

static void* uxc_queue_kind_to_list(void* h, UXCKind kind){ GQueue* q=as_queue_kind(h,kind); GPtrArray* dst=g_ptr_array_new_with_free_func(val_free); if(q){ GList* l=q->head; for(;l;l=l->next) g_ptr_array_add(dst,val_clone((UXValue*)l->data)); } return coll_new(C_LIST,dst); }
UX_EXPORT void* uxc_stack_to_list(void* h){ return uxc_queue_kind_to_list(h,C_STACK); }
UX_EXPORT void* uxc_queue_to_list(void* h){ return uxc_queue_kind_to_list(h,C_QUEUE); }
UX_EXPORT void* uxc_deque_to_list(void* h){ return uxc_queue_kind_to_list(h,C_DEQUE); }

static void uxc_queue_kind_push_range(void* h, UXCKind kind, void* listH, int toFront){ GQueue* q=as_queue_kind(h,kind); GPtrArray* src=as_list(listH); if(!q||!src) return; guint i; for(i=0;i<src->len;i++){ UXValue* copy=val_clone((UXValue*)g_ptr_array_index(src,i)); if(toFront) g_queue_push_head(q,copy); else g_queue_push_tail(q,copy); } }
UX_EXPORT void uxc_stack_push_range(void* h, void* listH){ uxc_queue_kind_push_range(h,C_STACK,listH,1); }
UX_EXPORT void uxc_queue_push_range(void* h, void* listH){ uxc_queue_kind_push_range(h,C_QUEUE,listH,0); }
UX_EXPORT void uxc_deque_push_range_front(void* h, void* listH){ uxc_queue_kind_push_range(h,C_DEQUE,listH,1); }
UX_EXPORT void uxc_deque_push_range_back(void* h, void* listH){ uxc_queue_kind_push_range(h,C_DEQUE,listH,0); }

UX_EXPORT void uxc_deque_rotate(void* h, int64_t n){ GQueue* q=as_queue_kind(h,C_DEQUE); if(!q) return; guint len=g_queue_get_length(q); if(len==0) return; int64_t shift=n%(int64_t)len; if(shift<0) shift+=(int64_t)len; int64_t i; for(i=0;i<shift;i++){ gpointer v=g_queue_pop_tail(q); g_queue_push_head(q,v); } }

// ---------- DICT / SET (insertion-ordered) ----------
UX_EXPORT void* uxc_dict_new(void){ return coll_new(C_DICT,ohash_new(val_free)); }
UX_EXPORT void uxc_dict_free(void* h){ UXCollection* c=as_coll(h,C_DICT); if(c){ ohash_free((UXOrderedHash*)c->obj); g_free(c);} }
UX_EXPORT int64_t uxc_dict_count(void* h){ UXOrderedHash* t=as_ohash(h,C_DICT); return t?g_hash_table_size(t->table):0; }
UX_EXPORT void uxc_dict_set_f64(void* h,const char* k,double x){ UXOrderedHash* t=as_ohash(h,C_DICT); if(t) ohash_set(t,k?k:"",val_new_f64(x)); }
UX_EXPORT void uxc_dict_set_i64(void* h,const char* k,int64_t x){ UXOrderedHash* t=as_ohash(h,C_DICT); if(t) ohash_set(t,k?k:"",val_new_i64(x)); }
UX_EXPORT void uxc_dict_set_str(void* h,const char* k,const char* s){ UXOrderedHash* t=as_ohash(h,C_DICT); if(t) ohash_set(t,k?k:"",val_new_str(s)); }
UX_EXPORT int uxc_dict_has(void* h,const char* k){ UXOrderedHash* t=as_ohash(h,C_DICT); return t?g_hash_table_contains(t->table,k?k:""):0; }
UX_EXPORT int uxc_dict_remove(void* h,const char* k){ UXOrderedHash* t=as_ohash(h,C_DICT); return t?ohash_remove(t,k?k:""):0; }
UX_EXPORT double uxc_dict_get_f64(void* h,const char* k){ UXOrderedHash* t=as_ohash(h,C_DICT); UXValue* v=t?g_hash_table_lookup(t->table,k?k:""):NULL; if(!v) return 0; return v->kind==UXV_F64?v->f64:(double)v->i64; }
UX_EXPORT int64_t uxc_dict_get_i64(void* h,const char* k){ UXOrderedHash* t=as_ohash(h,C_DICT); UXValue* v=t?g_hash_table_lookup(t->table,k?k:""):NULL; if(!v) return 0; return v->kind==UXV_I64?v->i64:(int64_t)v->f64; }
UX_EXPORT const char* uxc_dict_get_str(void* h,const char* k){ UXOrderedHash* t=as_ohash(h,C_DICT); UXValue* v=t?g_hash_table_lookup(t->table,k?k:""):NULL; if(!v||v->kind!=UXV_STR) return ""; return v->str?v->str:""; }
UX_EXPORT int uxc_dict_get_kind(void* h,const char* k){ UXOrderedHash* t=as_ohash(h,C_DICT); UXValue* v=t?g_hash_table_lookup(t->table,k?k:""):NULL; return v?v->kind:UXV_NULL; }
UX_EXPORT const char* uxc_dict_key_at(void* h,int64_t idx){ UXOrderedHash* t=as_ohash(h,C_DICT); const char* k=ohash_key_at(t,idx); return k?k:""; }

// ---------- DICT: extras (Python/C#-inspired) ----------
UX_EXPORT void* uxc_dict_keys_as_list(void* h){ UXOrderedHash* t=as_ohash(h,C_DICT); GPtrArray* dst=g_ptr_array_new_with_free_func(val_free); if(t){ guint i; for(i=0;i<t->orderedKeys->len;i++) g_ptr_array_add(dst,val_new_str((const char*)g_ptr_array_index(t->orderedKeys,i))); } return coll_new(C_LIST,dst); }
UX_EXPORT void* uxc_dict_values_as_list(void* h){ UXOrderedHash* t=as_ohash(h,C_DICT); GPtrArray* dst=g_ptr_array_new_with_free_func(val_free); if(t){ guint i; for(i=0;i<t->orderedKeys->len;i++){ const char* k=(const char*)g_ptr_array_index(t->orderedKeys,i); UXValue* v=(UXValue*)g_hash_table_lookup(t->table,k); if(v) g_ptr_array_add(dst,val_clone(v)); } } return coll_new(C_LIST,dst); }
UX_EXPORT int64_t uxc_dict_get_or_default_i64(void* h,const char* k,int64_t defVal){ UXOrderedHash* t=as_ohash(h,C_DICT); if(!t) return defVal; UXValue* v=g_hash_table_lookup(t->table,k?k:""); if(!v) return defVal; return v->kind==UXV_I64?v->i64:(int64_t)v->f64; }
UX_EXPORT double uxc_dict_get_or_default_f64(void* h,const char* k,double defVal){ UXOrderedHash* t=as_ohash(h,C_DICT); if(!t) return defVal; UXValue* v=g_hash_table_lookup(t->table,k?k:""); if(!v) return defVal; return v->kind==UXV_F64?v->f64:(double)v->i64; }
UX_EXPORT const char* uxc_dict_get_or_default_str(void* h,const char* k,const char* defVal){ UXOrderedHash* t=as_ohash(h,C_DICT); static __declspec(thread) char buf[4096]; buf[0]=0; const char* d=defVal?defVal:""; if(!t){ strncpy(buf,d,sizeof(buf)-1); return buf; } UXValue* v=g_hash_table_lookup(t->table,k?k:""); const char* r=(v&&v->kind==UXV_STR&&v->str)?v->str:d; strncpy(buf,r,sizeof(buf)-1); buf[sizeof(buf)-1]=0; return buf; }
UX_EXPORT int64_t uxc_dict_set_default_i64(void* h,const char* k,int64_t defVal){ UXOrderedHash* t=as_ohash(h,C_DICT); if(!t) return defVal; UXValue* v=g_hash_table_lookup(t->table,k?k:""); if(v) return v->kind==UXV_I64?v->i64:(int64_t)v->f64; ohash_set(t,k?k:"",val_new_i64(defVal)); return defVal; }
UX_EXPORT double uxc_dict_set_default_f64(void* h,const char* k,double defVal){ UXOrderedHash* t=as_ohash(h,C_DICT); if(!t) return defVal; UXValue* v=g_hash_table_lookup(t->table,k?k:""); if(v) return v->kind==UXV_F64?v->f64:(double)v->i64; ohash_set(t,k?k:"",val_new_f64(defVal)); return defVal; }
UX_EXPORT const char* uxc_dict_set_default_str(void* h,const char* k,const char* defVal){ UXOrderedHash* t=as_ohash(h,C_DICT); static __declspec(thread) char buf[4096]; buf[0]=0; const char* d=defVal?defVal:""; if(!t){ strncpy(buf,d,sizeof(buf)-1); return buf; } UXValue* v=g_hash_table_lookup(t->table,k?k:""); if(v&&v->kind==UXV_STR&&v->str){ strncpy(buf,v->str,sizeof(buf)-1); buf[sizeof(buf)-1]=0; return buf; } ohash_set(t,k?k:"",val_new_str(d)); strncpy(buf,d,sizeof(buf)-1); buf[sizeof(buf)-1]=0; return buf; }
UX_EXPORT int64_t uxc_dict_pop_i64(void* h,const char* k){ UXOrderedHash* t=as_ohash(h,C_DICT); if(!t) return 0; UXValue* v=g_hash_table_lookup(t->table,k?k:""); int64_t r=v?(v->kind==UXV_I64?v->i64:(int64_t)v->f64):0; ohash_remove(t,k?k:""); return r; }
UX_EXPORT double uxc_dict_pop_f64(void* h,const char* k){ UXOrderedHash* t=as_ohash(h,C_DICT); if(!t) return 0; UXValue* v=g_hash_table_lookup(t->table,k?k:""); double r=v?(v->kind==UXV_F64?v->f64:(double)v->i64):0; ohash_remove(t,k?k:""); return r; }
UX_EXPORT const char* uxc_dict_pop_str(void* h,const char* k){ UXOrderedHash* t=as_ohash(h,C_DICT); static __declspec(thread) char buf[4096]; buf[0]=0; if(!t) return buf; UXValue* v=g_hash_table_lookup(t->table,k?k:""); if(v&&v->kind==UXV_STR&&v->str){ strncpy(buf,v->str,sizeof(buf)-1); buf[sizeof(buf)-1]=0; } ohash_remove(t,k?k:""); return buf; }
UX_EXPORT const char* uxc_dict_first_key(void* h){ UXOrderedHash* t=as_ohash(h,C_DICT); const char* k=ohash_key_at(t,0); return k?k:""; }
UX_EXPORT const char* uxc_dict_last_key(void* h){ UXOrderedHash* t=as_ohash(h,C_DICT); if(!t||t->orderedKeys->len==0) return ""; const char* k=ohash_key_at(t,(int64_t)t->orderedKeys->len-1); return k?k:""; }
UX_EXPORT int uxc_dict_pop_first(void* h){ UXOrderedHash* t=as_ohash(h,C_DICT); if(!t||t->orderedKeys->len==0) return 0; const char* k=ohash_key_at(t,0); return ohash_remove(t,k); }
UX_EXPORT int uxc_dict_pop_last(void* h){ UXOrderedHash* t=as_ohash(h,C_DICT); if(!t||t->orderedKeys->len==0) return 0; const char* k=ohash_key_at(t,(int64_t)t->orderedKeys->len-1); return ohash_remove(t,k); }
UX_EXPORT int uxc_dict_is_empty(void* h){ return uxc_dict_count(h)==0; }
UX_EXPORT int uxc_dict_contains_value_i64(void* h,int64_t x){ UXOrderedHash* t=as_ohash(h,C_DICT); if(!t) return 0; guint i; for(i=0;i<t->orderedKeys->len;i++){ UXValue* v=(UXValue*)g_hash_table_lookup(t->table,(const char*)g_ptr_array_index(t->orderedKeys,i)); if(v&&v->kind==UXV_I64&&v->i64==x) return 1; } return 0; }
UX_EXPORT int uxc_dict_contains_value_f64(void* h,double x){ UXOrderedHash* t=as_ohash(h,C_DICT); if(!t) return 0; guint i; for(i=0;i<t->orderedKeys->len;i++){ UXValue* v=(UXValue*)g_hash_table_lookup(t->table,(const char*)g_ptr_array_index(t->orderedKeys,i)); if(v&&v->kind==UXV_F64&&v->f64==x) return 1; } return 0; }
UX_EXPORT int uxc_dict_contains_value_str(void* h,const char* s){ UXOrderedHash* t=as_ohash(h,C_DICT); if(!t) return 0; guint i; for(i=0;i<t->orderedKeys->len;i++){ UXValue* v=(UXValue*)g_hash_table_lookup(t->table,(const char*)g_ptr_array_index(t->orderedKeys,i)); if(v&&v->kind==UXV_STR&&g_strcmp0(v->str,s)==0) return 1; } return 0; }
UX_EXPORT void* uxc_dict_clone(void* h){ UXOrderedHash* src=as_ohash(h,C_DICT); void* outH=uxc_dict_new(); UXOrderedHash* dst=as_ohash(outH,C_DICT); if(src){ guint i; for(i=0;i<src->orderedKeys->len;i++){ const char* k=(const char*)g_ptr_array_index(src->orderedKeys,i); UXValue* v=(UXValue*)g_hash_table_lookup(src->table,k); if(v) ohash_set(dst,k,val_clone(v)); } } return outH; }
UX_EXPORT void uxc_dict_update(void* dstH, void* srcH){ UXOrderedHash* dst=as_ohash(dstH,C_DICT); UXOrderedHash* src=as_ohash(srcH,C_DICT); if(!dst||!src) return; guint i; for(i=0;i<src->orderedKeys->len;i++){ const char* k=(const char*)g_ptr_array_index(src->orderedKeys,i); UXValue* v=(UXValue*)g_hash_table_lookup(src->table,k); if(v) ohash_set(dst,k,val_clone(v)); } }
UX_EXPORT void* uxc_dict_merge(void* aH, void* bH){ void* out=uxc_dict_clone(aH); uxc_dict_update(out,bH); return out; }
UX_EXPORT void* uxc_dict_invert(void* h){ UXOrderedHash* src=as_ohash(h,C_DICT); void* outH=uxc_dict_new(); UXOrderedHash* dst=as_ohash(outH,C_DICT); if(src){ guint i; for(i=0;i<src->orderedKeys->len;i++){ const char* k=(const char*)g_ptr_array_index(src->orderedKeys,i); UXValue* v=(UXValue*)g_hash_table_lookup(src->table,k); if(!v) continue; char nb[128]; const char* nk; if(v->kind==UXV_STR&&v->str) nk=v->str; else if(v->kind==UXV_I64){ snprintf(nb,sizeof(nb),"%lld",(long long)v->i64); nk=nb; } else { snprintf(nb,sizeof(nb),"%g",v->f64); nk=nb; } ohash_set(dst,nk,val_new_str(k)); } } return outH; }
UX_EXPORT int uxc_dict_equals(void* aH, void* bH){ UXOrderedHash* a=as_ohash(aH,C_DICT); UXOrderedHash* b=as_ohash(bH,C_DICT); if(!a||!b) return 0; if(g_hash_table_size(a->table)!=g_hash_table_size(b->table)) return 0; guint i; for(i=0;i<a->orderedKeys->len;i++){ const char* k=(const char*)g_ptr_array_index(a->orderedKeys,i); UXValue* va=(UXValue*)g_hash_table_lookup(a->table,k); UXValue* vb=(UXValue*)g_hash_table_lookup(b->table,k); if(!vb||va->kind!=vb->kind) return 0; if(va->kind==UXV_I64&&va->i64!=vb->i64) return 0; if(va->kind==UXV_F64&&va->f64!=vb->f64) return 0; if(va->kind==UXV_STR&&g_strcmp0(va->str,vb->str)!=0) return 0; } return 1; }

UX_EXPORT void* uxc_set_new(void){ return coll_new(C_SET,ohash_new(NULL)); }
UX_EXPORT void uxc_set_free(void* h){ UXCollection* c=as_coll(h,C_SET); if(c){ ohash_free((UXOrderedHash*)c->obj); g_free(c);} }
UX_EXPORT int64_t uxc_set_count(void* h){ UXOrderedHash* t=as_ohash(h,C_SET); return t?g_hash_table_size(t->table):0; }
UX_EXPORT void uxc_set_add(void* h,const char* k){ UXOrderedHash* t=as_ohash(h,C_SET); if(t) ohash_set(t,k?k:"",NULL); }
UX_EXPORT int uxc_set_contains(void* h,const char* k){ UXOrderedHash* t=as_ohash(h,C_SET); return t?g_hash_table_contains(t->table,k?k:""):0; }
UX_EXPORT int uxc_set_remove(void* h,const char* k){ UXOrderedHash* t=as_ohash(h,C_SET); return t?ohash_remove(t,k?k:""):0; }
UX_EXPORT const char* uxc_set_key_at(void* h,int64_t idx){ UXOrderedHash* t=as_ohash(h,C_SET); const char* k=ohash_key_at(t,idx); return k?k:""; }

// ---------- SET: extras (Python/Rust/C#-inspired) ----------
UX_EXPORT void* uxc_set_union(void* aH, void* bH){ UXOrderedHash* a=as_ohash(aH,C_SET); UXOrderedHash* b=as_ohash(bH,C_SET); void* outH=uxc_set_new(); UXOrderedHash* out=as_ohash(outH,C_SET); if(a){ guint i; for(i=0;i<a->orderedKeys->len;i++) ohash_set(out,(const char*)g_ptr_array_index(a->orderedKeys,i),NULL); } if(b){ guint i; for(i=0;i<b->orderedKeys->len;i++) ohash_set(out,(const char*)g_ptr_array_index(b->orderedKeys,i),NULL); } return outH; }
UX_EXPORT void* uxc_set_intersect(void* aH, void* bH){ UXOrderedHash* a=as_ohash(aH,C_SET); UXOrderedHash* b=as_ohash(bH,C_SET); void* outH=uxc_set_new(); UXOrderedHash* out=as_ohash(outH,C_SET); if(a&&b){ guint i; for(i=0;i<a->orderedKeys->len;i++){ const char* k=(const char*)g_ptr_array_index(a->orderedKeys,i); if(g_hash_table_contains(b->table,k)) ohash_set(out,k,NULL); } } return outH; }
UX_EXPORT void* uxc_set_difference(void* aH, void* bH){ UXOrderedHash* a=as_ohash(aH,C_SET); UXOrderedHash* b=as_ohash(bH,C_SET); void* outH=uxc_set_new(); UXOrderedHash* out=as_ohash(outH,C_SET); if(a){ guint i; for(i=0;i<a->orderedKeys->len;i++){ const char* k=(const char*)g_ptr_array_index(a->orderedKeys,i); if(!b||!g_hash_table_contains(b->table,k)) ohash_set(out,k,NULL); } } return outH; }
UX_EXPORT void* uxc_set_symmetric_difference(void* aH, void* bH){ UXOrderedHash* a=as_ohash(aH,C_SET); UXOrderedHash* b=as_ohash(bH,C_SET); void* outH=uxc_set_new(); UXOrderedHash* out=as_ohash(outH,C_SET); if(a){ guint i; for(i=0;i<a->orderedKeys->len;i++){ const char* k=(const char*)g_ptr_array_index(a->orderedKeys,i); if(!b||!g_hash_table_contains(b->table,k)) ohash_set(out,k,NULL); } } if(b){ guint i; for(i=0;i<b->orderedKeys->len;i++){ const char* k=(const char*)g_ptr_array_index(b->orderedKeys,i); if(!a||!g_hash_table_contains(a->table,k)) ohash_set(out,k,NULL); } } return outH; }
UX_EXPORT int uxc_set_is_superset_of(void* aH, void* bH){ UXOrderedHash* a=as_ohash(aH,C_SET); UXOrderedHash* b=as_ohash(bH,C_SET); if(!a||!b) return 0; guint i; for(i=0;i<b->orderedKeys->len;i++){ if(!g_hash_table_contains(a->table,(const char*)g_ptr_array_index(b->orderedKeys,i))) return 0; } return 1; }
UX_EXPORT int uxc_set_is_subset_of(void* aH, void* bH){ return uxc_set_is_superset_of(bH,aH); }
UX_EXPORT int uxc_set_is_disjoint(void* aH, void* bH){ UXOrderedHash* a=as_ohash(aH,C_SET); UXOrderedHash* b=as_ohash(bH,C_SET); if(!a||!b) return 1; guint i; for(i=0;i<a->orderedKeys->len;i++){ if(g_hash_table_contains(b->table,(const char*)g_ptr_array_index(a->orderedKeys,i))) return 0; } return 1; }
UX_EXPORT int uxc_set_equals(void* aH, void* bH){ UXOrderedHash* a=as_ohash(aH,C_SET); UXOrderedHash* b=as_ohash(bH,C_SET); if(!a||!b) return 0; if(g_hash_table_size(a->table)!=g_hash_table_size(b->table)) return 0; return uxc_set_is_superset_of(aH,bH); }
UX_EXPORT int uxc_set_is_empty(void* h){ return uxc_set_count(h)==0; }
UX_EXPORT void* uxc_set_to_list(void* h){ UXOrderedHash* t=as_ohash(h,C_SET); GPtrArray* dst=g_ptr_array_new_with_free_func(val_free); if(t){ guint i; for(i=0;i<t->orderedKeys->len;i++) g_ptr_array_add(dst,val_new_str((const char*)g_ptr_array_index(t->orderedKeys,i))); } return coll_new(C_LIST,dst); }
UX_EXPORT void* uxc_set_clone(void* h){ UXOrderedHash* src=as_ohash(h,C_SET); void* outH=uxc_set_new(); UXOrderedHash* dst=as_ohash(outH,C_SET); if(src){ guint i; for(i=0;i<src->orderedKeys->len;i++) ohash_set(dst,(const char*)g_ptr_array_index(src->orderedKeys,i),NULL); } return outH; }
UX_EXPORT void uxc_set_add_range(void* h, void* listH){ UXOrderedHash* t=as_ohash(h,C_SET); GPtrArray* src=as_list(listH); if(!t||!src) return; guint i; for(i=0;i<src->len;i++){ UXValue* v=(UXValue*)g_ptr_array_index(src,i); const char* s=(v->kind==UXV_STR&&v->str)?v->str:""; ohash_set(t,s,NULL); } }
UX_EXPORT void uxc_set_remove_range(void* h, void* listH){ UXOrderedHash* t=as_ohash(h,C_SET); GPtrArray* src=as_list(listH); if(!t||!src) return; guint i; for(i=0;i<src->len;i++){ UXValue* v=(UXValue*)g_ptr_array_index(src,i); const char* s=(v->kind==UXV_STR&&v->str)?v->str:""; ohash_remove(t,s); } }
UX_EXPORT const char* uxc_set_pop(void* h){ UXOrderedHash* t=as_ohash(h,C_SET); static __declspec(thread) char buf[4096]; buf[0]=0; if(!t||t->orderedKeys->len==0) return buf; const char* k=(const char*)g_ptr_array_index(t->orderedKeys,0); strncpy(buf,k,sizeof(buf)-1); buf[sizeof(buf)-1]=0; ohash_remove(t,buf); return buf; }

// ---------- SORTED TREE ----------
UX_EXPORT void* uxc_tree_new(void){ return coll_new(C_TREE,g_tree_new_full(str_cmp,NULL,g_free,val_free)); }
UX_EXPORT void uxc_tree_free(void* h){ UXCollection* c=as_coll(h,C_TREE); if(c){ g_tree_destroy((GTree*)c->obj); g_free(c);} }
UX_EXPORT int64_t uxc_tree_count(void* h){ GTree* t=as_tree(h); return t?g_tree_nnodes(t):0; }
UX_EXPORT int64_t uxc_tree_height(void* h){ GTree* t=as_tree(h); return t?g_tree_height(t):0; }
UX_EXPORT void uxc_tree_set_f64(void* h,const char* k,double x){ GTree* t=as_tree(h); if(t) g_tree_replace(t,g_strdup(k?k:""),val_new_f64(x)); }
UX_EXPORT void uxc_tree_set_i64(void* h,const char* k,int64_t x){ GTree* t=as_tree(h); if(t) g_tree_replace(t,g_strdup(k?k:""),val_new_i64(x)); }
UX_EXPORT int uxc_tree_has(void* h,const char* k){ GTree* t=as_tree(h); return t && g_tree_lookup(t,k?k:"")?1:0; }
UX_EXPORT double uxc_tree_get_f64(void* h,const char* k){ GTree* t=as_tree(h); UXValue* v=t?g_tree_lookup(t,k?k:""):NULL; if(!v) return 0; return v->kind==UXV_F64?v->f64:(double)v->i64; }
UX_EXPORT int64_t uxc_tree_get_i64(void* h,const char* k){ GTree* t=as_tree(h); UXValue* v=t?g_tree_lookup(t,k?k:""):NULL; if(!v) return 0; return v->kind==UXV_I64?v->i64:(int64_t)v->f64; }
UX_EXPORT void uxc_tree_set_str(void* h,const char* k,const char* s){ GTree* t=as_tree(h); if(t) g_tree_replace(t,g_strdup(k?k:""),val_new_str(s)); }
UX_EXPORT const char* uxc_tree_get_str(void* h,const char* k){ GTree* t=as_tree(h); UXValue* v=t?g_tree_lookup(t,k?k:""):NULL; if(!v||v->kind!=UXV_STR) return ""; return v->str?v->str:""; }
UX_EXPORT int uxc_tree_get_kind(void* h,const char* k){ GTree* t=as_tree(h); UXValue* v=t?g_tree_lookup(t,k?k:""):NULL; return v?v->kind:UXV_NULL; }
UX_EXPORT int uxc_tree_remove(void* h,const char* k){ GTree* t=as_tree(h); return t?g_tree_remove(t,k?k:""):0; }

// ---------- N-ARY NODE TREE ----------
UX_EXPORT void* uxc_node_new_str(const char* s){ GNode* n=g_node_new(val_new_str(s)); return coll_new(C_NODE,n); }
UX_EXPORT void uxc_node_free(void* h){ UXCollection* c=as_coll(h,C_NODE); if(c){ g_node_destroy((GNode*)c->obj); g_free(c);} }
UX_EXPORT void* uxc_node_append_child_str(void* h,const char* s){ UXCollection* c=as_coll(h,C_NODE); if(!c) return NULL; GNode* child=g_node_new(val_new_str(s)); g_node_append((GNode*)c->obj,child); return coll_new(C_NODE,child); }
UX_EXPORT int64_t uxc_node_child_count(void* h){ UXCollection* c=as_coll(h,C_NODE); return c?g_node_n_children((GNode*)c->obj):0; }
UX_EXPORT int64_t uxc_node_depth(void* h){ UXCollection* c=as_coll(h,C_NODE); return c?g_node_depth((GNode*)c->obj):0; }
UX_EXPORT int64_t uxc_node_max_height(void* h){ UXCollection* c=as_coll(h,C_NODE); return c?g_node_max_height((GNode*)c->obj):0; }
UX_EXPORT const char* uxc_node_get_str(void* h){ UXCollection* c=as_coll(h,C_NODE); if(!c) return ""; GNode* n=(GNode*)c->obj; UXValue* v=(UXValue*)n->data; return (v&&v->kind==UXV_STR&&v->str)?v->str:""; }

// ---------- Separate module availability ----------
static int runtime_module_available(const char* module_name){
#if defined(_WIN32)
    HMODULE module = LoadLibraryA(module_name);
    if(!module) return 0;
    FreeLibrary(module);
    return 1;
#else
    (void)module_name;
    return 0;
#endif
}
UX_EXPORT int uxc_graph_backend_available(void){ return runtime_module_available("uxgraph.dll"); }
UX_EXPORT int uxc_dataframe_backend_available(void){ return runtime_module_available("uxdataframe.dll"); }
