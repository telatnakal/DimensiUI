#!/usr/bin/env python3
"""Regenerate src/BubbleIcon.lua from Assets/d-icon-bubble.png.

The bubble logo is embedded in the library as decimal-escaped bytes so it works without any
network request. Run this after replacing the PNG, then run build_bundle.py.
Use --check to verify that the embedded logo still matches the PNG (exit code 1 if not).
"""
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
PNG = ROOT / "Assets" / "d-icon-bubble.png"
TARGET = ROOT / "src" / "BubbleIcon.lua"
BYTES_PER_LINE = 64

HEADER = (
    '-- Logo "D" untuk bubble minimize (PNG 112x112, {size} bytes), tertanam supaya tidak butuh jaringan.\n'
    "-- Dibuat dari Assets/d-icon-bubble.png; PNG ini ditulis ke workspace executor lalu dimuat lewat getcustomasset.\n"
    "-- File ini dihasilkan oleh scripts/build_icon.py; jangan diedit manual.\n"
    "return table.concat({\n"
)


def render() -> str:
    data = PNG.read_bytes()
    lines = []
    for index in range(0, len(data), BYTES_PER_LINE):
        chunk = data[index:index + BYTES_PER_LINE]
        lines.append('\t"' + "".join(f"\\{byte:03d}" for byte in chunk) + '",\n')
    return HEADER.replace("{size}", str(len(data))) + "".join(lines) + "})\n"


def main() -> int:
    output = render()
    if "--check" in sys.argv:
        if TARGET.read_text(encoding="utf-8") != output:
            print("FAIL: src/BubbleIcon.lua does not match Assets/d-icon-bubble.png (run scripts/build_icon.py)")
            return 1
        print("OK: src/BubbleIcon.lua matches Assets/d-icon-bubble.png")
        return 0
    TARGET.write_text(output, encoding="utf-8")
    print(f"Wrote src/BubbleIcon.lua ({PNG.stat().st_size} byte PNG)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
