' uXBasic uxcollections.bas - INCLUDE wrapper for GLib-backed uxcollections.dll
' Uses existing INCLUDE + CALL(DLL) mechanism. No new uXBasic keyword.

NAMESPACE uxcollections

CONST UXCOLLECTIONS_DLL = "uxcollections.dll"

FUNCTION Version() AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxcollections_version", I32, CDECL)
END FUNCTION

' ---- LIST ----
FUNCTION ListNew() AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_new", PTR, CDECL)
END FUNCTION
SUB ListFree(h AS U64)
    CALL(DLL, "uxcollections.dll", "uxc_list_free", VOID, CDECL, "PTR", h)
END SUB
FUNCTION ListCount(h AS U64) AS I64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_count", I64, CDECL, "PTR", h)
END FUNCTION
SUB ListClear(h AS U64)
    CALL(DLL, "uxcollections.dll", "uxc_list_clear", VOID, CDECL, "PTR", h)
END SUB
SUB ListPushI64(h AS U64, x AS I64)
    CALL(DLL, "uxcollections.dll", "uxc_list_push_i64", VOID, CDECL, "PTR,I64", h, x)
END SUB
SUB ListPushF64(h AS U64, x AS F64)
    CALL(DLL, "uxcollections.dll", "uxc_list_push_f64", VOID, CDECL, "PTR,F64", h, x)
END SUB
SUB ListPushStr(h AS U64, s AS STRING)
    CALL(DLL, "uxcollections.dll", "uxc_list_push_str", VOID, CDECL, "PTR,STRPTR", h, s)
END SUB
FUNCTION ListRemoveAt(h AS U64, idx AS I64) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_remove_at", I32, CDECL, "PTR,I64", h, idx)
END FUNCTION
FUNCTION ListGetI64(h AS U64, idx AS I64) AS I64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_get_i64", I64, CDECL, "PTR,I64", h, idx)
END FUNCTION
FUNCTION ListGetF64(h AS U64, idx AS I64) AS F64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_get_f64", F64, CDECL, "PTR,I64", h, idx)
END FUNCTION
FUNCTION ListGetStr(h AS U64, idx AS I64) AS STRING
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_get_str", STRPTR, CDECL, "PTR,I64", h, idx)
END FUNCTION
FUNCTION ListSetI64(h AS U64, idx AS I64, x AS I64) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_set_i64", I32, CDECL, "PTR,I64,I64", h, idx, x)
END FUNCTION
FUNCTION ListSetF64(h AS U64, idx AS I64, x AS F64) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_set_f64", I32, CDECL, "PTR,I64,F64", h, idx, x)
END FUNCTION
FUNCTION ListSetStr(h AS U64, idx AS I64, s AS STRING) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_set_str", I32, CDECL, "PTR,I64,STRPTR", h, idx, s)
END FUNCTION
' Kind tags: 0=NULL 1=I64 2=F64 3=STR 4=PTR (matches uxcollections_glib.c's UXVKind)
FUNCTION ListGetKind(h AS U64, idx AS I64) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_get_kind", I32, CDECL, "PTR,I64", h, idx)
END FUNCTION

' ---- LIST: sorting ----
SUB ListSort(h AS U64)
    CALL(DLL, "uxcollections.dll", "uxc_list_sort", VOID, CDECL, "PTR", h)
END SUB
SUB ListSortAlpha(h AS U64)
    CALL(DLL, "uxcollections.dll", "uxc_list_sort_alpha", VOID, CDECL, "PTR", h)
END SUB
SUB ListReverse(h AS U64)
    CALL(DLL, "uxcollections.dll", "uxc_list_reverse", VOID, CDECL, "PTR", h)
END SUB

' ---- LIST: statistics ----
FUNCTION ListSum(h AS U64) AS F64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_sum", F64, CDECL, "PTR", h)
END FUNCTION
FUNCTION ListAverage(h AS U64) AS F64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_average", F64, CDECL, "PTR", h)
END FUNCTION
FUNCTION ListMin(h AS U64) AS F64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_min", F64, CDECL, "PTR", h)
END FUNCTION
FUNCTION ListMax(h AS U64) AS F64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_max", F64, CDECL, "PTR", h)
END FUNCTION
FUNCTION ListRange(h AS U64) AS F64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_range", F64, CDECL, "PTR", h)
END FUNCTION
FUNCTION ListMedian(h AS U64) AS F64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_median", F64, CDECL, "PTR", h)
END FUNCTION
FUNCTION ListPercentile(h AS U64, p AS F64) AS F64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_percentile", F64, CDECL, "PTR,F64", h, p)
END FUNCTION
FUNCTION ListVariance(h AS U64) AS F64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_variance", F64, CDECL, "PTR", h)
END FUNCTION
FUNCTION ListStdDev(h AS U64) AS F64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_stddev", F64, CDECL, "PTR", h)
END FUNCTION
FUNCTION ListStdErr(h AS U64) AS F64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_stderr", F64, CDECL, "PTR", h)
END FUNCTION
FUNCTION ListMode(h AS U64) AS F64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_mode", F64, CDECL, "PTR", h)
END FUNCTION

