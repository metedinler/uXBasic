x = 4096
POKEB x, 65
POKEW x + 2, 4660
POKED x + 8, 305419896
MEMFILLB x + 16, 7, 4
MEMCOPYB x, x + 32, 1
a = PEEKB(x)
b = PEEKW(x + 2)
c = PEEKD(x + 8)
INC a
DEC a
