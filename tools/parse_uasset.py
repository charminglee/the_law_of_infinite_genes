#!/usr/bin/env python3
"""Parse Unreal Engine .uasset (UE4.25+ uncooked package) DataTable to JSON.

Supports: FPackageFileSummary, name table, import/export tables, tagged
property lists (4.25+ format) and UDataTable row serialization.

Usage: python tools/parse_uasset.py <file> -o <output.json>
"""

import argparse
import json
import struct
import sys
from pathlib import Path


class Reader:
    def __init__(self, data: bytes, pos: int = 0):
        self.d = data
        self.p = pos

    def _unpack(self, fmt: str, size: int):
        v = struct.unpack_from("<" + fmt, self.d, self.p)[0]
        self.p += size
        return v

    def i8(self): return self._unpack("b", 1)
    def u8(self): return self._unpack("B", 1)
    def i16(self): return self._unpack("h", 2)
    def u16(self): return self._unpack("H", 2)
    def i32(self): return self._unpack("i", 4)
    def u32(self): return self._unpack("I", 4)
    def i64(self): return self._unpack("q", 8)
    def u64(self): return self._unpack("Q", 8)
    def f32(self): return self._unpack("f", 4)
    def f64(self): return self._unpack("d", 8)

    def raw(self, n: int) -> bytes:
        v = self.d[self.p:self.p + n]
        if len(v) != n:
            raise EOFError(f"wanted {n} bytes at {self.p}, only {len(v)} left")
        self.p += n
        return v

    def fstring(self) -> str:
        n = self.i32()
        if n == 0:
            return ""
        if n > 0:
            s = self.d[self.p:self.p + n].decode("utf-8", "replace")
            self.p += n
        else:
            nb = (-n) * 2
            s = self.d[self.p:self.p + nb].decode("utf-16-le", "replace")
            self.p += nb
        return s.rstrip("\x00")