' ---- LIST: text ----
FUNCTION ListJoin(h AS U64, sep AS STRING) AS STRING
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_join", STRPTR, CDECL, "PTR,STRPTR", h, sep)
END FUNCTION
FUNCTION ListSplitToList(text AS STRING, sep AS STRING) AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_split_to_list", PTR, CDECL, "STRPTR,STRPTR", text, sep)
END FUNCTION
FUNCTION ListToUpper(h AS U64) AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_to_upper", PTR, CDECL, "PTR", h)
END FUNCTION
FUNCTION ListToLower(h AS U64) AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_to_lower", PTR, CDECL, "PTR", h)
END FUNCTION
FUNCTION ListCapitalize(h AS U64) AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_capitalize", PTR, CDECL, "PTR", h)
END FUNCTION
FUNCTION ListTrim(h AS U64) AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_trim", PTR, CDECL, "PTR", h)
END FUNCTION
FUNCTION ListFilterByPrefix(h AS U64, prefix AS STRING) AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_filter_by_prefix", PTR, CDECL, "PTR,STRPTR", h, prefix)
END FUNCTION
FUNCTION ListFilterBySuffix(h AS U64, suffix AS STRING) AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_filter_by_suffix", PTR, CDECL, "PTR,STRPTR", h, suffix)
END FUNCTION
FUNCTION ListFilterContains(h AS U64, needle AS STRING) AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_filter_contains", PTR, CDECL, "PTR,STRPTR", h, needle)
END FUNCTION

' ---- LIST: search / structural ----
FUNCTION ListIndexOfI64(h AS U64, x AS I64) AS I64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_index_of_i64", I64, CDECL, "PTR,I64", h, x)
END FUNCTION
FUNCTION ListIndexOfF64(h AS U64, x AS F64) AS I64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_index_of_f64", I64, CDECL, "PTR,F64", h, x)
END FUNCTION
FUNCTION ListIndexOfStr(h AS U64, s AS STRING) AS I64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_index_of_str", I64, CDECL, "PTR,STRPTR", h, s)
END FUNCTION
FUNCTION ListContainsI64(h AS U64, x AS I64) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_contains_i64", I32, CDECL, "PTR,I64", h, x)
END FUNCTION
FUNCTION ListContainsF64(h AS U64, x AS F64) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_contains_f64", I32, CDECL, "PTR,F64", h, x)
END FUNCTION
FUNCTION ListContainsStr(h AS U64, s AS STRING) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_contains_str", I32, CDECL, "PTR,STRPTR", h, s)
END FUNCTION
FUNCTION ListCountValueI64(h AS U64, x AS I64) AS I64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_count_value_i64", I64, CDECL, "PTR,I64", h, x)
END FUNCTION
FUNCTION ListCountValueF64(h AS U64, x AS F64) AS I64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_count_value_f64", I64, CDECL, "PTR,F64", h, x)
END FUNCTION
FUNCTION ListCountValueStr(h AS U64, s AS STRING) AS I64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_count_value_str", I64, CDECL, "PTR,STRPTR", h, s)
END FUNCTION
FUNCTION ListSlice(h AS U64, startIdx AS I64, endIdx AS I64) AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_slice", PTR, CDECL, "PTR,I64,I64", h, startIdx, endIdx)
END FUNCTION
SUB ListExtend(dstH AS U64, srcH AS U64)
    CALL(DLL, "uxcollections.dll", "uxc_list_extend", VOID, CDECL, "PTR,PTR", dstH, srcH)
END SUB
FUNCTION ListInsertAtI64(h AS U64, idx AS I64, x AS I64) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_insert_at_i64", I32, CDECL, "PTR,I64,I64", h, idx, x)
END FUNCTION
FUNCTION ListInsertAtF64(h AS U64, idx AS I64, x AS F64) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_insert_at_f64", I32, CDECL, "PTR,I64,F64", h, idx, x)
END FUNCTION
FUNCTION ListInsertAtStr(h AS U64, idx AS I64, s AS STRING) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_insert_at_str", I32, CDECL, "PTR,I64,STRPTR", h, idx, s)
END FUNCTION
FUNCTION ListUnique(h AS U64) AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_unique", PTR, CDECL, "PTR", h)
END FUNCTION
FUNCTION ListClone(h AS U64) AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_list_clone", PTR, CDECL, "PTR", h)
END FUNCTION

