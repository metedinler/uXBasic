#ifndef UXCOLLECTIONS_H
#define UXCOLLECTIONS_H
#include <stdint.h>
#ifdef __cplusplus
extern "C" {
#endif
__declspec(dllimport) int uxcollections_version(void);
__declspec(dllimport) int uxcollections_uses_glib(void);

/* LIST */
__declspec(dllimport) void* uxc_list_new(void);
__declspec(dllimport) void uxc_list_free(void*);
__declspec(dllimport) int64_t uxc_list_count(void*);
__declspec(dllimport) void uxc_list_clear(void*);
__declspec(dllimport) void uxc_list_push_i64(void*,int64_t);
__declspec(dllimport) void uxc_list_push_f64(void*,double);
__declspec(dllimport) void uxc_list_push_str(void*,const char*);
__declspec(dllimport) int uxc_list_remove_at(void*,int64_t);
__declspec(dllimport) int64_t uxc_list_get_i64(void*,int64_t);
__declspec(dllimport) double uxc_list_get_f64(void*,int64_t);
__declspec(dllimport) const char* uxc_list_get_str(void*,int64_t);
__declspec(dllimport) int uxc_list_set_i64(void*,int64_t,int64_t);
__declspec(dllimport) int uxc_list_set_f64(void*,int64_t,double);
__declspec(dllimport) int uxc_list_set_str(void*,int64_t,const char*);
__declspec(dllimport) int uxc_list_get_kind(void*,int64_t);

/* LIST: sorting */
__declspec(dllimport) void uxc_list_sort(void*);
__declspec(dllimport) void uxc_list_sort_alpha(void*);
__declspec(dllimport) void uxc_list_reverse(void*);

/* LIST: statistics */
__declspec(dllimport) double uxc_list_sum(void*);
__declspec(dllimport) double uxc_list_average(void*);
__declspec(dllimport) double uxc_list_min(void*);
__declspec(dllimport) double uxc_list_max(void*);
__declspec(dllimport) double uxc_list_range(void*);
__declspec(dllimport) double uxc_list_median(void*);
__declspec(dllimport) double uxc_list_percentile(void*,double);
__declspec(dllimport) double uxc_list_variance(void*);
__declspec(dllimport) double uxc_list_stddev(void*);
__declspec(dllimport) double uxc_list_stderr(void*);
__declspec(dllimport) double uxc_list_mode(void*);

/* LIST: text */
__declspec(dllimport) const char* uxc_list_join(void*,const char*);
__declspec(dllimport) void* uxc_list_split_to_list(const char*,const char*);
__declspec(dllimport) void* uxc_list_to_upper(void*);
__declspec(dllimport) void* uxc_list_to_lower(void*);
__declspec(dllimport) void* uxc_list_capitalize(void*);
__declspec(dllimport) void* uxc_list_trim(void*);
__declspec(dllimport) void* uxc_list_filter_by_prefix(void*,const char*);
__declspec(dllimport) void* uxc_list_filter_by_suffix(void*,const char*);
__declspec(dllimport) void* uxc_list_filter_contains(void*,const char*);

/* LIST: search / structural */
__declspec(dllimport) int64_t uxc_list_index_of_i64(void*,int64_t);
__declspec(dllimport) int64_t uxc_list_index_of_f64(void*,double);
__declspec(dllimport) int64_t uxc_list_index_of_str(void*,const char*);
__declspec(dllimport) int uxc_list_contains_i64(void*,int64_t);
__declspec(dllimport) int uxc_list_contains_f64(void*,double);
__declspec(dllimport) int uxc_list_contains_str(void*,const char*);
__declspec(dllimport) int64_t uxc_list_count_value_i64(void*,int64_t);
__declspec(dllimport) int64_t uxc_list_count_value_f64(void*,double);
__declspec(dllimport) int64_t uxc_list_count_value_str(void*,const char*);
__declspec(dllimport) void* uxc_list_slice(void*,int64_t,int64_t);
__declspec(dllimport) void uxc_list_extend(void*,void*);
__declspec(dllimport) int uxc_list_insert_at_i64(void*,int64_t,int64_t);
__declspec(dllimport) int uxc_list_insert_at_f64(void*,int64_t,double);
__declspec(dllimport) int uxc_list_insert_at_str(void*,int64_t,const char*);
__declspec(dllimport) void* uxc_list_unique(void*);
__declspec(dllimport) void* uxc_list_clone(void*);

/* STACK */
__declspec(dllimport) void* uxc_stack_new(void);
__declspec(dllimport) void uxc_stack_free(void*);
__declspec(dllimport) int64_t uxc_stack_count(void*);
__declspec(dllimport) void uxc_stack_push_i64(void*,int64_t);
__declspec(dllimport) void uxc_stack_push_f64(void*,double);
__declspec(dllimport) void uxc_stack_push_str(void*,const char*);
__declspec(dllimport) int64_t uxc_stack_pop_i64(void*);
__declspec(dllimport) double uxc_stack_pop_f64(void*);
__declspec(dllimport) const char* uxc_stack_pop_str(void*);
__declspec(dllimport) int uxc_stack_peek_kind(void*);
__declspec(dllimport) int64_t uxc_stack_peek_i64(void*);
__declspec(dllimport) double uxc_stack_peek_f64(void*);
__declspec(dllimport) const char* uxc_stack_peek_str(void*);
__declspec(dllimport) int uxc_stack_is_empty(void*);
__declspec(dllimport) void uxc_stack_clear(void*);
__declspec(dllimport) void* uxc_stack_clone(void*);
__declspec(dllimport) int uxc_stack_contains_i64(void*,int64_t);
__declspec(dllimport) int uxc_stack_contains_f64(void*,double);
__declspec(dllimport) int uxc_stack_contains_str(void*,const char*);
__declspec(dllimport) void* uxc_stack_to_list(void*);
__declspec(dllimport) void uxc_stack_push_range(void*,void*);

/* QUEUE */
__declspec(dllimport) void* uxc_queue_new(void);
__declspec(dllimport) void uxc_queue_free(void*);
__declspec(dllimport) int64_t uxc_queue_count(void*);
__declspec(dllimport) void uxc_queue_push_i64(void*,int64_t);
__declspec(dllimport) void uxc_queue_push_f64(void*,double);
__declspec(dllimport) void uxc_queue_push_str(void*,const char*);
__declspec(dllimport) int64_t uxc_queue_pop_i64(void*);
__declspec(dllimport) double uxc_queue_pop_f64(void*);
__declspec(dllimport) const char* uxc_queue_pop_str(void*);
__declspec(dllimport) int uxc_queue_peek_kind(void*);
__declspec(dllimport) int64_t uxc_queue_peek_i64(void*);
__declspec(dllimport) double uxc_queue_peek_f64(void*);
__declspec(dllimport) const char* uxc_queue_peek_str(void*);
__declspec(dllimport) int uxc_queue_is_empty(void*);
__declspec(dllimport) void uxc_queue_clear(void*);
__declspec(dllimport) void* uxc_queue_clone(void*);
__declspec(dllimport) int uxc_queue_contains_i64(void*,int64_t);
__declspec(dllimport) int uxc_queue_contains_f64(void*,double);
__declspec(dllimport) int uxc_queue_contains_str(void*,const char*);
__declspec(dllimport) void* uxc_queue_to_list(void*);
__declspec(dllimport) void uxc_queue_push_range(void*,void*);

/* DEQUE */
__declspec(dllimport) void* uxc_deque_new(void);
__declspec(dllimport) void uxc_deque_free(void*);
__declspec(dllimport) int64_t uxc_deque_count(void*);
__declspec(dllimport) void uxc_deque_push_front_i64(void*,int64_t);
__declspec(dllimport) void uxc_deque_push_back_i64(void*,int64_t);
__declspec(dllimport) void uxc_deque_push_front_f64(void*,double);
__declspec(dllimport) void uxc_deque_push_back_f64(void*,double);
__declspec(dllimport) void uxc_deque_push_front_str(void*,const char*);
__declspec(dllimport) void uxc_deque_push_back_str(void*,const char*);
__declspec(dllimport) int64_t uxc_deque_pop_front_i64(void*);
__declspec(dllimport) int64_t uxc_deque_pop_back_i64(void*);
__declspec(dllimport) double uxc_deque_pop_front_f64(void*);
__declspec(dllimport) double uxc_deque_pop_back_f64(void*);
__declspec(dllimport) const char* uxc_deque_pop_front_str(void*);
__declspec(dllimport) const char* uxc_deque_pop_back_str(void*);
__declspec(dllimport) int uxc_deque_peek_front_kind(void*);
__declspec(dllimport) int uxc_deque_peek_back_kind(void*);
__declspec(dllimport) int64_t uxc_deque_peek_front_i64(void*);
__declspec(dllimport) double uxc_deque_peek_front_f64(void*);
__declspec(dllimport) const char* uxc_deque_peek_front_str(void*);
__declspec(dllimport) int64_t uxc_deque_peek_back_i64(void*);
__declspec(dllimport) double uxc_deque_peek_back_f64(void*);
__declspec(dllimport) const char* uxc_deque_peek_back_str(void*);
__declspec(dllimport) int uxc_deque_is_empty(void*);
__declspec(dllimport) void uxc_deque_clear(void*);
__declspec(dllimport) void* uxc_deque_clone(void*);
__declspec(dllimport) int uxc_deque_contains_i64(void*,int64_t);
__declspec(dllimport) int uxc_deque_contains_f64(void*,double);
__declspec(dllimport) int uxc_deque_contains_str(void*,const char*);
__declspec(dllimport) void* uxc_deque_to_list(void*);
__declspec(dllimport) void uxc_deque_push_range_front(void*,void*);
__declspec(dllimport) void uxc_deque_push_range_back(void*,void*);
__declspec(dllimport) void uxc_deque_rotate(void*,int64_t);

/* DICT (insertion-ordered) */
__declspec(dllimport) void* uxc_dict_new(void);
__declspec(dllimport) void uxc_dict_free(void*);
__declspec(dllimport) int64_t uxc_dict_count(void*);
__declspec(dllimport) void uxc_dict_set_i64(void*,const char*,int64_t);
__declspec(dllimport) void uxc_dict_set_f64(void*,const char*,double);
__declspec(dllimport) void uxc_dict_set_str(void*,const char*,const char*);
__declspec(dllimport) int uxc_dict_has(void*,const char*);
__declspec(dllimport) int uxc_dict_remove(void*,const char*);
__declspec(dllimport) int64_t uxc_dict_get_i64(void*,const char*);
__declspec(dllimport) double uxc_dict_get_f64(void*,const char*);
__declspec(dllimport) const char* uxc_dict_get_str(void*,const char*);
__declspec(dllimport) int uxc_dict_get_kind(void*,const char*);
__declspec(dllimport) const char* uxc_dict_key_at(void*,int64_t);
__declspec(dllimport) void* uxc_dict_keys_as_list(void*);
__declspec(dllimport) void* uxc_dict_values_as_list(void*);
__declspec(dllimport) int64_t uxc_dict_get_or_default_i64(void*,const char*,int64_t);
__declspec(dllimport) double uxc_dict_get_or_default_f64(void*,const char*,double);
__declspec(dllimport) const char* uxc_dict_get_or_default_str(void*,const char*,const char*);
__declspec(dllimport) int64_t uxc_dict_set_default_i64(void*,const char*,int64_t);
__declspec(dllimport) double uxc_dict_set_default_f64(void*,const char*,double);
__declspec(dllimport) const char* uxc_dict_set_default_str(void*,const char*,const char*);
__declspec(dllimport) int64_t uxc_dict_pop_i64(void*,const char*);
__declspec(dllimport) double uxc_dict_pop_f64(void*,const char*);
__declspec(dllimport) const char* uxc_dict_pop_str(void*,const char*);
__declspec(dllimport) const char* uxc_dict_first_key(void*);
__declspec(dllimport) const char* uxc_dict_last_key(void*);
__declspec(dllimport) int uxc_dict_pop_first(void*);
__declspec(dllimport) int uxc_dict_pop_last(void*);
__declspec(dllimport) int uxc_dict_is_empty(void*);
__declspec(dllimport) int uxc_dict_contains_value_i64(void*,int64_t);
__declspec(dllimport) int uxc_dict_contains_value_f64(void*,double);
__declspec(dllimport) int uxc_dict_contains_value_str(void*,const char*);
__declspec(dllimport) void* uxc_dict_clone(void*);
__declspec(dllimport) void uxc_dict_update(void*,void*);
__declspec(dllimport) void* uxc_dict_merge(void*,void*);
__declspec(dllimport) void* uxc_dict_invert(void*);
__declspec(dllimport) int uxc_dict_equals(void*,void*);

/* SET (insertion-ordered) */
__declspec(dllimport) void* uxc_set_new(void);
__declspec(dllimport) void uxc_set_free(void*);
__declspec(dllimport) int64_t uxc_set_count(void*);
__declspec(dllimport) void uxc_set_add(void*,const char*);
__declspec(dllimport) int uxc_set_contains(void*,const char*);
__declspec(dllimport) int uxc_set_remove(void*,const char*);
__declspec(dllimport) const char* uxc_set_key_at(void*,int64_t);
__declspec(dllimport) void* uxc_set_union(void*,void*);
__declspec(dllimport) void* uxc_set_intersect(void*,void*);
__declspec(dllimport) void* uxc_set_difference(void*,void*);
__declspec(dllimport) void* uxc_set_symmetric_difference(void*,void*);
__declspec(dllimport) int uxc_set_is_superset_of(void*,void*);
__declspec(dllimport) int uxc_set_is_subset_of(void*,void*);
__declspec(dllimport) int uxc_set_is_disjoint(void*,void*);
__declspec(dllimport) int uxc_set_equals(void*,void*);
__declspec(dllimport) int uxc_set_is_empty(void*);
__declspec(dllimport) void* uxc_set_to_list(void*);
__declspec(dllimport) void* uxc_set_clone(void*);
__declspec(dllimport) void uxc_set_add_range(void*,void*);
__declspec(dllimport) void uxc_set_remove_range(void*,void*);
__declspec(dllimport) const char* uxc_set_pop(void*);

/* SORTED TREE */
__declspec(dllimport) void* uxc_tree_new(void);
__declspec(dllimport) void uxc_tree_free(void*);
__declspec(dllimport) int64_t uxc_tree_count(void*);
__declspec(dllimport) int64_t uxc_tree_height(void*);
__declspec(dllimport) void uxc_tree_set_i64(void*,const char*,int64_t);
__declspec(dllimport) void uxc_tree_set_f64(void*,const char*,double);
__declspec(dllimport) void uxc_tree_set_str(void*,const char*,const char*);
__declspec(dllimport) int uxc_tree_has(void*,const char*);
__declspec(dllimport) int64_t uxc_tree_get_i64(void*,const char*);
__declspec(dllimport) double uxc_tree_get_f64(void*,const char*);
__declspec(dllimport) const char* uxc_tree_get_str(void*,const char*);
__declspec(dllimport) int uxc_tree_get_kind(void*,const char*);
__declspec(dllimport) int uxc_tree_remove(void*,const char*);

/* N-ARY NODE TREE */
__declspec(dllimport) void* uxc_node_new_str(const char*);
__declspec(dllimport) void uxc_node_free(void*);
__declspec(dllimport) void* uxc_node_append_child_str(void*,const char*);
__declspec(dllimport) int64_t uxc_node_child_count(void*);
__declspec(dllimport) int64_t uxc_node_depth(void*);
__declspec(dllimport) int64_t uxc_node_max_height(void*);
__declspec(dllimport) const char* uxc_node_get_str(void*);

/* Separate module availability */
__declspec(dllimport) int uxc_graph_backend_available(void);
__declspec(dllimport) int uxc_dataframe_backend_available(void);
#ifdef __cplusplus
}
#endif
#endif
