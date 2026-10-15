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
      ;; docs/uxbasic_5_cilt/examples/projects/hibrit_pano/01b_wasm_skor_modulu.uxm:2:38 RET lexeme=-
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
  (func $TESLIMSKOR (param $TESLIM i32) (param $GECIKME i32) (param $HASAR i32) (result i32)
    (local $__pc i32)
    (local $__result i32)
    (local $__T1 i32)
    (local $__T2 i32)
    (local $__T3 i32)
    (local $__T4 i32)
    (local $__T5 i32)
    (local $__T6 i32)
    (local $__T7 i32)
    (local $__T8 i32)
    i32.const 0
    local.set $__pc
    block $exit
      loop $dispatch
        local.get $__pc
        i32.const 0
        i32.eq
        if
      ;; docs/uxbasic_5_cilt/examples/projects/hibrit_pano/01b_wasm_skor_modulu.uxm:2:21 LOAD_CONST lexeme=10
      i32.const 10
      local.set $__T1
      ;; docs/uxbasic_5_cilt/examples/projects/hibrit_pano/01b_wasm_skor_modulu.uxm:2:21 MUL lexeme=10
      local.get $TESLIM
      local.get $__T1
      i32.mul
      local.set $__T2
      ;; docs/uxbasic_5_cilt/examples/projects/hibrit_pano/01b_wasm_skor_modulu.uxm:2:36 LOAD_CONST lexeme=3
      i32.const 3
      local.set $__T3
      ;; docs/uxbasic_5_cilt/examples/projects/hibrit_pano/01b_wasm_skor_modulu.uxm:2:36 MUL lexeme=3
      local.get $GECIKME
      local.get $__T3
      i32.mul
      local.set $__T4
      ;; docs/uxbasic_5_cilt/examples/projects/hibrit_pano/01b_wasm_skor_modulu.uxm:2:34 SUB lexeme=*
      local.get $__T2
      local.get $__T4
      i32.sub
      local.set $__T5
      ;; docs/uxbasic_5_cilt/examples/projects/hibrit_pano/01b_wasm_skor_modulu.uxm:2:48 LOAD_CONST lexeme=7
      i32.const 7
      local.set $__T6
      ;; docs/uxbasic_5_cilt/examples/projects/hibrit_pano/01b_wasm_skor_modulu.uxm:2:48 MUL lexeme=7
      local.get $HASAR
      local.get $__T6
      i32.mul
      local.set $__T7
      ;; docs/uxbasic_5_cilt/examples/projects/hibrit_pano/01b_wasm_skor_modulu.uxm:2:46 SUB lexeme=*
      local.get $__T5
      local.get $__T7
      i32.sub
      local.set $__T8
      ;; docs/uxbasic_5_cilt/examples/projects/hibrit_pano/01b_wasm_skor_modulu.uxm:2:38 RET lexeme=-
      local.get $__T8
      local.set $__result
      br $exit
          br $exit
        end
        br $exit
      end
    end
    local.get $__result
  )
  (export "TESLIMSKOR" (func $TESLIMSKOR))
)