' ---- STACK ----
FUNCTION StackNew() AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_stack_new", PTR, CDECL)
END FUNCTION
SUB StackFree(h AS U64)
    CALL(DLL, "uxcollections.dll", "uxc_stack_free", VOID, CDECL, "PTR", h)
END SUB
FUNCTION StackCount(h AS U64) AS I64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_stack_count", I64, CDECL, "PTR", h)
END FUNCTION
SUB StackPushI64(h AS U64, x AS I64)
    CALL(DLL, "uxcollections.dll", "uxc_stack_push_i64", VOID, CDECL, "PTR,I64", h, x)
END SUB
SUB StackPushF64(h AS U64, x AS F64)
    CALL(DLL, "uxcollections.dll", "uxc_stack_push_f64", VOID, CDECL, "PTR,F64", h, x)
END SUB
SUB StackPushStr(h AS U64, s AS STRING)
    CALL(DLL, "uxcollections.dll", "uxc_stack_push_str", VOID, CDECL, "PTR,STRPTR", h, s)
END SUB
FUNCTION StackPopI64(h AS U64) AS I64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_stack_pop_i64", I64, CDECL, "PTR", h)
END FUNCTION
FUNCTION StackPopF64(h AS U64) AS F64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_stack_pop_f64", F64, CDECL, "PTR", h)
END FUNCTION
FUNCTION StackPopStr(h AS U64) AS STRING
    RETURN CALL(DLL, "uxcollections.dll", "uxc_stack_pop_str", STRPTR, CDECL, "PTR", h)
END FUNCTION
FUNCTION StackPeekKind(h AS U64) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_stack_peek_kind", I32, CDECL, "PTR", h)
END FUNCTION
FUNCTION StackPeekI64(h AS U64) AS I64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_stack_peek_i64", I64, CDECL, "PTR", h)
END FUNCTION
FUNCTION StackPeekF64(h AS U64) AS F64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_stack_peek_f64", F64, CDECL, "PTR", h)
END FUNCTION
FUNCTION StackPeekStr(h AS U64) AS STRING
    RETURN CALL(DLL, "uxcollections.dll", "uxc_stack_peek_str", STRPTR, CDECL, "PTR", h)
END FUNCTION
FUNCTION StackIsEmpty(h AS U64) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_stack_is_empty", I32, CDECL, "PTR", h)
END FUNCTION
SUB StackClear(h AS U64)
    CALL(DLL, "uxcollections.dll", "uxc_stack_clear", VOID, CDECL, "PTR", h)
END SUB
FUNCTION StackClone(h AS U64) AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_stack_clone", PTR, CDECL, "PTR", h)
END FUNCTION
FUNCTION StackContainsI64(h AS U64, x AS I64) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_stack_contains_i64", I32, CDECL, "PTR,I64", h, x)
END FUNCTION
FUNCTION StackContainsF64(h AS U64, x AS F64) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_stack_contains_f64", I32, CDECL, "PTR,F64", h, x)
END FUNCTION
FUNCTION StackContainsStr(h AS U64, s AS STRING) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_stack_contains_str", I32, CDECL, "PTR,STRPTR", h, s)
END FUNCTION
FUNCTION StackToList(h AS U64) AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_stack_to_list", PTR, CDECL, "PTR", h)
END FUNCTION
SUB StackPushRange(h AS U64, listH AS U64)
    CALL(DLL, "uxcollections.dll", "uxc_stack_push_range", VOID, CDECL, "PTR,PTR", h, listH)
END SUB

' ---- QUEUE ----
FUNCTION QueueNew() AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_queue_new", PTR, CDECL)
END FUNCTION
SUB QueueFree(h AS U64)
    CALL(DLL, "uxcollections.dll", "uxc_queue_free", VOID, CDECL, "PTR", h)
END SUB
FUNCTION QueueCount(h AS U64) AS I64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_queue_count", I64, CDECL, "PTR", h)
END FUNCTION
SUB QueuePushI64(h AS U64, x AS I64)
    CALL(DLL, "uxcollections.dll", "uxc_queue_push_i64", VOID, CDECL, "PTR,I64", h, x)
END SUB
SUB QueuePushF64(h AS U64, x AS F64)
    CALL(DLL, "uxcollections.dll", "uxc_queue_push_f64", VOID, CDECL, "PTR,F64", h, x)
END SUB
SUB QueuePushStr(h AS U64, s AS STRING)
    CALL(DLL, "uxcollections.dll", "uxc_queue_push_str", VOID, CDECL, "PTR,STRPTR", h, s)
