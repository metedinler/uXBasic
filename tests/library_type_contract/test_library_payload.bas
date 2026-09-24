#include once "../../src/interpreter/common/library_payload.fbs"

Sub Check(ByVal condition As Integer, ByVal label As String)
    If condition = 0 Then
        Print "FAIL library_payload "; label
        End 1
    End If
End Sub

Scope
    Dim original As UXBLibraryPayloadRef = UXBLibraryTextCreate("first")
    Dim retained As UXBLibraryPayloadRef = original
    Check original.node = retained.node, "physical copy retains"
    Dim cloned As UXBLibraryPayloadRef = UXBLibraryPayloadClone(original)
    Check cloned.node <> original.node, "clone owns distinct payload"
    CPtr(UXBLibraryTextPayload Ptr, original.node->dataPtr)->textValue = "changed"
    Check cloned.node->textFn(cloned.node->dataPtr) = "first", "clone independence"
    Check retained.node->textFn(retained.node->dataPtr) = "changed", "retain shares payload"
    original = original
    original.Clear()
    Check gUXBLibraryPayloadDrops = 0, "borrow remains alive"
    retained.Clear()
    retained.Clear()
    Check gUXBLibraryPayloadDrops = 1, "drop exactly once"
    Dim values(1) As UXBLibraryPayloadRef
    values(0) = cloned
    cloned.Clear()
    Check gUXBLibraryPayloadLive = 1, "array retains"
End Scope
Check gUXBLibraryPayloadLive = 0, "scope and array cleanup"
Check gUXBLibraryPayloadAllocations = gUXBLibraryPayloadDrops, "allocation balance"
Check gUXBLibraryPayloadClones = 1, "clone counter"
Print "PASS library_payload 10 checks"
