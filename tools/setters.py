#!/usr/bin/env python3
"""Where each flag or item is set, and under what condition.

Run from the project root:  python3 tools/setters.py flag1 has:item2 ...

For each name, every line, choice or jump that sets it (flag=, take=, or the
door_/keep_ flags door= and keep= make), with the file, section, the entry's
own if=, and the conditions on the jumps and choices that lead into that
section. A map for checking that an ending can be reached (docs/routes.md).
"""
import os, sys, glob, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from story_graph import load_story, entries, STORY

def main(names):
    stories = {os.path.basename(p): load_story(p) for p in sorted(glob.glob(os.path.join(STORY, "*.txt")))}
    into = collections.defaultdict(list)
    for fname, sections in stories.items():
        for section, kind, entry in entries(sections):
            if kind in ("choices", "next"):
                label = entry.get("label", "->")
                into[(fname, entry["target"])].append("%s %s%s" % (section, label[:40], (" [if %s]" % entry["if"]) if "if" in entry else ""))
    for name in names:
        print("\n## %s" % name)
        item = name.startswith("has:")
        key = name[4:] if item else name
        for fname, sections in stories.items():
            for section, kind, entry in entries(sections):
                hit = False
                if item and entry.get("take") == key:
                    hit = True
                if not item:
                    if key in [f.strip() for f in entry.get("flag", "").split(",")]:
                        hit = True
                    for field in ("keep", "door"):
                        if key.startswith(field + "_") and entry.get(field) and key.startswith("%s_%s_" % (field, entry[field])):
                            hit = True
                if hit:
                    cond = entry.get("if", "")
                    print("- %s:%s (%s)%s" % (fname, section, entry.get("label", kind), (" if " + cond) if cond else ""))
                    for came in into.get((fname, section), [])[:4]:
                        print("    from: " + came)

if __name__ == "__main__":
    main(sys.argv[1:])
