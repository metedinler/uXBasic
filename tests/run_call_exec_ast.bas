' Test for CALL statement semantic and runtime
' This test verifies CALL statement with user-defined functions

SUB TestSub(a AS INTEGER)
    PRINT "TestSub called with "; a
END SUB

FUNCTION TestFunc(b AS INTEGER) AS INTEGER
    RETURN b * 2
END FUNCTION

' Main program
DIM x AS INTEGER
x = 5

CALL TestSub(x)
DIM result AS INTEGER
result = TestFunc(x)
PRINT "Result: "; result

END