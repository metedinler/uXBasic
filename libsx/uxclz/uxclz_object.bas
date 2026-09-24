' Optional object-oriented facade for uxclz.dll.
' Keep this separate from the scalar C-ABI wrapper until every native CLASS
' backend supports NEW_EXPR and METHOD_CALL with full parity.
INCLUDE "libsx/uxclz/uxclz.bas"

CLASS UxClzObject
PROTECTED
    handle AS U64
    ownsHandle AS I32

PUBLIC
    CONSTRUCTOR()
        THIS.handle = 0
        THIS.ownsHandle = 0
    END CONSTRUCTOR

    METHOD Attach(nativeHandle AS U64, owns AS I32)
        THIS.Close()
        THIS.handle = nativeHandle
        THIS.ownsHandle = owns
    END METHOD

    METHOD NativeHandle() AS U64
        RETURN THIS.handle
    END METHOD

    METHOD IsValid() AS BOOLEAN
        IF THIS.handle = 0 THEN RETURN FALSE
        RETURN uxclz.ObjectIsValid(THIS.handle) <> 0
    END METHOD

    METHOD Retain() AS BOOLEAN
        IF THIS.handle = 0 THEN RETURN FALSE
        RETURN uxclz.ObjectRetain(THIS.handle) <> 0
    END METHOD

    METHOD QueryInterface(interfaceId AS U32) AS U64
        IF THIS.handle = 0 THEN RETURN 0
        RETURN uxclz.ObjectQueryInterface(THIS.handle, interfaceId)
    END METHOD

    METHOD Close()
        IF THIS.ownsHandle THEN
            IF THIS.handle <> 0 THEN
                uxclz.ObjectRelease(THIS.handle)
            END IF
        END IF
        THIS.handle = 0
        THIS.ownsHandle = 0
    END METHOD

    DESTRUCTOR()
        THIS.Close()
    END DESTRUCTOR
END CLASS