END SUB
FUNCTION QueuePopI64(h AS U64) AS I64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_queue_pop_i64", I64, CDECL, "PTR", h)
END FUNCTION
FUNCTION QueuePopF64(h AS U64) AS F64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_queue_pop_f64", F64, CDECL, "PTR", h)
END FUNCTION
FUNCTION QueuePopStr(h AS U64) AS STRING
    RETURN CALL(DLL, "uxcollections.dll", "uxc_queue_pop_str", STRPTR, CDECL, "PTR", h)
END FUNCTION
FUNCTION QueuePeekKind(h AS U64) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_queue_peek_kind", I32, CDECL, "PTR", h)
END FUNCTION
FUNCTION QueuePeekI64(h AS U64) AS I64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_queue_peek_i64", I64, CDECL, "PTR", h)
END FUNCTION
FUNCTION QueuePeekF64(h AS U64) AS F64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_queue_peek_f64", F64, CDECL, "PTR", h)
END FUNCTION
FUNCTION QueuePeekStr(h AS U64) AS STRING
    RETURN CALL(DLL, "uxcollections.dll", "uxc_queue_peek_str", STRPTR, CDECL, "PTR", h)
END FUNCTION
FUNCTION QueueIsEmpty(h AS U64) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_queue_is_empty", I32, CDECL, "PTR", h)
END FUNCTION
SUB QueueClear(h AS U64)
    CALL(DLL, "uxcollections.dll", "uxc_queue_clear", VOID, CDECL, "PTR", h)
END SUB
FUNCTION QueueClone(h AS U64) AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_queue_clone", PTR, CDECL, "PTR", h)
END FUNCTION
FUNCTION QueueContainsI64(h AS U64, x AS I64) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_queue_contains_i64", I32, CDECL, "PTR,I64", h, x)
END FUNCTION
FUNCTION QueueContainsF64(h AS U64, x AS F64) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_queue_contains_f64", I32, CDECL, "PTR,F64", h, x)
END FUNCTION
FUNCTION QueueContainsStr(h AS U64, s AS STRING) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_queue_contains_str", I32, CDECL, "PTR,STRPTR", h, s)
END FUNCTION
FUNCTION QueueToList(h AS U64) AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_queue_to_list", PTR, CDECL, "PTR", h)
END FUNCTION
SUB QueuePushRange(h AS U64, listH AS U64)
    CALL(DLL, "uxcollections.dll", "uxc_queue_push_range", VOID, CDECL, "PTR,PTR", h, listH)
END SUB

' ---- DEQUE ----
FUNCTION DequeNew() AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_deque_new", PTR, CDECL)
END FUNCTION
SUB DequeFree(h AS U64)
    CALL(DLL, "uxcollections.dll", "uxc_deque_free", VOID, CDECL, "PTR", h)
END SUB
FUNCTION DequeCount(h AS U64) AS I64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_deque_count", I64, CDECL, "PTR", h)
END FUNCTION
SUB DequePushFrontI64(h AS U64, x AS I64)
    CALL(DLL, "uxcollections.dll", "uxc_deque_push_front_i64", VOID, CDECL, "PTR,I64", h, x)
END SUB
SUB DequePushBackI64(h AS U64, x AS I64)
    CALL(DLL, "uxcollections.dll", "uxc_deque_push_back_i64", VOID, CDECL, "PTR,I64", h, x)
END SUB
SUB DequePushFrontF64(h AS U64, x AS F64)
    CALL(DLL, "uxcollections.dll", "uxc_deque_push_front_f64", VOID, CDECL, "PTR,F64", h, x)
END SUB
SUB DequePushBackF64(h AS U64, x AS F64)
    CALL(DLL, "uxcollections.dll", "uxc_deque_push_back_f64", VOID, CDECL, "PTR,F64", h, x)
END SUB
SUB DequePushFrontStr(h AS U64, s AS STRING)
    CALL(DLL, "uxcollections.dll", "uxc_deque_push_front_str", VOID, CDECL, "PTR,STRPTR", h, s)
END SUB
SUB DequePushBackStr(h AS U64, s AS STRING)
    CALL(DLL, "uxcollections.dll", "uxc_deque_push_back_str", VOID, CDECL, "PTR,STRPTR", h, s)
END SUB
FUNCTION DequePopFrontI64(h AS U64) AS I64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_deque_pop_front_i64", I64, CDECL, "PTR", h)
END FUNCTION
FUNCTION DequePopBackI64(h AS U64) AS I64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_deque_pop_back_i64", I64, CDECL, "PTR", h)
END FUNCTION
FUNCTION DequePopFrontF64(h AS U64) AS F64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_deque_pop_front_f64", F64, CDECL, "PTR", h)
END FUNCTION
FUNCTION DequePopBackF64(h AS U64) AS F64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_deque_pop_back_f64", F64, CDECL, "PTR", h)
END FUNCTION
FUNCTION DequePopFrontStr(h AS U64) AS STRING
    RETURN CALL(DLL, "uxcollections.dll", "uxc_deque_pop_front_str", STRPTR, CDECL, "PTR", h)
