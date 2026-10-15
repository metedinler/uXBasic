"""Source-derived registration inventory. Registration never implies acceptance."""
import argparse
import csv
import hashlib
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[2]
ENGINES = ("AST", "MIR", "x64", "AST-x64", "JS", "WASM")
parser = argparse.ArgumentParser()
parser.add_argument("--output", default="reports/acceptance_inventory")
args = parser.parse_args()
output = (ROOT / args.output).resolve()
if not output.is_relative_to(ROOT):
    raise SystemExit("Inventory output must remain within the active repository.")
output.mkdir(parents=True, exist_ok=True)
rows = {}
hashes = {}


def read(relative):
    path = ROOT / relative
    data = path.read_bytes()
    hashes[relative] = hashlib.sha256(data).hexdigest()
    return data.decode("utf-8-sig").splitlines()


def add(name, category, path, line, **metadata):
    key = (category, name.upper())
    row = rows.setdefault(key, {"name": name.upper(), "category": category,
                               "registrations": [], "metadata": metadata,
                               "acceptance": {engine: "UNMEASURED" for engine in ENGINES}})
    row["registrations"].append({"path": path, "line": line, "sha256": hashes[path], "metadata": metadata})


def case_function(relative, function, category):
    active = False
    for number, line in enumerate(read(relative), 1):
        if re.match(r"\s*(?:Private\s+)?Function\s+" + function + r"\b", line, re.I):
            active = True
        elif active and re.match(r"\s*End Function\b", line, re.I):
            break
        elif active and re.match(r"\s*Case\b", line, re.I):
            for name in re.findall(r'"([^"\r\n]+)"', line):
                add(name, category, relative, number)


case_function("src/parser/lexer/lexer_keyword_table.fbs", "IsKeyword", "lexer_keyword")
case_function("src/surface/uxb_surface_registry.fbs", "UXBSurfaceKnown", "surface_registration")
relative = "src/type_binding/type_builtin_registry.fbs"
for number, line in enumerate(read(relative), 1):
    match = re.search(r'UXBBuiltinTypeRuleMake\("([^"]+)",\s*("[^"]+"|\w+),\s*"([^"]*)",\s*"([^"]*)"\)', line)
    if match:
        name, result, arguments, targets = match.groups()
        add(name, "typed_builtin", relative, number, return_type=result.strip('"'), argument_policy=arguments,
            declared_target_policy=targets)
relative = "src/parser/parser/parser_stmt_registry.fbs"
for number, line in enumerate(read(relative), 1):
    match = re.match(r'\s*AddStatementDispatchEntry\s+"([^"]+)",\s*(\w+)', line)
    if match:
        add(match[1], "statement_dispatch", relative, number, handler=match[2])

# Declarations are an inventory of the live wrapper inputs, not proof that a
# DLL exports them or that a target implements the declared ABI.
for path in sorted((ROOT / "libsx").rglob("*.bas")):
    relative = path.relative_to(ROOT).as_posix()
    namespaces = []
    for number, line in enumerate(read(relative), 1):
        if re.match(r"\s*END\s+NAMESPACE\b", line, re.I):
            if namespaces:
                namespaces.pop()
        ns = re.match(r"\s*NAMESPACE\s+([A-Za-z_]\w*(?:\.[A-Za-z_]\w*)*)", line, re.I)
        if ns:
            namespaces.append(ns[1])
        namespace = ".".join(namespaces)
        match = re.match(r"\s*(?:PUBLIC\s+|PRIVATE\s+)?(?:DECLARE\s+)?(FUNCTION|SUB)\s+([A-Za-z_]\w*)", line, re.I)
        if match and not line.lstrip().upper().startswith("PRIVATE"):
            add((namespace + "." if namespace else "") + match[2], "library_declaration", relative, number,
                routine_kind=match[1].upper())

ordered = sorted(rows.values(), key=lambda row: (row["category"], row["name"]))
counts = {category: sum(row["category"] == category for row in ordered)
          for category in sorted({row["category"] for row in ordered})}
record = {"schema": "uxb.source_acceptance_inventory.v1", "source_hashes": hashes,
          "counts": counts, "rows": ordered,
          "registration_counts": {category: sum(len(row['registrations']) for row in ordered if row['category'] == category) for category in counts},
          "limitations": ["All acceptance cells start UNMEASURED.",
                          "A registry route or declared target policy is not implemented feature support.",
                          "Library declarations do not prove DLL exports, ownership, or ABI behavior.",
                          "Types, provider manifests, operators and protocol coverage need separate inventories.",
                          "A whole-program PASS must not be assigned to every token appearing in the source."]}
(output / "inventory.json").write_text(json.dumps(record, ensure_ascii=False, indent=2), encoding="utf-8")
with (output / "inventory.csv").open("w", encoding="utf-8-sig", newline="") as stream:
    writer = csv.writer(stream)
    writer.writerow(["category", "name", "registration_count", *ENGINES])
    for row in ordered:
        writer.writerow([row["category"], row["name"], len(row["registrations"]),
                         *(row["acceptance"][engine] for engine in ENGINES)])
(output / "summary.json").write_text(json.dumps({"counts": counts, "rows": len(ordered),
                                               "measured_acceptance_cells": 0,
                                               "unmeasured_cells": len(ordered) * len(ENGINES)}, indent=2), encoding="utf-8")
print(json.dumps({"rows": len(ordered), "counts": counts, "output": str(output)}, ensure_ascii=False))
