---
name: feedback-frequent-status-updates
description: "During long heads-down technical work (especially multi-step debugging like the clean-build repair), give periodic plain-language status notes rather than going silent for many tool calls in a row."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 760ce433-ff72-46c7-8b20-30eed40f7a8c
  modified: 2026-09-06T21:00:23.541Z
---

While deep in the from-scratch build-repair effort (2026-09-06, see [[uxb-clean-build-effort]]), the user interrupted a tool call to say: "arada sırada ne yaptığını bana bildir, bilgilendirme notları ver" (let me know what you're doing every once in a while, give informational notes).

**Why:** long, dense debugging sessions (many Read/Edit/rebuild cycles in a row with only terse one-line summaries between them) leave the user unable to follow along, especially since they've said elsewhere they don't know programming terminology (see [[user-not-a-programmer]]) and rely on being told what's happening in plain terms.

**How to apply:** during any extended multi-step technical task (debugging loops, large refactors, repeated build/verify cycles), pause every so often — roughly every several tool calls, or whenever a distinct sub-problem is resolved — to give a short, plain-Turkish status note: what was just found/fixed, in user-facing terms (not raw compiler jargon dumps), and what's coming next. This is in addition to, not instead of, the final summary at the end of a task. Don't wait until a whole multi-minute chain of edits is done to say anything.
