(module
  (import "ux" "host_call4" (func $uxb_host_call4 (param i32 i32 i32 i32 i32) (result i32)))
  (import "ux" "print_i32" (func $ux_print_i32 (param i32)))
  (import "ux" "print_f64" (func $ux_print_f64 (param f64)))
  (func $MAIN (result i32)
    (local $__pc i32)
    (local $__result i32)
    i32.const 0
    local.set $__pc
    block $exit
      loop $dispatch
        local.get $__pc
        i32.const 0
        i32.eq
        if
      ;; tests\wasm\01_add_function.bas:2:14 RET lexeme=+
      i32.const 0
      local.set $__result
      br $exit
          br $exit
        end
        br $exit
      end
    end
    local.get $__result
  )
  (export "MAIN" (func $MAIN))
  (func $ADD (param $A i32) (param $B i32) (result i32)
    (local $__pc i32)
    (local $__result i32)
    (local $__T1 i32)
    i32.const 0
    local.set $__pc
    block $exit
      loop $dispatch
        local.get $__pc
        i32.const 0
        i32.eq
        if
      ;; tests\wasm\01_add_function.bas:2:16 ADD lexeme=b
      local.get $A
      local.get $B
      i32.add
      local.set $__T1
      ;; tests\wasm\01_add_function.bas:2:14 RET lexeme=+
      local.get $__T1
      local.set $__result
      br $exit
          br $exit
        end
        br $exit
      end
    end
    local.get $__result
  )
  (export "ADD" (func $ADD))
)
