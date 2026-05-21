#ifndef UXB_FP80_BI
#define UXB_FP80_BI
Declare Function uxb_f80_size CDecl Alias "uxb_f80_size" () As Integer
Declare Sub uxb_f80_from_str CDecl Alias "uxb_f80_from_str" (ByVal src As ZString Ptr, ByVal outp As Extended Ptr)
Declare Sub uxb_f80_to_str CDecl Alias "uxb_f80_to_str" (ByVal a As Extended Ptr, ByVal outBuf As ZString Ptr, ByVal outBytes As Integer)
Declare Sub uxb_f80_add CDecl Alias "uxb_f80_add" (ByVal a As Extended Ptr, ByVal b As Extended Ptr, ByVal outp As Extended Ptr)
Declare Sub uxb_f80_sub CDecl Alias "uxb_f80_sub" (ByVal a As Extended Ptr, ByVal b As Extended Ptr, ByVal outp As Extended Ptr)
Declare Sub uxb_f80_mul CDecl Alias "uxb_f80_mul" (ByVal a As Extended Ptr, ByVal b As Extended Ptr, ByVal outp As Extended Ptr)
Declare Sub uxb_f80_div CDecl Alias "uxb_f80_div" (ByVal a As Extended Ptr, ByVal b As Extended Ptr, ByVal outp As Extended Ptr)
Declare Function uxb_f80_cmp CDecl Alias "uxb_f80_cmp" (ByVal a As Extended Ptr, ByVal b As Extended Ptr) As Integer
#endif
