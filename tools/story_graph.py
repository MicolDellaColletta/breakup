#!/usr/bin/env python3
"""Reads every story file and prints a review of how the pieces connect.

Run from the project root:  python3 tools/story_graph.py > review_raw.md

It reads story/*.txt the way scripts/narrator.gd does (sections, lines,
choices, jumps, "| key=value" options), plus story/spots.cfg and
story/items.cfg, and the scripts for flags set or read in code. It reports:

- flags set and never read, and read and never set
- items taken and never used, used and never taken, defined and never taken
- sections nothing points to (candidates for dead ends; entry points named
  by code, like morning or *_enters, are left out)
- choices per file, how the voices' leans are spread, gated choices
- kept faith, betrayals and doors, per person, per file

It's a map, not a judge: every line in its output is a thing to look at.
"""

import collections
import configparser
import glob
import os
import re

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
STORY = os.path.join(ROOT, "story")

# Sections the game starts by name, from code, not from another section.
ENTRY_NAMES = {"morning", "opening", "closing", "evening", "start", "arrival",
               "sleep", "wake", "bed", "intro"}
ENTRY_SUFFIXES = ("_enters", "_leaves", "_again")
ENTRY_PREFIXES = ("use_", "seen_", "walk_", "hall_", "odd_", "look_", "examine_",
                  "take_gun", "confront", "bridge_", "radio", "window", "phone",
                  "dog", "back", "door", "map_", "lake", "pub", "church", "cabin")

CONDITION = re.compile(r"(!?)(flag|has|held|sold|broken|broke|order|knows|"
                       r"faith|faithless|doors|visited|window|background):"
                       r"([A-Za-z0-9_]+)")


def parse_options(parts, into):
    for part in parts[1:]:
        if "=" not in part:
            continue
        key, value = part.split("=", 1)
        key, value = key.strip(), value.strip()
        if key == "flag" and "flag" in into:
            into["flag"] += "," + value
        else:
            into[key] = value


def load_story(path):
    sections = collections.OrderedDict()
    current = None
    for raw in open(path, encoding="utf-8"):
        text = raw.strip()
        if not text or text.startswith("#"):
            continue
        if text.startswith("==="):
            current = text[3:].strip()
            sections[current] = {"lines": [], "choices": [], "next": []}
            continue
        if current is None:
            continue
        if text.startswith("->"):
            parts = text[2:].split("|")
            entry = {"target": parts[0].strip()}
            parse_options(parts, entry)
            sections[current]["next"].append(entry)
        elif text.startswith(">"):
            parts = text[1:].split("|")
            if "->" not in parts[0]:
                continue
            label, target = parts[0].split("->", 1)
            entry = {"label": label.strip(), "target": target.strip()}
            parse_options(parts, entry)
            sections[current]["choices"].append(entry)
        else:
            head = text.split(": ", 1)
            if len(head) < 2:
                continue
            header = head[0].split("|")
            entry = {"speaker": header[0].strip(), "text": head[1].strip()}
            parse_options(header, entry)
            sections[current]["lines"].append(entry)
    return sections


def entries(sections):
    for name, section in sections.items():
        for kind in ("lines", "choices", "next"):
            for entry in section[kind]:
                yield name, kind, entry