END FUNCTION
FUNCTION DequePopBackStr(h AS U64) AS STRING
    RETURN CALL(DLL, "uxcollections.dll", "uxc_deque_pop_back_str", STRPTR, CDECL, "PTR", h)
END FUNCTION
FUNCTION DequePeekFrontKind(h AS U64) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_deque_peek_front_kind", I32, CDECL, "PTR", h)
END FUNCTION
FUNCTION DequePeekBackKind(h AS U64) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_deque_peek_back_kind", I32, CDECL, "PTR", h)
END FUNCTION
FUNCTION DequePeekFrontI64(h AS U64) AS I64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_deque_peek_front_i64", I64, CDECL, "PTR", h)
END FUNCTION
FUNCTION DequePeekFrontF64(h AS U64) AS F64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_deque_peek_front_f64", F64, CDECL, "PTR", h)
END FUNCTION
FUNCTION DequePeekFrontStr(h AS U64) AS STRING
    RETURN CALL(DLL, "uxcollections.dll", "uxc_deque_peek_front_str", STRPTR, CDECL, "PTR", h)
END FUNCTION
FUNCTION DequePeekBackI64(h AS U64) AS I64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_deque_peek_back_i64", I64, CDECL, "PTR", h)
END FUNCTION
FUNCTION DequePeekBackF64(h AS U64) AS F64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_deque_peek_back_f64", F64, CDECL, "PTR", h)
END FUNCTION
FUNCTION DequePeekBackStr(h AS U64) AS STRING
    RETURN CALL(DLL, "uxcollections.dll", "uxc_deque_peek_back_str", STRPTR, CDECL, "PTR", h)
END FUNCTION
FUNCTION DequeIsEmpty(h AS U64) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_deque_is_empty", I32, CDECL, "PTR", h)
END FUNCTION
SUB DequeClear(h AS U64)
    CALL(DLL, "uxcollections.dll", "uxc_deque_clear", VOID, CDECL, "PTR", h)
END SUB
FUNCTION DequeClone(h AS U64) AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_deque_clone", PTR, CDECL, "PTR", h)
END FUNCTION
FUNCTION DequeContainsI64(h AS U64, x AS I64) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_deque_contains_i64", I32, CDECL, "PTR,I64", h, x)
END FUNCTION
FUNCTION DequeContainsF64(h AS U64, x AS F64) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_deque_contains_f64", I32, CDECL, "PTR,F64", h, x)
END FUNCTION
FUNCTION DequeContainsStr(h AS U64, s AS STRING) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_deque_contains_str", I32, CDECL, "PTR,STRPTR", h, s)
END FUNCTION
FUNCTION DequeToList(h AS U64) AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_deque_to_list", PTR, CDECL, "PTR", h)
END FUNCTION
SUB DequePushRangeFront(h AS U64, listH AS U64)
    CALL(DLL, "uxcollections.dll", "uxc_deque_push_range_front", VOID, CDECL, "PTR,PTR", h, listH)
END SUB
SUB DequePushRangeBack(h AS U64, listH AS U64)
    CALL(DLL, "uxcollections.dll", "uxc_deque_push_range_back", VOID, CDECL, "PTR,PTR", h, listH)
END SUB
SUB DequeRotate(h AS U64, n AS I64)
    CALL(DLL, "uxcollections.dll", "uxc_deque_rotate", VOID, CDECL, "PTR,I64", h, n)
END SUB

' ---- DICT (insertion-ordered) ----
FUNCTION DictNew() AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_dict_new", PTR, CDECL)
END FUNCTION
SUB DictFree(h AS U64)
    CALL(DLL, "uxcollections.dll", "uxc_dict_free", VOID, CDECL, "PTR", h)
END SUB
FUNCTION DictCount(h AS U64) AS I64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_dict_count", I64, CDECL, "PTR", h)
END FUNCTION
SUB DictSetI64(h AS U64, key AS STRING, x AS I64)
    CALL(DLL, "uxcollections.dll", "uxc_dict_set_i64", VOID, CDECL, "PTR,STRPTR,I64", h, key, x)
END SUB
SUB DictSetF64(h AS U64, key AS STRING, x AS F64)
    CALL(DLL, "uxcollections.dll", "uxc_dict_set_f64", VOID, CDECL, "PTR,STRPTR,F64", h, key, x)
