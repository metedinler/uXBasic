(module
  (import "evil" "run" (func $run (result i32)))
  (func (export "MAIN") (result i32)
    call $run)
)
