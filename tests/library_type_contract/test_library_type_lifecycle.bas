#include once "../../src/semantic/library_type_contract.fbs"

Dim Shared checks As Integer
Sub Check(ByVal condition As Integer, ByVal label As String)
    checks += 1
    If condition = 0 Then
        Print "FAIL lifecycle "; label
        End 1
    End If
End Sub

Dim c As UXBLibraryTypeContract, parsed As UXBLibraryTypeContract
Dim errText As String, jsonText As String
UXBLibraryTypeMakeRationalReference c
Check UXBLibraryTypeRequireValueTransfer(c, errText), "RATIONAL value transfer"
jsonText = UXBLibraryTypeContractToJson(c)
Check UXBLibraryTypeContractFromJson(jsonText, parsed, errText), "JSON round trip"
Check parsed.storageModel = "value", "storage round trip"
Check parsed.copyModel = "bitcopy", "copy round trip"
Check parsed.cloneModel = "bitcopy", "clone round trip"
Check parsed.dropModel = "none", "drop round trip"

c.storageModel = "VALUE": c.copyModel = "BITCOPY": c.dropModel = "NONE"
Check UXBLibraryTypeRequireValueTransfer(c, errText), "case insensitive models"
c.copyModel = "typo"
Check UXBLibraryTypeValidate(c, errText) = 0 And InStr(errText, "copy_model") > 0, "unknown copy rejected"
c.copyModel = "bitcopy": c.storageModel = "reference"
Check UXBLibraryTypeValidate(c, errText) = 0 And InStr(errText, "BITCOPY requires") > 0, "reference bitcopy rejected"
c.storageModel = "value": c.dropModel = "provider": c.lifecycleCsv &= ",DROP"
Check UXBLibraryTypeValidate(c, errText) = 0 And InStr(errText, "BITCOPY requires") > 0, "owned bitcopy rejected"

' A dynamic payload declares hooks; registration must not imply runtime support.
UXBLibraryTypeContractInit c
c.typeName = "DYNAMIC_PAYLOAD": c.packageName = "tests.lifecycle"
c.sizeBytes = 8: c.alignBytes = 8
c.storageModel = "reference": c.copyModel = "retain"
c.cloneModel = "provider": c.dropModel = "provider"
c.lifecycleCsv = "CONSTRUCT,RETAIN,CLONE,DROP"
Check UXBLibraryTypeValidate(c, errText), "non-numeric reference contract"
Check UXBLibraryTypeRequireValueTransfer(c, errText) = 0 And InStr(errText, "lowering unavailable") > 0, "reference execution gated"
jsonText = UXBLibraryTypeContractToJson(c)
Check UXBLibraryTypeContractFromJson(jsonText, parsed, errText), "reference JSON round trip"
Check parsed.copyModel = "retain" And parsed.dropModel = "provider", "reference ownership preserved"

UXBLibraryTypeRegistryInit
Dim idx As Integer = UXBLibraryTypeRegistryRegister(c, errText)
Check idx >= 0, "reference metadata registered"
Dim ownerIdx As Integer, ownerName As String, memberName As String, resultType As String
Check UXBLibraryTypeResolveCallName("DYNAMIC_PAYLOAD.DROP", ownerIdx, ownerName, memberName, resultType), "drop resolved"
Check resultType = "VOID", "drop has no result"
Check UXBLibraryTypeResolveCallName("DYNAMIC_PAYLOAD.CLONE", ownerIdx, ownerName, memberName, resultType), "clone resolved"
Check resultType = "DYNAMIC_PAYLOAD", "clone preserves type"
Check UXBLibraryTypeResolveCallName("DYNAMIC_PAYLOAD.RETAIN", ownerIdx, ownerName, memberName, resultType), "retain resolved"
Check UXBLibraryTypeResolveCallName("DYNAMIC_PAYLOAD.MOVE", ownerIdx, ownerName, memberName, resultType) = 0, "undeclared move rejected"

c.lifecycleCsv = "CONSTRUCT,CLONE,DROP"
Check UXBLibraryTypeValidate(c, errText) = 0 And InStr(errText, "RETAIN hook") > 0, "missing retain rejected"
Check UXBLibraryTypeRegistryRegister(c, errText) = -1, "invalid replacement rejected"
Check gUXBLibraryTypes(idx).lifecycleCsv = "CONSTRUCT,RETAIN,CLONE,DROP", "registry unchanged after invalid replacement"
c.lifecycleCsv = "CONSTRUCT,RETAIN,CLONE"
Check UXBLibraryTypeValidate(c, errText) = 0 And InStr(errText, "DROP hook") > 0, "missing drop rejected"
c.lifecycleCsv = "CONSTRUCT,RETAIN,DROP"
Check UXBLibraryTypeValidate(c, errText) = 0 And InStr(errText, "CLONE hook") > 0, "missing clone rejected"
c.lifecycleCsv = "CONSTRUCT,RETAIN,CLONE,DROP": c.storageModel = "value"
Check UXBLibraryTypeValidate(c, errText) = 0 And InStr(errText, "RETAIN requires") > 0, "value retain rejected"
c.copyModel = "clone"
Check UXBLibraryTypeValidate(c, errText), "owned value clone contract"
Check UXBLibraryTypeRequireValueTransfer(c, errText) = 0, "owned value execution gated"
c.cloneModel = "unsupported"
Check UXBLibraryTypeValidate(c, errText) = 0 And InStr(errText, "PROVIDER clone") > 0, "clone copy requires hook"
c.copyModel = "forbidden"
Check UXBLibraryTypeValidate(c, errText), "noncopyable contract"
Check UXBLibraryTypeRequireValueTransfer(c, errText) = 0, "noncopyable execution gated"
c.cloneModel = "bitcopy"
Check UXBLibraryTypeValidate(c, errText) = 0 And InStr(errText, "BITCOPY clone") > 0, "owned clone cannot bitcopy"
c.cloneModel = "provider": c.storageModel = "typo"
Check UXBLibraryTypeValidate(c, errText) = 0 And InStr(errText, "storage_model") > 0, "unknown storage rejected"
c.storageModel = "value": c.cloneModel = "typo"
Check UXBLibraryTypeValidate(c, errText) = 0 And InStr(errText, "clone_model") > 0, "unknown clone rejected"
c.cloneModel = "provider": c.dropModel = "typo"
Check UXBLibraryTypeValidate(c, errText) = 0 And InStr(errText, "drop_model") > 0, "unknown drop rejected"

idx = UXBLibraryTypeRegistryLoadManifestFile("tests/library_type_contract/rational_external_manifest.json", errText)
Check idx >= 0, "legacy manifest readable"
Check gUXBLibraryTypes(idx).storageModel = "unspecified", "legacy has no implied ownership"
Check UXBLibraryTypeRequireValueTransfer(gUXBLibraryTypes(idx), errText) = 0, "legacy execution requires explicit models"
UXBLibraryTypeMakeRationalReference c
c.dropModel = "unspecified"
Check UXBLibraryTypeValidate(c, errText) = 0, "partial models rejected"

Dim malformed As String
malformed = "{""schema"":""uxb.library_type.contract.v1"",""type"":""BAD"",""package"":""test"",""storage_model"":42}"
Check UXBLibraryTypeContractFromJson(malformed, parsed, errText) = 0 And InStr(errText, "must be a string") > 0, "non-string model rejected"
Print "PASS library_type_lifecycle "; checks; " checks"