END SUB
SUB DictSetStr(h AS U64, key AS STRING, s AS STRING)
    CALL(DLL, "uxcollections.dll", "uxc_dict_set_str", VOID, CDECL, "PTR,STRPTR,STRPTR", h, key, s)
END SUB
FUNCTION DictHas(h AS U64, key AS STRING) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_dict_has", I32, CDECL, "PTR,STRPTR", h, key)
END FUNCTION
FUNCTION DictRemove(h AS U64, key AS STRING) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_dict_remove", I32, CDECL, "PTR,STRPTR", h, key)
END FUNCTION
FUNCTION DictGetI64(h AS U64, key AS STRING) AS I64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_dict_get_i64", I64, CDECL, "PTR,STRPTR", h, key)
END FUNCTION
FUNCTION DictGetF64(h AS U64, key AS STRING) AS F64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_dict_get_f64", F64, CDECL, "PTR,STRPTR", h, key)
END FUNCTION
FUNCTION DictGetStr(h AS U64, key AS STRING) AS STRING
    RETURN CALL(DLL, "uxcollections.dll", "uxc_dict_get_str", STRPTR, CDECL, "PTR,STRPTR", h, key)
END FUNCTION
FUNCTION DictGetKind(h AS U64, key AS STRING) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_dict_get_kind", I32, CDECL, "PTR,STRPTR", h, key)
END FUNCTION
' Insertion-order positional key access, for FOR EACH-style enumeration.
FUNCTION DictKeyAt(h AS U64, idx AS I64) AS STRING
    RETURN CALL(DLL, "uxcollections.dll", "uxc_dict_key_at", STRPTR, CDECL, "PTR,I64", h, idx)
END FUNCTION
FUNCTION DictKeysAsList(h AS U64) AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_dict_keys_as_list", PTR, CDECL, "PTR", h)
END FUNCTION
FUNCTION DictValuesAsList(h AS U64) AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_dict_values_as_list", PTR, CDECL, "PTR", h)
END FUNCTION
FUNCTION DictGetOrDefaultI64(h AS U64, key AS STRING, defVal AS I64) AS I64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_dict_get_or_default_i64", I64, CDECL, "PTR,STRPTR,I64", h, key, defVal)
END FUNCTION
FUNCTION DictGetOrDefaultF64(h AS U64, key AS STRING, defVal AS F64) AS F64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_dict_get_or_default_f64", F64, CDECL, "PTR,STRPTR,F64", h, key, defVal)
END FUNCTION
FUNCTION DictGetOrDefaultStr(h AS U64, key AS STRING, defVal AS STRING) AS STRING
    RETURN CALL(DLL, "uxcollections.dll", "uxc_dict_get_or_default_str", STRPTR, CDECL, "PTR,STRPTR,STRPTR", h, key, defVal)
END FUNCTION
FUNCTION DictSetDefaultI64(h AS U64, key AS STRING, defVal AS I64) AS I64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_dict_set_default_i64", I64, CDECL, "PTR,STRPTR,I64", h, key, defVal)
END FUNCTION
FUNCTION DictSetDefaultF64(h AS U64, key AS STRING, defVal AS F64) AS F64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_dict_set_default_f64", F64, CDECL, "PTR,STRPTR,F64", h, key, defVal)
END FUNCTION
FUNCTION DictSetDefaultStr(h AS U64, key AS STRING, defVal AS STRING) AS STRING
    RETURN CALL(DLL, "uxcollections.dll", "uxc_dict_set_default_str", STRPTR, CDECL, "PTR,STRPTR,STRPTR", h, key, defVal)
END FUNCTION
FUNCTION DictPopI64(h AS U64, key AS STRING) AS I64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_dict_pop_i64", I64, CDECL, "PTR,STRPTR", h, key)
END FUNCTION
FUNCTION DictPopF64(h AS U64, key AS STRING) AS F64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_dict_pop_f64", F64, CDECL, "PTR,STRPTR", h, key)
END FUNCTION
FUNCTION DictPopStr(h AS U64, key AS STRING) AS STRING
    RETURN CALL(DLL, "uxcollections.dll", "uxc_dict_pop_str", STRPTR, CDECL, "PTR,STRPTR", h, key)
END FUNCTION
FUNCTION DictFirstKey(h AS U64) AS STRING
    RETURN CALL(DLL, "uxcollections.dll", "uxc_dict_first_key", STRPTR, CDECL, "PTR", h)
END FUNCTION
FUNCTION DictLastKey(h AS U64) AS STRING
    RETURN CALL(DLL, "uxcollections.dll", "uxc_dict_last_key", STRPTR, CDECL, "PTR", h)
