(module
  (import "ux" "print_i32" (func $ux_print_i32 (param i32)))
  (func $Add (param $a i32) (param $b i32) (result i32)
    (local $t0 i32)
    local.get $a
    local.get $b
    i32.add
    local.set $t0
    local.get $t0
    return
  )
  (export "Add" (func $Add))
  (export "ADD" (func $Add))
)
