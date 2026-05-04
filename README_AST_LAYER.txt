Bu paket src/parser/ast.fbs dosyasının genişletilmiş drop-in taslağıdır.
Mevcut parser çağrılarını korur: ASTNewNode, ASTAddChild, ASTDump, ASTToJson, ASTWriteJson.
Eklenenler: parent, family, flags, typeName, symbolName, role, typed node üreticileri, class/method/expr builder fonksiyonları.
İlk uygulanacak yer: src/parser/ast.fbs yedeği alınır, bu dosya ile değiştirilir, sonra derleme denenir.
Parser daha sonra yavaş yavaş ASTMakeClassMethod, ASTMakeConstructor, ASTMakeBinary gibi builder'lara taşınır.