END FUNCTION
FUNCTION DictPopFirst(h AS U64) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_dict_pop_first", I32, CDECL, "PTR", h)
END FUNCTION
FUNCTION DictPopLast(h AS U64) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_dict_pop_last", I32, CDECL, "PTR", h)
END FUNCTION
FUNCTION DictIsEmpty(h AS U64) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_dict_is_empty", I32, CDECL, "PTR", h)
END FUNCTION
FUNCTION DictContainsValueI64(h AS U64, x AS I64) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_dict_contains_value_i64", I32, CDECL, "PTR,I64", h, x)
END FUNCTION
FUNCTION DictContainsValueF64(h AS U64, x AS F64) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_dict_contains_value_f64", I32, CDECL, "PTR,F64", h, x)
END FUNCTION
FUNCTION DictContainsValueStr(h AS U64, s AS STRING) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_dict_contains_value_str", I32, CDECL, "PTR,STRPTR", h, s)
END FUNCTION
FUNCTION DictClone(h AS U64) AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_dict_clone", PTR, CDECL, "PTR", h)
END FUNCTION
SUB DictUpdate(dstH AS U64, srcH AS U64)
    CALL(DLL, "uxcollections.dll", "uxc_dict_update", VOID, CDECL, "PTR,PTR", dstH, srcH)
END SUB
FUNCTION DictMerge(aH AS U64, bH AS U64) AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_dict_merge", PTR, CDECL, "PTR,PTR", aH, bH)
END FUNCTION
FUNCTION DictInvert(h AS U64) AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_dict_invert", PTR, CDECL, "PTR", h)
END FUNCTION
FUNCTION DictEquals(aH AS U64, bH AS U64) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_dict_equals", I32, CDECL, "PTR,PTR", aH, bH)
END FUNCTION

' ---- SET (insertion-ordered) ----
FUNCTION SetNew() AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_set_new", PTR, CDECL)
END FUNCTION
SUB SetFree(h AS U64)
    CALL(DLL, "uxcollections.dll", "uxc_set_free", VOID, CDECL, "PTR", h)
END SUB
FUNCTION SetCount(h AS U64) AS I64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_set_count", I64, CDECL, "PTR", h)
END FUNCTION
SUB SetAdd(h AS U64, key AS STRING)
    CALL(DLL, "uxcollections.dll", "uxc_set_add", VOID, CDECL, "PTR,STRPTR", h, key)
END SUB
FUNCTION SetContains(h AS U64, key AS STRING) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_set_contains", I32, CDECL, "PTR,STRPTR", h, key)
END FUNCTION
FUNCTION SetRemove(h AS U64, key AS STRING) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_set_remove", I32, CDECL, "PTR,STRPTR", h, key)
END FUNCTION
FUNCTION SetKeyAt(h AS U64, idx AS I64) AS STRING
    RETURN CALL(DLL, "uxcollections.dll", "uxc_set_key_at", STRPTR, CDECL, "PTR,I64", h, idx)
END FUNCTION
FUNCTION SetUnion(aH AS U64, bH AS U64) AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_set_union", PTR, CDECL, "PTR,PTR", aH, bH)
END FUNCTION
FUNCTION SetIntersect(aH AS U64, bH AS U64) AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_set_intersect", PTR, CDECL, "PTR,PTR", aH, bH)
END FUNCTION
FUNCTION SetDifference(aH AS U64, bH AS U64) AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_set_difference", PTR, CDECL, "PTR,PTR", aH, bH)
END FUNCTION
FUNCTION SetSymmetricDifference(aH AS U64, bH AS U64) AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_set_symmetric_difference", PTR, CDECL, "PTR,PTR", aH, bH)
END FUNCTION
FUNCTION SetIsSupersetOf(aH AS U64, bH AS U64) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_set_is_superset_of", I32, CDECL, "PTR,PTR", aH, bH)
END FUNCTION
FUNCTION SetIsSubsetOf(aH AS U64, bH AS U64) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_set_is_subset_of", I32, CDECL, "PTR,PTR", aH, bH)
END FUNCTION
FUNCTION SetIsDisjoint(aH AS U64, bH AS U64) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_set_is_disjoint", I32, CDECL, "PTR,PTR", aH, bH)
END FUNCTION
FUNCTION SetEquals(aH AS U64, bH AS U64) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_set_equals", I32, CDECL, "PTR,PTR", aH, bH)
END FUNCTION
FUNCTION SetIsEmpty(h AS U64) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_set_is_empty", I32, CDECL, "PTR", h)
END FUNCTION
FUNCTION SetToList(h AS U64) AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_set_to_list", PTR, CDECL, "PTR", h)
END FUNCTION
FUNCTION SetClone(h AS U64) AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_set_clone", PTR, CDECL, "PTR", h)
END FUNCTION
SUB SetAddRange(h AS U64, listH AS U64)
    CALL(DLL, "uxcollections.dll", "uxc_set_add_range", VOID, CDECL, "PTR,PTR", h, listH)
