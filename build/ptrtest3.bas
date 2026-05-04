Dim s As String = "abc"
Dim p As ULongInt
p = Cast(ULongInt, CPtr(Byte Ptr, StrPtr(s)))
Print p

