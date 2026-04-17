#include "../include/uxstat.h"

UXSTAT_API int uxstat_ping(int value)
{
    return value + 1;
}

UXSTAT_API int uxstat_add_i32(int left, int right)
{
    return left + right;
}