END SUB
SUB SetRemoveRange(h AS U64, listH AS U64)
    CALL(DLL, "uxcollections.dll", "uxc_set_remove_range", VOID, CDECL, "PTR,PTR", h, listH)
END SUB
FUNCTION SetPop(h AS U64) AS STRING
    RETURN CALL(DLL, "uxcollections.dll", "uxc_set_pop", STRPTR, CDECL, "PTR", h)
END FUNCTION

' ---- SORTED TREE ----
FUNCTION TreeNew() AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_tree_new", PTR, CDECL)
END FUNCTION
SUB TreeFree(h AS U64)
    CALL(DLL, "uxcollections.dll", "uxc_tree_free", VOID, CDECL, "PTR", h)
END SUB
FUNCTION TreeCount(h AS U64) AS I64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_tree_count", I64, CDECL, "PTR", h)
END FUNCTION
FUNCTION TreeHeight(h AS U64) AS I64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_tree_height", I64, CDECL, "PTR", h)
END FUNCTION
SUB TreeSetI64(h AS U64, key AS STRING, x AS I64)
    CALL(DLL, "uxcollections.dll", "uxc_tree_set_i64", VOID, CDECL, "PTR,STRPTR,I64", h, key, x)
END SUB
SUB TreeSetF64(h AS U64, key AS STRING, x AS F64)
    CALL(DLL, "uxcollections.dll", "uxc_tree_set_f64", VOID, CDECL, "PTR,STRPTR,F64", h, key, x)
END SUB
SUB TreeSetStr(h AS U64, key AS STRING, s AS STRING)
    CALL(DLL, "uxcollections.dll", "uxc_tree_set_str", VOID, CDECL, "PTR,STRPTR,STRPTR", h, key, s)
END SUB
FUNCTION TreeHas(h AS U64, key AS STRING) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_tree_has", I32, CDECL, "PTR,STRPTR", h, key)
END FUNCTION
FUNCTION TreeGetI64(h AS U64, key AS STRING) AS I64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_tree_get_i64", I64, CDECL, "PTR,STRPTR", h, key)
END FUNCTION
FUNCTION TreeGetF64(h AS U64, key AS STRING) AS F64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_tree_get_f64", F64, CDECL, "PTR,STRPTR", h, key)
END FUNCTION
FUNCTION TreeGetStr(h AS U64, key AS STRING) AS STRING
    RETURN CALL(DLL, "uxcollections.dll", "uxc_tree_get_str", STRPTR, CDECL, "PTR,STRPTR", h, key)
END FUNCTION
FUNCTION TreeGetKind(h AS U64, key AS STRING) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_tree_get_kind", I32, CDECL, "PTR,STRPTR", h, key)
END FUNCTION
FUNCTION TreeRemove(h AS U64, key AS STRING) AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_tree_remove", I32, CDECL, "PTR,STRPTR", h, key)
END FUNCTION

' ---- N-ARY NODE TREE ----
FUNCTION NodeNewStr(s AS STRING) AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_node_new_str", PTR, CDECL, "STRPTR", s)
END FUNCTION
SUB NodeFree(h AS U64)
    CALL(DLL, "uxcollections.dll", "uxc_node_free", VOID, CDECL, "PTR", h)
END SUB
FUNCTION NodeAppendChildStr(h AS U64, s AS STRING) AS U64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_node_append_child_str", PTR, CDECL, "PTR,STRPTR", h, s)
END FUNCTION
FUNCTION NodeChildCount(h AS U64) AS I64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_node_child_count", I64, CDECL, "PTR", h)
END FUNCTION
FUNCTION NodeDepth(h AS U64) AS I64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_node_depth", I64, CDECL, "PTR", h)
END FUNCTION
FUNCTION NodeMaxHeight(h AS U64) AS I64
    RETURN CALL(DLL, "uxcollections.dll", "uxc_node_max_height", I64, CDECL, "PTR", h)
END FUNCTION
FUNCTION NodeGetStr(h AS U64) AS STRING
    RETURN CALL(DLL, "uxcollections.dll", "uxc_node_get_str", STRPTR, CDECL, "PTR", h)
END FUNCTION

' ---- Separate module availability ----
FUNCTION GraphBackendAvailable() AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_graph_backend_available", I32, CDECL)
END FUNCTION
FUNCTION DataframeBackendAvailable() AS I32
    RETURN CALL(DLL, "uxcollections.dll", "uxc_dataframe_backend_available", I32, CDECL)
END FUNCTION

END NAMESPACE