class UAsset:
    def __init__(self, data: bytes):
        self.d = data
        self.names: list[str] = []
        self.imports: list[dict] = []
        self.exports: list[dict] = []
        self.warnings: list[str] = []
        self._parse_summary()
        self._parse_names()
        self._parse_imports()
        self._parse_exports()

    # ---------- summary ----------
    def _parse_summary(self):
        r = Reader(self.d)
        self.tag = r.u32()
        if self.tag != 0x9E2A83C1:
            raise ValueError(f"not a uasset (magic {self.tag:#x})")
        self.legacy_version = r.i32()
        if self.legacy_version != -4:
            self.legacy_ue3_version = r.i32()
        self.file_version_ue4 = r.i32()
        if self.legacy_version <= -8:
            self.file_version_ue5 = r.i32()
        else:
            self.file_version_ue5 = 0
        self.licensee_version = r.i32()

        cv_count = r.i32()
        self.custom_versions = []
        for _ in range(cv_count):
            key = r.raw(16)
            ver = r.i32()
            self.custom_versions.append({
                "guid": str(struct.unpack("<IHH8s", key)) if False else key.hex(),
                "version": ver,
            })

        self.total_header_size = r.i32()
        self.folder_name = r.fstring()
        self.package_flags = r.u32()

        # Empirical layout for this engine build (FileVersionUE4 521,
        # licensee): name pair, one zero pair, export pair, import pair,
        # depends. Verified against physical table locations.
        self.name_count = r.i32()
        self.name_offset = r.i32()
        self.soft_paths_count = r.i32()
        self.soft_paths_offset = r.i32()
        self.export_count = r.i32()
        self.export_offset = r.i32()
        self.import_count = r.i32()
        self.import_offset = r.i32()
        self.depends_offset = r.i32()

        # Remaining summary fields are build-specific; parse best-effort.
        try:
            self.package_guid = r.raw(16).hex()
            self.persistent_guid = r.raw(16).hex()
            gen_count = r.i32()
            self.generations = [[r.i32(), r.i32()] for _ in range(gen_count)]
            self.saved_by_engine = self._engine_version(r)
            self.compatible_engine = self._engine_version(r)
            self.compression_flags = r.u32()
            chunks = r.i32()
            if chunks > 0:
                r.raw(chunks * 8)
            self.bulk_data_start_offset = r.i64()
        except (EOFError, struct.error):
            self.package_guid = self.persistent_guid = None
            self.generations = []
            self.saved_by_engine = self.compatible_engine = None
            self.compression_flags = 0
            self.bulk_data_start_offset = 0

    @staticmethod
    def _engine_version(r: Reader):
        major = r.u16()
        minor = r.u16()
        patch = r.u16()
        changelist = r.u32()
        branch = r.fstring()
        return {"major": major, "minor": minor, "patch": patch,
                "changelist": changelist, "branch": branch or None}

    # ---------- tables ----------
    def _parse_names(self):
        r = Reader(self.d, self.name_offset)
        for _ in range(self.name_count):
            s = r.fstring()
            r.u16()  # non-case-preserving hash
            r.u16()  # case-preserving hash
            self.names.append(s)

    def _parse_imports(self):
        r = Reader(self.d, self.import_offset)
        for i in range(self.import_count):
            cp_i, cp_n = r.i32(), r.i32()
            cn_i, cn_n = r.i32(), r.i32()
            outer = r.i32()
            on_i, on_n = r.i32(), r.i32()
            self.imports.append({
                "class_package": self.fname(cp_i, cp_n),
                "class_name": self.fname(cn_i, cn_n),
                "outer_index": outer,
                "object_name": self.fname(on_i, on_n),
            })

    def _parse_exports(self):
        # entry layout: fixed prefix 44 bytes (indices+fname+flags) + serial
        # size/offset as i64 (ver>=519) + trailing bools/guids/deps.
        # bGeneratePublicHash gate is 522; preload deps gate ~508. Both
        # candidates are validated below.
        for entry_size, with_public_hash in ((104, False), (112, True)):
            ok = True
            entries = []
            try:
                r = Reader(self.d, self.export_offset)
                for _ in range(self.export_count):
                    start = r.p
                    e = {
                        "class_index": r.i32(),
                        "super_index": r.i32(),
                        "template_index": r.i32(),
                        "outer_index": r.i32(),
                    }
                    on_i, on_n = r.i32(), r.i32()
                    e["object_name"] = (on_i, on_n)
                    e["object_flags"] = r.u32()
                    e["serial_size"] = r.i64()
                    e["serial_offset"] = r.i64()
                    r.i32(); r.i32(); r.i32()  # forced/notclient/notserver
                    r.raw(16)  # package guid
                    r.u32()  # package flags
                    r.i32(); r.i32()  # notalwaysloaded, isasset
                    if with_public_hash:
                        r.i32()
                    r.i32(); r.i32(); r.i32(); r.i32(); r.i32()
                    assert r.p - start == entry_size
                    if not (0 < e["serial_offset"] <= len(self.d)
                            and e["serial_offset"] + e["serial_size"] <= len(self.d)):
                        ok = False
                        break
                    entries.append(e)
            except (AssertionError, EOFError, struct.error):
                ok = False
            if ok and len(entries) == self.export_count:
                for e in entries:
                    i, n = e.pop("object_name")
                    e["object_name"] = self.fname(i, n)
                self.exports = entries
                return
        raise ValueError("failed to parse export table layout")

    # ---------- helpers ----------
    def fname(self, index: int, number: int) -> str:
        if index == -1:
            return "None"
        if not (0 <= index < len(self.names)):
            return f"<badname:{index},{number}>"
        s = self.names[index]
        if number > 0:
            s = f"{s}_{number - 1}"
        return s

    def read_fname(self, r: Reader) -> str:
        return self.fname(r.i32(), r.i32())

    def import_path(self, idx: int) -> str:
        if not (0 <= idx < len(self.imports)):
            return f"<badimport:{idx}>"
        parts = []
        cur = idx
        guard = 0
        while cur >= 0 and guard < 100:
            guard += 1
            imp = self.imports[cur]
            parts.append(imp["object_name"])
            cur = imp["outer_index"]
            if cur >= 0:
                break
            cur = ~cur
        return ".".join(reversed(parts)) if parts else "<none>"

    def ref_str(self, idx: int):
        if idx == 0:
            return None
        if idx < 0:
            return self.import_path(~idx)
        if idx <= len(self.exports):
            return self.exports[idx - 1]["object_name"]
        return f"<badref:{idx}>"


    # ---------- property parsing ----------
    def parse_property_list(self, r: Reader, depth: int = 0,
                            end: int | None = None) -> list[dict]:
        props = []
        while end is None or r.p < end:
            tag = self.parse_tag(r)
            if tag is None:
                break
            if end is not None and tag["data_start"] + tag["size"] > end:
                self.warnings.append(
                    f"property {tag['name']} overflows bounded list "
                    f"(tag end {tag['data_start'] + tag['size']:#x} > {end:#x})")
                r.p = tag["pos_before"]
                break
            value, err = self.parse_value(r, tag, depth + 1)
            consumed = r.p - tag["data_start"]
            if err is None and consumed != tag["size"]:
                err = f"consumed {consumed}, expected {tag['size']}"
            if err is not None:
                self.warnings.append(
                    f"property {tag['name']} ({tag['type']}): {err}; keeping raw bytes")
                r.p = tag["data_start"]
                value = {"_raw": self.d[tag["data_start"]:tag["data_start"] + tag["size"]].hex()}
                r.p = tag["data_start"] + tag["size"]
            entry = {"name": tag["name"], "type": tag["type"], "value": value}
            if tag.get("array_index"):
                entry["array_index"] = tag["array_index"]
            if tag.get("enum_name") and tag["type"] not in ("ByteProperty", "EnumProperty"):
                entry["enum_name"] = tag["enum_name"]
            props.append(entry)
        return props

    def parse_tag(self, r: Reader):
        pos_before = r.p
        name_i, name_n = r.i32(), r.i32()
        if name_i == -1 or (0 <= name_i < len(self.names) and self.names[name_i] == "None"):
            return None
        type_i, type_n = r.i32(), r.i32()
        tag = {
            "name": self.fname(name_i, name_n),
            "type": self.fname(type_i, type_n),
            "size": r.i32(),
            "array_index": r.i32(),
            "pos_before": pos_before,
        }
        t = tag["type"]
        if t == "StructProperty":
            tag["struct_type"] = self.read_fname(r)
            tag["struct_guid"] = r.raw(16).hex()
        elif t == "ArrayProperty":
            tag["inner_type"] = self.read_fname(r)
        elif t in ("ByteProperty", "EnumProperty"):
            tag["enum_name"] = self.read_fname(r)
        elif t == "BoolProperty":
            tag["bool_val"] = r.u8()
        has_guid = r.u8()
        if has_guid:
            tag["property_guid"] = r.raw(16).hex()
        tag["data_start"] = r.p
        return tag

    def parse_value(self, r: Reader, tag: dict, depth: int):
        """Returns (value, error)."""
        t = tag["type"]
        try:
            if t == "BoolProperty":
                return tag["bool_val"], None
            if t == "ByteProperty":
                if tag.get("enum_name") and tag["enum_name"] != "None":
                    return self.read_fname(r), None
                return r.u8(), None
            if t == "EnumProperty":
                enum = self.read_fname(r)
                return {"enum": enum, "value": r.u8()}, None
            if t == "IntProperty": return r.i32(), None
            if t == "UInt32Property": return r.u32(), None
            if t == "Int64Property": return r.i64(), None
            if t == "UInt64Property": return r.u64(), None
            if t == "FloatProperty": return r.f32(), None
            if t == "DoubleProperty": return r.f64(), None
            if t == "NameProperty": return self.read_fname(r), None
            if t == "StrProperty": return r.fstring(), None
            if t == "TextProperty":
                return self.parse_text(r), None
            if t in ("ObjectProperty", "WeakObjectProperty", "LazyObjectProperty",
                     "AssetObjectProperty", "InterfaceProperty"):
                return {"ref": self.ref_str(r.i32())}, None
            if t in ("SoftObjectProperty", "SoftClassProperty"):
                path = self.read_fname(r)
                sub = r.fstring()
                return {"path": path, "sub_path": sub or None}, None
            if t == "ArrayProperty":
                inner = tag.get("inner_type", "StructProperty")
                count = r.i32()
                # wrapper tag describing the concatenated element data
                wrapper = self.parse_tag(r)
                if wrapper is None:
                    return [], None
                inner = wrapper["type"]
                wend = wrapper["data_start"] + wrapper["size"]
                items = []
                for _ in range(count):
                    if inner == "StructProperty":
                        props = self.parse_property_list(r, depth)
                        v = {"_type": wrapper.get("struct_type", "Struct"),
                             "properties": props}
                        e = None
                    else:
                        v, e = self.parse_inner_value(r, inner, wrapper, depth)
                    if e: return None, f"array item: {e}"
                    items.append(v)
                if r.p != wend:
                    return None, f"array elements ended at {r.p:#x}, wrapper ends {wend:#x}"
                return items, None
            if t == "MapProperty":
                key_t = self.read_fname(r)
                val_t = self.read_fname(r)
                count = r.i32()
                pairs = []
                for _ in range(count):
                    k, e = self.parse_inner_value(r, key_t, tag, depth)
                    if e: return None, f"map key: {e}"
                    v, e = self.parse_inner_value(r, val_t, tag, depth)
                    if e: return None, f"map value: {e}"
                    pairs.append({"key": k, "value": v})
                return pairs, None
            if t == "SetProperty":
                inner = self.read_fname(r)
                count = r.i32()
                items = []
                for _ in range(count):
                    v, e = self.parse_inner_value(r, inner, tag, depth)
                    if e: return None, f"set item: {e}"
                    items.append(v)
                return items, None
            if t == "StructProperty":
                return self.parse_struct(r, depth, tag), None
            return None, f"unhandled type {t}"
        except (EOFError, struct.error) as e:
            return None, str(e)

    def parse_inner_value(self, r: Reader, inner_type: str, tag: dict, depth: int):
        t = inner_type
        try:
            if t == "StructProperty":
                return self.parse_struct(r, depth), None
            if t in ("ObjectProperty", "WeakObjectProperty", "LazyObjectProperty",
                     "AssetObjectProperty", "InterfaceProperty"):
                return {"ref": self.ref_str(r.i32())}, None
            if t in ("SoftObjectProperty", "SoftClassProperty"):
                path = self.read_fname(r)
                sub = r.fstring()
                return {"path": path, "sub_path": sub or None}, None
            if t == "IntProperty": return r.i32(), None
            if t == "UInt32Property": return r.u32(), None
            if t == "Int64Property": return r.i64(), None
            if t == "UInt64Property": return r.u64(), None
            if t == "FloatProperty": return r.f32(), None
            if t == "DoubleProperty": return r.f64(), None
            if t == "NameProperty": return self.read_fname(r), None
            if t == "StrProperty": return r.fstring(), None
            if t == "ByteProperty":
                # array of enum-byte: each element stored as FName? be safe:
                # use tag size arithmetic is unavailable; try byte first via
                # caller validation. Use FName if enum_name present.
                if tag.get("enum_name") and tag["enum_name"] != "None":
                    return self.read_fname(r), None
                return r.u8(), None
            if t == "BoolProperty": return r.u8() != 0, None
            if t == "EnumProperty":
                enum = self.read_fname(r)
                return {"enum": enum, "value": r.u8()}, None
            if t == "TextProperty":
                return self.parse_text(r), None
            return None, f"unhandled inner type {t}"
        except (EOFError, struct.error) as e:
            return None, str(e)

    def parse_struct(self, r: Reader, depth: int, tag: dict | None = None):
        # struct type name comes from the tag in this engine's format
        if tag is not None and "struct_type" in tag:
            stype = tag["struct_type"]
            end = None if tag["size"] == 0 else tag["data_start"] + tag["size"]
        else:
            stype = self.read_fname(r)
            end = None
        if stype in ("Vector", "Rotator"):
            return {"_type": stype, "x": r.f32(), "y": r.f32(), "z": r.f32()}
        if stype == "Vector2D":
            return {"_type": stype, "x": r.f32(), "y": r.f32()}
        if stype == "Vector4":
            return {"_type": stype, "x": r.f32(), "y": r.f32(),
                    "z": r.f32(), "w": r.f32()}
        if stype == "LinearColor":
            return {"_type": stype, "r": r.f32(), "g": r.f32(),
                    "b": r.f32(), "a": r.f32()}
        if stype == "Color":
            b, g, rr, a = r.u8(), r.u8(), r.u8(), r.u8()
            return {"_type": stype, "r": rr, "g": g, "b": b, "a": a}
        if stype == "Guid":
            return {"_type": stype, "guid": r.raw(16).hex()}
        if stype == "IntPoint":
            return {"_type": stype, "x": r.i32(), "y": r.i32()}
        if stype == "IntVector":
            return {"_type": stype, "x": r.i32(), "y": r.i32(), "z": r.i32()}
        if stype in ("DateTime", "Timespan"):
            return {"_type": stype, "ticks": r.i64()}
        if stype == "Quat":
            return {"_type": stype, "x": r.f32(), "y": r.f32(),
                    "z": r.f32(), "w": r.f32()}
        if stype == "Transform":
            return {"_type": stype,
                    "rotation": {"x": r.f32(), "y": r.f32(), "z": r.f32(), "w": r.f32()},
                    "translation": {"x": r.f32(), "y": r.f32(), "z": r.f32()},
                    "scale3d": {"x": r.f32(), "y": r.f32(), "z": r.f32()}}
        # custom script struct: nested tagged property list (bounded by size)
        props = self.parse_property_list(r, depth, end=end)
        return {"_type": stype, "properties": props}

    def parse_text(self, r: Reader):
        flags = r.i32()
        history = r.i8()
        if history == -1:
            return {"flags": flags, "history": "None"}
        if history == 0:  # Base
            ns = r.fstring()
            key = r.fstring()
            src = r.fstring()
            return {"flags": flags, "history": "Base",
                    "namespace": ns, "key": key, "source": src}
        return {"flags": flags, "history": history,
                "_raw": None}


