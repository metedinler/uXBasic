# PCK2 - uXBasic CLASS Komutlari, Syntax ve Calistirilabilir Anahtar Kelimeler

Bu dokuman, mevcut uXBasic derleyici/runtime davranisina gore CLASS odakli calisabilir anahtar kelimeleri ve kullanim orneklerini verir.

## 1) Temel CLASS Tanimi

### CLASS / END CLASS
Syntax:
```basic
CLASS <ClassName>
    ' uye deklarasyonlari
END CLASS
```

Ornek:
```basic
CLASS Player
    hp AS I32
END CLASS
```

## 2) Erisim Alanlari

### PUBLIC / PRIVATE / RESTRICTED
Syntax:
```basic
CLASS <ClassName>
    PUBLIC
    ' public uyeler

    PRIVATE
    ' private uyeler

    RESTRICTED
    ' restricted uyeler
END CLASS
```

Ornek:
```basic
CLASS SecretBox
    PUBLIC
    id AS I32

    PRIVATE
    pin AS I32

    RESTRICTED
    token AS I32
END CLASS
```

## 3) FRIEND

### FRIEND <QualifiedModuleName>[, ...]
Syntax:
```basic
CLASS <ClassName>
    PRIVATE
    FRIEND Core.Auth, Core.Audit
END CLASS
```

Notlar:
- FRIEND deklarasyonu parser/semantic tarafinda denetlenir.
- PUBLIC bolgesinde FRIEND kullanimi fail-fast davranis uretebilir.

## 4) METHOD Bildirimi

### METHOD <Name>(...)[ AS <Type>]
Syntax:
```basic
CLASS <ClassName>
    METHOD Ping(self AS I32)
    METHOD GetValue(self AS I32) AS I32
END CLASS
```

Mevcut calisma modeli:
- CLASS icinde METHOD bildirimi yapilir.
- Method govdesi, disarida SUB/FUNCTION olarak adlandirma sozlesmesi ile yazilir:
  - `CLASSNAME_METHODNAME`

Ornek:
```basic
CLASS Box
    METHOD SetByThis(self AS I32)
END CLASS

SUB BOX_SETBYTHIS(self AS I32)
    POKED self, 1
END SUB
```

## 5) CONSTRUCTOR / DESTRUCTOR

### CONSTRUCTOR() / DESTRUCTOR()
Syntax:
```basic
CLASS <ClassName>
    CONSTRUCTOR()
    DESTRUCTOR()
END CLASS
```

Mevcut calisma modeli:
- Disarida adlandirma sozlesmesi ile implement edilir:
  - ctor: `CLASSNAME_CTOR`
  - dtor: `CLASSNAME_DTOR`

Ornek:
```basic
CLASS Vec2
    x AS I32
    y AS I32
    CONSTRUCTOR()
    DESTRUCTOR()
END CLASS

SUB VEC2_CTOR(self AS I32)
    ' init
END SUB

SUB VEC2_DTOR(self AS I32)
    ' cleanup
END SUB
```

## 6) Inheritance

### EXTENDS
Syntax:
```basic
CLASS Dog EXTENDS Animal
    breed AS I32
END CLASS
```

Ornek:
```basic
CLASS Animal
    METHOD Speak(self AS I32)
END CLASS

CLASS Dog EXTENDS Animal
    breed AS I32
END CLASS

SUB ANIMAL_SPEAK(self AS I32)
    POKED 9804, 77
END SUB

SUB DOG_SPEAK(self AS I32)
    POKED 9808, 99
END SUB
```

## 7) Interface Destegi

### INTERFACE / END INTERFACE
Syntax:
```basic
INTERFACE IAnimal
    METHOD Speak(self AS I32)
END INTERFACE
```

### IMPLEMENTS
Syntax:
```basic
CLASS Dog IMPLEMENTS IAnimal
    x AS I32
END CLASS
```

Ornek:
```basic
INTERFACE IAnimal
    METHOD Speak(self AS I32)
END INTERFACE

CLASS Dog IMPLEMENTS IAnimal
    x AS I32
END CLASS

SUB DOG_SPEAK(self AS I32)
    POKED 9872, 123
END SUB
```

Notlar:
- Semantic katman `IMPLEMENTS` icin method sozlesmesini kontrol eder.
- Runtime tarafinda `INTERFACE_STMT` deklarasyon/no-op olarak ele alinabilir.

## 8) THIS / ME

### THIS ve ME (method baglaminda)
Kullanim:
```basic
SUB BOX_SETBYTHIS(self AS I32)
    POKED THIS, 1
END SUB

SUB BOX_SETBYME(self AS I32)
    POKED ME, 2
END SUB
```

Notlar:
- THIS/ME sadece method baglaminda kullanilmalidir.
- Method disi kullanim semantic/runtime fail-fast uretebilir.

## 9) Method Cagrisi

### Dotted dispatch
Syntax:
```basic
CALL obj.MethodName()
```

Ornek:
```basic
DIM d AS Dog
CALL d.Speak()
```

## 10) Class Icin Ilgili Calisabilir Anahtar Kelime Ozeti

- CLASS
- END CLASS
- PUBLIC
- PRIVATE
- RESTRICTED
- FRIEND
- METHOD
- CONSTRUCTOR
- DESTRUCTOR
- EXTENDS
- INTERFACE
- END INTERFACE
- IMPLEMENTS
- THIS
- ME
- CALL

## 11) Kisa Uctan Uca Ornek

```basic
INTERFACE IAnimal
    METHOD Speak(self AS I32)
END INTERFACE

CLASS Animal
    METHOD Speak(self AS I32)
END CLASS

CLASS Dog EXTENDS Animal IMPLEMENTS IAnimal
    PUBLIC
    hp AS I32
END CLASS

SUB ANIMAL_SPEAK(self AS I32)
    POKED 1000, 10
END SUB

SUB DOG_SPEAK(self AS I32)
    POKED 1004, 20
END SUB

DIM d AS Dog
CALL d.Speak()
```

Beklenen:
- Parser CLASS/INTERFACE/IMPLEMENTS/EXTENDS yapisini kabul eder.
- Semantic, interface method sozlesmesini denetler.
- Runtime, dotted dispatch ile ilgili routine'i cagirir.
