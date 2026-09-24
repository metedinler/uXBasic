#include once "../../src/semantic/library_type_contract.fbs"

Dim errText As String
Dim idx As Integer
UXBLibraryTypeRegistryInit
idx = UXBLibraryTypeEnsureReferenceSet(errText)

If idx < 0 Then
    Print "FAIL library_type_contract register "; errText
    End 1
End If

If gUXBLibraryTypeCount <> 1 Then
    Print "FAIL library_type_contract count"
    End 1
End If

Dim rationalIdx As Integer
rationalIdx = UXBLibraryTypeRegistryFind("rational")
If rationalIdx <> idx Then
    Print "FAIL library_type_contract find"
    End 1
End If

If UXBLibraryTypeHasToken(gUXBLibraryTypes(idx).operatorsCsv, "ADD") = 0 Then
    Print "FAIL library_type_contract add"
    End 1
End If

If UXBLibraryTypeHasToken(gUXBLibraryTypes(idx).operatorsCsv, "GT") = 0 Then
    Print "FAIL library_type_contract gt"
    End 1
End If

If UXBLibraryTypeHasToken(gUXBLibraryTypes(idx).magicCsv, "TOSTRING") = 0 Then
    Print "FAIL library_type_contract tostring"
    End 1
End If

If UXBLibraryTypePolicyName(gUXBLibraryTypes(idx).wasmPolicy) <> "wasm_linear_memory" Then
    Print "FAIL library_type_contract wasm policy"
    End 1
End If

If gUXBLibraryTypes(idx).mirProvider <> "RATIONAL_REFERENCE" Then
    Print "FAIL library_type_contract mir provider"
    End 1
End If

If gUXBLibraryTypes(idx).jsProvider <> "RATIONAL_REFERENCE" Then
    Print "FAIL library_type_contract js provider"
    End 1
End If

Dim jsonText As String
jsonText = UXBLibraryTypeContractToJson(gUXBLibraryTypes(idx))
If InStr(jsonText, """type"": ""RATIONAL""") = 0 Then
    Print "FAIL library_type_contract json"
    End 1
End If

If InStr(jsonText, """mir_provider"": ""RATIONAL_REFERENCE""") = 0 Then
    Print "FAIL library_type_contract provider json"
    End 1
End If

Dim ownerIdx As Integer
Dim typeName As String
Dim memberName As String
If UXBLibraryTypeFindCallOwner("RATIONAL.GT", ownerIdx, typeName, memberName) = 0 Then
    Print "FAIL library_type_contract call owner"
    End 1
End If
If ownerIdx <> idx Or typeName <> "RATIONAL" Or memberName <> "GT" Then
    Print "FAIL library_type_contract call owner fields"
    End 1
End If

Dim resultType As String
If UXBLibraryTypeResolveCallName("RATIONAL.GT", ownerIdx, typeName, memberName, resultType) = 0 Then
    Print "FAIL library_type_contract call resolve"
    End 1
End If
If resultType <> "BOOLEAN" Then
    Print "FAIL library_type_contract call result"
    End 1
End If

If UXBLibraryTypeResolveCallName("RATIONAL.BOGUS", ownerIdx, typeName, memberName, resultType) <> 0 Then
    Print "FAIL library_type_contract bogus resolve"
    End 1
End If

UXBLibraryTypeRegistryInit
idx = UXBLibraryTypeRegistryLoadManifestFile("tests/library_type_contract/rational_external.library_type.json", errText)
If idx < 0 Then
    Print "FAIL library_type_contract file load "; errText
    End 1
End If

If gUXBLibraryTypeCount <> 1 Then
    Print "FAIL library_type_contract file load count"
    End 1
End If

If gUXBLibraryTypes(idx).packageName <> "uxmath.external_test" Then
    Print "FAIL library_type_contract file load package"
    End 1
End If

If gUXBLibraryTypes(idx).status <> "external_manifest_test" Then
    Print "FAIL library_type_contract file load status"
    End 1
End If

If UXBLibraryTypeCanConvertTo("I64", "RATIONAL", 1) = 0 Then
    Print "FAIL library_type_contract file load conversion"
    End 1
End If

If UXBLibraryTypeResolveCallName("RATIONAL.GT", ownerIdx, typeName, memberName, resultType) = 0 Or resultType <> "BOOLEAN" Then
    Print "FAIL library_type_contract file load call resolve"
    End 1
End If

Print "PASS library_type_contract RATIONAL manifest"