def parse_data_table(asset: UAsset, export_idx: int):
    e = asset.exports[export_idx]
    r = Reader(asset.d, e["serial_offset"])
    result = {"object_name": e["object_name"], "class": asset.ref_str(e["class_index"])}
    props = asset.parse_property_list(r)
    result["object_properties"] = props

    # UDataTable manual serialization: RowStruct ref + row count + rows
    row_struct = r.i32()
    result["row_struct"] = asset.ref_str(row_struct)
    row_count = r.i32()
    rows = []
    for i in range(row_count):
        row_name = asset.read_fname(r)
        row_props = asset.parse_property_list(r)
        rows.append({"row_name": row_name, "properties": row_props})
    result["row_count"] = row_count
    result["rows"] = rows
    return result


def props_to_dict(props: list[dict]) -> dict:
    out = {}
    for p in props:
        out[p["name"]] = simplify(p["value"])
    return out


def simplify(value):
    if isinstance(value, dict):
        if "_type" in value and "properties" in value:
            inner = props_to_dict(value["properties"])
            if set(inner) - {"_type"}:
                return {"_struct": value["_type"], **inner}
            return {"_struct": value["_type"]}
        if "ref" in value and len(value) == 1:
            return value["ref"]
    if isinstance(value, list):
        return [simplify(v) for v in value]
    return value


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("path")
    ap.add_argument("-o", "--output")
    ap.add_argument("--raw", action="store_true",
                    help="keep full property entries instead of simplified dict")
    args = ap.parse_args()

    data = Path(args.path).read_bytes()
    asset = UAsset(data)

    doc = {
        "_meta": {
            "file": Path(args.path).name,
            "file_size": len(data),
            "legacy_version": asset.legacy_version,
            "file_version_ue4": asset.file_version_ue4,
            "file_version_ue5": asset.file_version_ue5,
            "licensee_version": asset.licensee_version,
            "custom_versions": asset.custom_versions,
            "total_header_size": asset.total_header_size,
            "package_flags": asset.package_flags,
            "saved_by_engine": asset.saved_by_engine,
            "name_count": asset.name_count,
            "import_count": asset.import_count,
            "export_count": asset.export_count,
        },
    }

    # find DataTable-ish export (largest or class contains DataTable)
    dt_idx = None
    for i, e in enumerate(asset.exports):
        cls = asset.ref_str(e["class_index"]) or ""
        if "DataTable" in cls or "DataTable" in e["object_name"]:
            dt_idx = i
            break
    if dt_idx is None:
        dt_idx = max(range(len(asset.exports)),
                     key=lambda i: asset.exports[i]["serial_size"])

    table = parse_data_table(asset, dt_idx)
    if args.raw:
        doc["table"] = table
    else:
        rows = {}
        for row in table["rows"]:
            rows[row["row_name"]] = props_to_dict(row["properties"])
        row_struct = table["row_struct"]
        if row_struct is None:
            for p in table["object_properties"]:
                if p["name"] == "RowStructName":
                    row_struct = p["value"]
        doc["table"] = {
            "object_name": table["object_name"],
            "class": table["class"],
            "row_struct": row_struct,
            "row_count": table["row_count"],
            "rows": rows,
        }

    doc["imports"] = [
        {"path": asset.import_path(i), "class": f"{imp['class_package']}.{imp['class_name']}",
         "name": imp["object_name"]}
        for i, imp in enumerate(asset.imports)
    ]
    doc["exports"] = [
        {"name": e["object_name"], "class": asset.ref_str(e["class_index"]),
         "size": e["serial_size"]}
        for e in asset.exports
    ]
    if asset.warnings:
        doc["_warnings"] = asset.warnings

    out = json.dumps(doc, ensure_ascii=False, indent=2)
    if args.output:
        Path(args.output).write_text(out, encoding="utf-8")
        print(f"wrote {args.output} ({len(out)} chars)")
    else:
        print(out)


if __name__ == "__main__":
    main()
