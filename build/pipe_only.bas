PIPE Normalize, 5
    value = INPUT
    OUTPUT = value + 1
END PIPE
ON PIPE Normalize
MAIN
    sonuc = 10 | Normalize
    PRINT sonuc
END MAIN
