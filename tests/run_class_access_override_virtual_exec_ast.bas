#include once "../src/parser/token_kinds.fbs"
#include once "../src/parser/lexer.fbs"
#include once "../src/parser/parser.fbs"
#include once "../src/runtime/memory_vm.fbs"
#include once "../src/runtime/memory_exec.fbs"
#include once "helpers/runtime_test_common.fbs"

Private Sub Main()
    Dim errText As String

    Dim srcVirtualOk As String
    srcVirtualOk = _
        "CLASS Base" & Chr(10) & _
        "PUBLIC" & Chr(10) & _
        "VIRTUAL METHOD Speak() AS I32" & Chr(10) & _
        "END CLASS" & Chr(10) & _
        "CLASS Dog EXTENDS Base" & Chr(10) & _
        "PUBLIC" & Chr(10) & _
        "tag AS I32" & Chr(10) & _
        "OVERRIDE METHOD Speak() AS I32" & Chr(10) & _
        "END CLASS" & Chr(10) & _
        "FUNCTION BASE_SPEAK(self AS I32) AS I32" & Chr(10) & _
        "BASE_SPEAK = 11" & Chr(10) & _
        "END FUNCTION" & Chr(10) & _
        "FUNCTION DOG_SPEAK(self AS I32) AS I32" & Chr(10) & _
        "DOG_SPEAK = 22" & Chr(10) & _
        "END FUNCTION" & Chr(10) & _
        "DIM d AS Dog" & Chr(10) & _
        "POKED 9900, d.SPEAK()"

    Dim psVirtualOk As ParseState
    If RTParseProgram(srcVirtualOk, psVirtualOk, errText) = 0 Then
        Print "FAIL virtual parse | "; errText
        End 1
    End If

    errText = ""
    If RTExecProgram(psVirtualOk, errText) = 0 Then
        Print "FAIL virtual exec | "; errText
        End 1
    End If

    If RTAssertEq(VMemPeekD(9900), 22, "virtual override dispatch") = 0 Then
        End 1
    End If

    Dim srcOverrideNoVirtual As String
    srcOverrideNoVirtual = _
        "CLASS Base" & Chr(10) & _
        "PUBLIC" & Chr(10) & _
        "METHOD Speak() AS I32" & Chr(10) & _
        "END CLASS" & Chr(10) & _
        "CLASS Dog EXTENDS Base" & Chr(10) & _
        "PUBLIC" & Chr(10) & _
        "OVERRIDE METHOD Speak() AS I32" & Chr(10) & _
        "END CLASS"

    If RTParseExpectFail(srcOverrideNoVirtual, "base method is not VIRTUAL", errText) = 0 Then
        Print "FAIL override-no-virtual fail-fast | "; errText
        End 1
    End If

    Dim srcOverrideSignatureMismatch As String
    srcOverrideSignatureMismatch = _
        "CLASS Base" & Chr(10) & _
        "PUBLIC" & Chr(10) & _
        "VIRTUAL METHOD Speak(x AS I32) AS I32" & Chr(10) & _
        "END CLASS" & Chr(10) & _
        "CLASS Dog EXTENDS Base" & Chr(10) & _
        "PUBLIC" & Chr(10) & _
        "OVERRIDE METHOD Speak() AS I32" & Chr(10) & _
        "END CLASS"

    If RTParseExpectFail(srcOverrideSignatureMismatch, "OVERRIDE signature mismatch", errText) = 0 Then
        Print "FAIL override-signature fail-fast | "; errText
        End 1
    End If

    Dim srcFriendAllowed As String
    srcFriendAllowed = _
        "CLASS Vault" & Chr(10) & _
        "PRIVATE" & Chr(10) & _
        "METHOD Secret() AS I32" & Chr(10) & _
        "RESTRICTED" & Chr(10) & _
        "METHOD Scoped() AS I32" & Chr(10) & _
        "FRIEND Auth" & Chr(10) & _
        "PUBLIC" & Chr(10) & _
        "id AS I32" & Chr(10) & _
        "METHOD Reveal() AS I32" & Chr(10) & _
        "END CLASS" & Chr(10) & _
        "FUNCTION VAULT_SECRET(self AS I32) AS I32" & Chr(10) & _
        "VAULT_SECRET = 7" & Chr(10) & _
        "END FUNCTION" & Chr(10) & _
        "FUNCTION VAULT_SCOPED(self AS I32) AS I32" & Chr(10) & _
        "VAULT_SCOPED = 9" & Chr(10) & _
        "END FUNCTION" & Chr(10) & _
        "FUNCTION VAULT_REVEAL(self AS I32) AS I32" & Chr(10) & _
        "VAULT_REVEAL = 1" & Chr(10) & _
        "END FUNCTION" & Chr(10) & _
        "FUNCTION AUTH_PROBE() AS I32" & Chr(10) & _
        "DIM v AS Vault" & Chr(10) & _
        "AUTH_PROBE = v.Secret() + v.Scoped()" & Chr(10) & _
        "END FUNCTION" & Chr(10) & _
        "POKED 9910, AUTH_PROBE()"

    Dim psFriendAllowed As ParseState
    If RTParseProgram(srcFriendAllowed, psFriendAllowed, errText) = 0 Then
        Print "FAIL friend-allowed parse | "; errText
        End 1
    End If

    errText = ""
    If RTExecProgram(psFriendAllowed, errText) = 0 Then
        Print "FAIL friend-allowed exec | "; errText
        End 1
    End If

    If RTAssertEq(VMemPeekD(9910), 16, "friend access allows private/restricted") = 0 Then
        End 1
    End If

    Dim srcPrivateDenied As String
    srcPrivateDenied = _
        "CLASS Vault" & Chr(10) & _
        "PRIVATE" & Chr(10) & _
        "METHOD Secret() AS I32" & Chr(10) & _
        "PUBLIC" & Chr(10) & _
        "id AS I32" & Chr(10) & _
        "METHOD Reveal() AS I32" & Chr(10) & _
        "END CLASS" & Chr(10) & _
        "FUNCTION VAULT_SECRET(self AS I32) AS I32" & Chr(10) & _
        "VAULT_SECRET = 7" & Chr(10) & _
        "END FUNCTION" & Chr(10) & _
        "FUNCTION VAULT_REVEAL(self AS I32) AS I32" & Chr(10) & _
        "VAULT_REVEAL = 1" & Chr(10) & _
        "END FUNCTION" & Chr(10) & _
        "DIM v AS Vault" & Chr(10) & _
        "POKED 9920, v.Secret()"

    If RTExecExpectFail(srcPrivateDenied, "access denied", errText) = 0 Then
        Print "FAIL private-access fail-fast | "; errText
        End 1
    End If

    Dim srcRestrictedDenied As String
    srcRestrictedDenied = _
        "CLASS Vault" & Chr(10) & _
        "RESTRICTED" & Chr(10) & _
        "METHOD Scoped() AS I32" & Chr(10) & _
        "PUBLIC" & Chr(10) & _
        "id AS I32" & Chr(10) & _
        "METHOD Reveal() AS I32" & Chr(10) & _
        "END CLASS" & Chr(10) & _
        "FUNCTION VAULT_SCOPED(self AS I32) AS I32" & Chr(10) & _
        "VAULT_SCOPED = 9" & Chr(10) & _
        "END FUNCTION" & Chr(10) & _
        "FUNCTION VAULT_REVEAL(self AS I32) AS I32" & Chr(10) & _
        "VAULT_REVEAL = 1" & Chr(10) & _
        "END FUNCTION" & Chr(10) & _
        "DIM v AS Vault" & Chr(10) & _
        "POKED 9924, v.Scoped()"

    If RTExecExpectFail(srcRestrictedDenied, "access denied", errText) = 0 Then
        Print "FAIL restricted-access fail-fast | "; errText
        End 1
    End If

    Print "PASS class access/override/virtual exec_ast"
    End 0
End Sub

Main
