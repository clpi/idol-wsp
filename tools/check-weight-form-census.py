#!/usr/bin/env python3
"""Check for weight-form-census-1: the shared WSP + Wide census.

Fails (exit 1) if, in either repo root given:
- weight-form-census.md is missing, or the two copies diverge;
- the README index entry line carrying identifier
  weight-form-census-1 and link weight-form-census.md is
  missing, or the two entry lines diverge;
- this check script itself diverges between the two repos;
- the census totals do not equal a recount of the census
  table, or any of graph / syntax / intent / unmapped has
  no row.
Usage: check-weight-form-census.py <idol-wsp root> <idol-wide root>
"""
import hashlib
import re
import sys
from pathlib import Path

IDENT = "weight-form-census-1"
CENSUS = "weight-form-census.md"
SCRIPT = "tools/check-weight-form-census.py"
FORMS = ["graph", "syntax", "intent", "unmapped"]


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def entry_line(readme):
    for line in readme.read_text().splitlines():
        if IDENT in line and CENSUS in line and line.lstrip().startswith("- "):
            return line
    return None


def main():
    if len(sys.argv) != 3:
        print("usage: check-weight-form-census.py <wsp root> <wide root>")
        return 1
    roots = [Path(sys.argv[1]), Path(sys.argv[2])]
    fails = []

    censuses = []
    for root in roots:
        p = root / CENSUS
        if not p.exists():
            fails.append(f"missing census file: {p}")
        else:
            censuses.append(p)
    if len(censuses) == 2 and digest(censuses[0]) != digest(censuses[1]):
        fails.append("census files diverge between repos")

    entries = []
    for root in roots:
        readme = root / "README.md"
        if not readme.exists():
            fails.append(f"missing README index: {readme}")
            continue
        line = entry_line(readme)
        if line is None:
            fails.append(f"missing census entry in {readme}")
        else:
            entries.append(line)
    if len(entries) == 2 and entries[0] != entries[1]:
        fails.append("README census entries diverge between repos")

    scripts = [root / SCRIPT for root in roots]
    if all(p.exists() for p in scripts):
        if digest(scripts[0]) != digest(scripts[1]):
            fails.append("check scripts diverge between repos")
    else:
        fails.append("check script missing in a repo")

    if censuses:
        text = censuses[0].read_text()
        rows = re.findall(r"^\| \d+ \| [^|]+ \| (graph|syntax|intent|unmapped) \|",
                          text, re.M)
        counted = {f: rows.count(f) for f in FORMS}
        for form in FORMS:
            if counted[form] == 0:
                fails.append(f"form has no census row: {form}")
            m = re.search(rf"^\| {form} \| (\d+) \|$", text, re.M)
            if not m or int(m.group(1)) != counted[form]:
                fails.append(f"totals diverge from recount for form: {form}")
        m = re.search(r"^\| total \| (\d+) \|$", text, re.M)
        if not m or int(m.group(1)) != len(rows):
            fails.append("total diverges from recount")

    if fails:
        for f in fails:
            print("FAIL:", f)
        return 1
    print("OK: weight-form-census-1 identical in both repos; totals recount clean")
    return 0


if __name__ == "__main__":
    sys.exit(main())
