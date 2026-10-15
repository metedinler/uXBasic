---
name: user-not-a-programmer
description: "User is not a programmer — always explain technical/programming terms in plain Turkish inline, and negotiate before making code changes."
metadata: 
  node_type: memory
  type: user
  originSessionId: 760ce433-ff72-46c7-8b20-30eed40f7a8c
  modified: 2026-09-06T15:23:10.981Z
---

The user owns/directs the uXBasic language+compiler project but is explicitly **not a programmer** and does not know standard technical/programming terminology. They asked (2026-09-06): "bilgisayardaki teknik programla terimlerini temelde bilgisayar programlayıcısı olmadığım için bilmiyorum buna göre bana anlat" (explain to me accordingly, since I fundamentally don't know computer programming terms).

**Why:** without this, reports/plans full of jargon (backend, opcode, ABI, MIR, lexer/parser, etc.) are not actionable for them.

**How to apply:**
- Every report/plan delivered to this user must be in Turkish, and any technical term must get a short plain-language gloss in parentheses the first time it's used in that document (e.g. "backend (derleyicinin çıktı ürettiği hedef platform)").
- Before making any nontrivial code change, present the decision as a plain-language choice with a recommendation and concrete examples, and wait for explicit agreement — this user wants to negotiate/discuss (see [[uxb-fix-plan-decisions-2026-09]] for the standing "karar önce, düzeltme sonra" workflow) rather than have changes made autonomously.
- Prefer visual/structured deliverables (published HTML artifacts) over dense chat walls of text for anything long enough to be a "report."
