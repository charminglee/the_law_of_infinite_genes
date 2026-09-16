#!/usr/bin/env python3
"""Convert parse_uasset.py's DataTable JSON output to a Lua table file."""

import argparse
import json
import math
import re
from pathlib import Path


def lua_key(key: str) -> str:
    # numeric row names become integer keys; valid identifiers stay bare
    if re.fullmatch(r"-?\d+", key):
        return f"[{key}]"
    if re.fullmatch(r"[A-Za-z_]\w*", key):
        return key
    return f"[{lua_string(key)}]"


def lua_string(s: str) -> str:
    escaped = (s.replace("\\", "\\\\")
                .replace('"', '\\"')
                .replace("\n", "\\n")
                .replace("\r", "\\r"))
    return f'"{escaped}"'


def is_intlike(v: float) -> bool:
    return isinstance(v, (int,)) or (isinstance(v, float) and v.is_integer()
                                     and abs(v) < 2 ** 53)


def to_lua(value, indent: int) -> str:
    pad = "    " * indent
    inner = "    " * (indent + 1)
    if value is None:
        return "nil"
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, (int, float)):
        if isinstance(value, float) and not value.is_integer():
            return repr(value)
        if math.isnan(value) or math.isinf(value):
            return "0/0"
        return str(int(value))
    if isinstance(value, str):
        return lua_string(value)
    if isinstance(value, list):
        if not value:
            return "{}"
        items = [f"{inner}{to_lua(v, indent + 1)}," for v in value]
        return "{\n" + "\n".join(items) + f"\n{pad}}}"
    if isinstance(value, dict):
        # soft object reference {path, sub_path}
        if set(value) <= {"path", "sub_path"} and "path" in value:
            return to_lua(value["path"], indent)
        # struct {_struct, ...fields}
        fields = {k: v for k, v in value.items() if k != "_struct"}
        if not fields:
            return "{}"
        entries = [f"{inner}{lua_key(k)} = {to_lua(v, indent + 1)},"
                   for k, v in fields.items()]
        return "{\n" + "\n".join(entries) + f"\n{pad}}}"
    raise TypeError(f"unsupported type {type(value)}")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("json_path")
    ap.add_argument("-o", "--output", required=True)
    ap.add_argument("--name", help="Lua variable name (default: table object_name)")
    args = ap.parse_args()

    doc = json.loads(Path(args.json_path).read_text(encoding="utf-8"))
    table = doc["table"]
    name = args.name or table["object_name"]

    lines = [
        f"-- {table['object_name']}.uasset",
        f"-- 行结构: {table.get('row_struct')}",
        f"-- 共 {table['row_count']} 行, 由 tools/parse_uasset.py + tools/json_to_lua.py 生成",
        "",
        f"local {name} = {{",
    ]
    for row_name, row in table["rows"].items():
        body = to_lua(row, 1)
        lines.append(f"    {lua_key(row_name)} = {body},")
    lines.append("}")
    lines.append("")
    lines.append(f"return {name}")

    out = "\n".join(lines) + "\n"
    Path(args.output).write_text(out, encoding="utf-8", newline="\n")
    print(f"wrote {args.output} ({len(out)} chars)")


if __name__ == "__main__":
    main()
