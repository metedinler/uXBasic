# UXB Extension File Types

| extension | purpose | can_contain_code | can_be_entrypoint | can_be_included | can_import_library | parser_mode | output_effect | example |
|---|---|---|---|---|---|---|---|---|
| .bas | Main BASIC source | yes | yes | yes | yes | program | compile/run | main.bas |
| .uxb | uXBasic source | yes | yes | yes | yes | program | compile/run | main.uxb |
| .uxbasic | uXBasic source | yes | yes | yes | yes | program | compile/run | main.uxbasic |
| .uxm | Project manifest | manifest | no | no | yes | manifest | project settings | app.uxm |
| .uxmh | uXBasic header | declarations | no | yes | yes | header | declaration import | api.uxmh |
| .bi | FreeBASIC include | declarations | no | yes | yes | foreign_header | native include | win.bi |
| .h | C header | declarations | no | yes | yes | foreign_header | native include | api.h |
| .hx | Library wrapper header | signatures | no | yes | yes | library_header | library binding | json.hx |
| .json | Generic JSON artifact | data | no | no | no | artifact | tool input/output | data.json |
| .mir.json | MIR JSON artifact | data | no | no | no | artifact | MIR export | program.mir.json |
| .ast.json | AST JSON artifact | data | no | no | no | artifact | AST export | program.ast.json |
| .wat | WebAssembly text | wat | no | no | no | target_artifact | WAT output | program.wat |
| .wasm | WebAssembly binary | binary | no | no | no | target_artifact | browser runtime | program.wasm |
| .js | JavaScript output/runtime | js | no | no | yes | target_artifact | JS output | program.js |
