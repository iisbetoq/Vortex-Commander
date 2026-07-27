#!/usr/bin/env python3
"""set_brand.py - retarget the product name across VORTEX Commander user-facing files.

Idempotent: the current brand is tracked in <repo>/.brand (two lines:
display name, then slug). Running again swaps the *current* brand for the new
one, so you can rebrand any number of times without touching source manually.

Usage:
    python3 set_brand.py "My Cool Agent"
    python3 set_brand.py "My Cool Agent" --slug my-cool-agent   # override slug

Slug (used for the log-tag / logger name) defaults to a lowercased,
hyphenated form of the display name.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
BRAND_FILE = ROOT / ".brand"

# Files that carry the *display* name (shown to users / in docs).
DISPLAY_FILES = [
    "frontend/index.html",
    "frontend/login.html",
    "frontend/app.js",
    "backend/server.py",
    "scripts/SOUL.md",
    "README.md",
]
# Files that carry the *slug* (logger name / log tag). Keep narrow so we don't
# rewrite unrelated identifiers.
SLUG_FILES = ["backend/server.py"]


def slugify(name: str) -> str:
    s = re.sub(r"[^a-z0-9]+", "-", name.lower()).strip("-")
    return s or "agent"


def read_brand() -> tuple[str, str]:
    if BRAND_FILE.exists():
        lines = BRAND_FILE.read_text(encoding="utf-8").splitlines()
        if len(lines) >= 2:
            return lines[0].strip(), lines[1].strip()
    # sensible default matching the shipped template
    return "VORTEX Agent Commander", "vortex-commander"


def replace_in(files: list[str], old: str, new: str) -> int:
    if old == new:
        return 0
    total = 0
    for rel in files:
        p = ROOT / rel
        if not p.exists():
            continue
        txt = p.read_text(encoding="utf-8")
        n = txt.count(old)
        if n:
            p.write_text(txt.replace(old, new), encoding="utf-8")
            total += n
            print(f"    {rel}: {n} x '{old}' -> '{new}'")
    return total


def main() -> int:
    args = [a for a in sys.argv[1:] if a]
    if not args:
        print(__doc__)
        return 2
    new_name = args[0]
    new_slug = None
    if "--slug" in args:
        i = args.index("--slug")
        new_slug = args[i + 1] if i + 1 < len(args) else None
    new_slug = slugify(new_slug) if new_slug else slugify(new_name)

    old_name, old_slug = read_brand()
    print(f"==> rebranding: '{old_name}' -> '{new_name}'  (slug '{old_slug}' -> '{new_slug}')")

    dn = replace_in(DISPLAY_FILES, old_name, new_name)
    sn = replace_in(SLUG_FILES, old_slug, new_slug)

    BRAND_FILE.write_text(f"{new_name}\n{new_slug}\n", encoding="utf-8")
    print(f"==> done. {dn} display + {sn} slug replacements. Tracked in .brand")
    if dn == 0 and sn == 0:
        print("    (nothing changed — already that brand, or old brand not found)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