def main():
    stories = {}
    for path in sorted(glob.glob(os.path.join(STORY, "*.txt"))):
        stories[os.path.basename(path)] = load_story(path)

    spots = configparser.ConfigParser(interpolation=None, strict=False)
    spots.read(os.path.join(STORY, "spots.cfg"), encoding="utf-8")
    items = configparser.ConfigParser(interpolation=None, strict=False)
    items.read(os.path.join(STORY, "items.cfg"), encoding="utf-8")

    code = ""
    for path in glob.glob(os.path.join(ROOT, "scripts", "*.gd")):
        code += open(path, encoding="utf-8").read()

    flag_set = collections.defaultdict(set)
    flag_read = collections.defaultdict(set)
    item_take = collections.defaultdict(set)
    item_use = collections.defaultdict(set)
    counts = collections.defaultdict(lambda: collections.Counter())
    leans = collections.Counter()
    choice_rows = []
    targeted = collections.defaultdict(set)

    def read_conditions(text, where):
        for neg, kind, name in CONDITION.findall(text or ""):
            if kind == "flag":
                flag_read[name].add(where)
            elif kind in ("has", "held"):
                item_use[name].add(where)

    for fname, sections in stories.items():
        n_choices = n_gated = 0
        for section, kind, entry in entries(sections):
            where = "%s:%s" % (fname, section)
            read_conditions(entry.get("if"), where)
            for flag in filter(None, entry.get("flag", "").split(",")):
                flag_set[flag.strip()].add(where)
            for flag in filter(None, entry.get("unflag", "").split(",")):
                flag_read[flag.strip()].add(where + " (unflag)")
            if entry.get("take"):
                item_take[entry["take"]].add(where)
            if entry.get("lose"):
                item_use[entry["lose"]].add(where + " (lose)")
            for key in ("keep", "betray", "door"):
                if entry.get(key):
                    counts[entry[key]][key] += 1
            if kind in ("choices", "next"):
                targeted[fname].add(entry["target"])
            if kind == "choices":
                n_choices += 1
                if "if" in entry:
                    n_gated += 1
                leans[entry.get("lean", "(none)")] += 1
        choice_rows.append((fname, n_choices, n_gated))

    for name in spots.sections():
        spot = spots[name]
        where = "spots.cfg:" + name
        read_conditions(spot.get("if"), where)
        for key in spot:
            if key.startswith("use_"):
                item_use[key[4:]].add(where)
        if spot.get("section"):
            targeted["*spots*"].add(spot["section"].strip('"'))
        for key in spot:
            if key.startswith("use_") or key == "seen":
                targeted["*spots*"].add(spot[key].strip('"'))

    all_targets = set().union(*targeted.values())

    def in_code(name):
        return ('"%s"' % name) in code

    out = []
    out.append("# Story graph (generated by tools/story_graph.py)\n")
    out.append("%d story files, %d sections, %d spots, %d items.\n" % (
        len(stories), sum(len(s) for s in stories.values()),
        len(spots.sections()), len(items.sections())))

    out.append("\n## Flags set and never read\n")
    out.append("Set by a line or choice, never tested by `flag:` in a story,"
               " a spot, or the scripts. Either a payoff is missing, or the"
               " flag is dead.\n")
    for flag in sorted(flag_set):
        if flag not in flag_read and not in_code(flag) \
                and not flag.startswith(("keep_", "door_", "betrayed_")):
            out.append("- `%s` (%s)" % (flag, ", ".join(sorted(flag_set[flag]))))

    out.append("\n## Flags read and never set\n")
    out.append("Tested but never set by a story file (may be set in code).\n")
    for flag in sorted(flag_read):
        if flag not in flag_set:
            mark = " (named in scripts)" if in_code(flag) else ""
            out.append("- `%s`%s (%s)" % (flag, mark,
                                          ", ".join(sorted(flag_read[flag]))[:200]))

    out.append("\n## Items taken and never used\n")
    out.append("Taken, never tested with `has:`/`held:`, lost, or used on a"
               " spot. Some are fine (documents read from the pockets).\n")
    for item in sorted(item_take):
        if item not in item_use and not in_code(item):
            out.append("- `%s` (%s)" % (item, ", ".join(sorted(item_take[item]))))

    out.append("\n## Items used and never taken\n")
    for item in sorted(item_use):
        if item not in item_take and not in_code(item):
            out.append("- `%s` (%s)" % (item, ", ".join(sorted(item_use[item]))[:200]))

    out.append("\n## Items defined and never taken\n")
    for item in sorted(items.sections()):
        if item not in item_take and not in_code(item):
            out.append("- `%s`" % item)

    out.append("\n## Sections nothing points to\n")
    out.append("Not a jump or choice target, not named by a spot, not an entry"
               " name the code starts. Candidates for dead text.\n")
    for fname, sections in stories.items():
        orphans = []
        for name in sections:
            if name in all_targets or name in ENTRY_NAMES or in_code(name):
                continue
            if name.endswith(ENTRY_SUFFIXES) or name.startswith(ENTRY_PREFIXES):
                continue
            orphans.append(name)
        if orphans:
            out.append("- %s: %s" % (fname, ", ".join("`%s`" % o for o in orphans)))

    out.append("\n## Jumps and choices to missing sections\n")
    for fname, sections in stories.items():
        shared = set(sections) | set(stories.get("night_walks.txt", {})) \
            | set(stories.get("use.txt", {}))
        for section, kind, entry in entries(sections):
            if kind in ("choices", "next"):
                target = entry["target"]
                if not target.startswith("@") and target not in shared:
                    out.append("- %s:%s -> `%s`" % (fname, section, target))

    out.append("\n## Choices per file\n")
    out.append("| File | Choices | Gated |\n|---|---|---|")
    for fname, n, gated in choice_rows:
        if n:
            out.append("| %s | %d | %d |" % (fname, n, gated))

    out.append("\n## The voices' leans, over every choice\n")
    for lean, n in leans.most_common():
        out.append("- %s: %d" % (lean, n))

    out.append("\n## Kept faith, betrayals and doors, per person\n")
    out.append("| Person | keep | betray | door |\n|---|---|---|---|")
    for who in sorted(counts):
        c = counts[who]
        out.append("| %s | %d | %d | %d |" % (who, c["keep"], c["betray"], c["door"]))

    print("\n".join(out))


if __name__ == "__main__":
    main()
