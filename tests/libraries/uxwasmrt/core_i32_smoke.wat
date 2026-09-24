(module
  (import "ux" "host_call4" (func $host_call4 (param i32 i32 i32 i32 i32) (result i32)))
  (import "ux" "print_i32" (func $print_i32 (param i32)))
  (import "ux" "print_f64" (func $print_f64 (param f64)))

  (func (export "ADD") (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.add)

  (func (export "HOST_ABS") (param $value i32) (result i32)
    i32.const 10
    local.get $value
    i32.const 0
    i32.const 0
    i32.const 0
    call $host_call4)

  (func (export "HOST_RNG_SEED_NEXT") (param $seed i32) (result i32)
    i32.const 5
    local.get $seed
    i32.const 0
    i32.const 0
    i32.const 0
    call $host_call4
    drop
    i32.const 4
    i32.const 0
    i32.const 0
    i32.const 0
    i32.const 0
    call $host_call4)

  (func (export "HOST_SQRT") (param $value i32) (result i32)
    i32.const 11
    local.get $value
    i32.const 0
    i32.const 0
    i32.const 0
    call $host_call4)
)
