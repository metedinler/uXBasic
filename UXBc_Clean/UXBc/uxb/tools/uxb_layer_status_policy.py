#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Canonical layer decision status policy for UXBc surface matrices."""
from __future__ import annotations

from typing import Dict, Optional

CANONICAL_STATUSES = (
    "IMPLEMENTED",
    "COMPILE_TIME_ONLY",
    "RUNTIME_CALL",
    "NATIVE_ONLY",
    "JS_ONLY",
    "WASM_UNSUPPORTED",
    "DIAGNOSTIC_ONLY",
    "REMOVED_OR_RESERVED",
)

CANONICAL_SET = set(CANONICAL_STATUSES)

# Legacy status values currently produced by report-only scanners.
LEGACY_STATUSES = {
    "implemented",
    "partial",
    "diagnostic_only",
    "policy_only",
    "missing",
    "blocked",
    "pending",
    "unsupported",
    "",
}

COMPILE_LAYERS = {"lexer", "parser", "ast", "semantic", "hir"}
RUNTIME_LAYERS = {"mir", "interpreter_ast", "interpreter_mir", "runtime", "ffi"}
NATIVE_BACKEND_LAYERS = {"x64_codegen_ast", "x64_codegen_mir", "x64_ast", "x64_mir", "x86_codegen"}
JS_LAYERS = {"js_transpiler", "browser_runtime"}
WASM_LAYERS = {"wasm_emitter"}


def is_canonical_status(value: str) -> bool:
    return (value or "").strip().upper() in CANONICAL_SET


def canonicalize_status(layer: str, observed_status: str) -> str:
    """
    Convert legacy scanner output to canonical architecture decision status.
    This is deterministic and intentionally conservative.
    """
    layer_key = (layer or "").strip().lower()
    observed = (observed_status or "").strip().lower()

    if observed == "implemented":
        return "IMPLEMENTED"

    if observed in {"diagnostic_only", "policy_only", "blocked", "pending", "unsupported"}:
        return "DIAGNOSTIC_ONLY"

    if observed == "partial":
        if layer_key in COMPILE_LAYERS:
            return "COMPILE_TIME_ONLY"
        if layer_key in NATIVE_BACKEND_LAYERS:
            return "NATIVE_ONLY"
        if layer_key in JS_LAYERS:
            return "JS_ONLY"
        if layer_key in WASM_LAYERS:
            return "WASM_UNSUPPORTED"
        return "RUNTIME_CALL"

    # "missing" and empty/default cases are treated as deliberate non-shipped surface.
    if observed in {"missing", ""}:
        if layer_key in WASM_LAYERS:
            return "WASM_UNSUPPORTED"
        return "REMOVED_OR_RESERVED"

    # Unknown legacy values are still normalized to a legal terminal bucket.
    return "REMOVED_OR_RESERVED"


def parse_override_status(value: str) -> Optional[str]:
    v = (value or "").strip().upper()
    return v if v in CANONICAL_SET else None
