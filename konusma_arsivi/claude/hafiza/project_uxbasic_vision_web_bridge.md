---
name: project-uxbasic-vision-web-bridge
description: "uXBasic's strategic direction beyond bug-fixing — a systems language that also wants first-class, two-way native-exe <-> browser communication via preprocessor-built bridges."
metadata: 
  node_type: memory
  type: project
  originSessionId: 760ce433-ff72-46c7-8b20-30eed40f7a8c
  modified: 2026-09-06T16:15:23.552Z
---

The user described (2026-09-06) uXBasic's intended identity beyond the immediate bug list: it's fundamentally a **systems programming language**, but with real ambitions for its web/WAT/WASM/JS output targets — not treated as second-class. Quote (paraphrased): a browser can't normally reach a native `.exe` directly, but through preprocessor-built mechanisms it should be reachable somehow, with **bidirectional communication** — a Windows `.exe` and a browser page should be able to talk to each other, both directions open.

**Why this matters for how to treat the WASM/JS "fail-closed" findings from the audits:** the architectural gaps found (WASM can't do raw memory/file I/O, JS throws at runtime for unsupported opcodes, etc. — see the completeness-sweep findings referenced in [[uxb-fix-plan-decisions-2026-09]]) are not things the user wants quietly accepted as permanent second-class status. They're an active area the user wants uXBasic to keep pushing into, via preprocessor-driven cross-target tooling, working toward real exe<->browser bidirectional communication as a longer-term goal.

**Concrete, immediate documentation requirement the user stated:** the user guides/kılavuzlar must contain an explicit, accurate list of exactly which language/preprocessor commands are guaranteed to work under WAT, WASM, and JS output targets — not left to the reader to discover by trial and error. This lines up with (and elevates the priority of) Report III's recommendation to auto-generate a target-support matrix from `src/backend/common/backend_emit_policy.fbs` — treat that as a concrete, user-requested deliverable, not just a nice-to-have suggestion.

**How to apply:** when scoping WASM/JS-related fixes or documentation, don't frame them as "this target is inherently limited, document the limitation and move on" — frame gaps as a roadmap item, and prioritize the target-support-matrix documentation task highly since the user asked for it explicitly and it directly serves this vision.
