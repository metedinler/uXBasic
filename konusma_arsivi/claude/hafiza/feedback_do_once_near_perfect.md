---
name: feedback-do-once-near-perfect
description: "User's standing quality bar — don't fix things just to check a box; do each task once, aiming for near-complete/near-perfect coverage."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 760ce433-ff72-46c7-8b20-30eed40f7a8c
  modified: 2026-09-06T16:14:36.297Z
---

When discussing how to complete the missing library DLLs (uxraylib/uxsdl3/etc.), the user said explicitly (2026-09-06): "yapmış olmak için yapma. bir işi bir kere ama mükemmele yakın hedefleyerek yap" (don't do it just to have done it; do a job once, but aim for near-perfect).

**Why:** they'd rather wait longer for a genuinely complete wrapper/feature (e.g. the *entire* function surface of an external DLL like raylib, not a partial subset) than get something shipped quickly that's technically "done" but practically half-usable.

**How to apply:** this is a general standing bar for this project, not limited to the library-wrapping context it was said in. When implementing any of the decisions in [[uxb-fix-plan-decisions-2026-09]] (BYREF, multi-dim arrays, FOR EACH/iterators, STRUCT/UNION layout, etc.), favor full/thorough implementation over a minimal patch that merely silences the symptom — unless the user has explicitly chosen a "quick guard first" option for a specific item. When scoping any fix, state the "full" option's real cost honestly rather than defaulting to a shortcut.
