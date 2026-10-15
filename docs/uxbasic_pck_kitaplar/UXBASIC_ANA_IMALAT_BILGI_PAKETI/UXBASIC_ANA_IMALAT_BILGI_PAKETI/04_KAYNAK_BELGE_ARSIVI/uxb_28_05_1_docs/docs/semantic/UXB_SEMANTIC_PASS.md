# UXB Semantic Pass

Step3 keeps the existing `src/semantic/semantic_pass.fbs` validator and strengthens it with a semantic/type/layout gate. The gate runs after existing class, interface, overload, constant folding, reachability and vtable checks.

Inputs: `ParseState`, AST contract layer matrix, type/layout registries.
Outputs: semantic diagnostics and pass/fail result.
