#!/usr/bin/env python3
"""Build the standalone DimensiUI bundle directly from src/."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "src"
BUNDLE = ROOT / "dist" / "main.lua"


def module_path(file: Path) -> str:
    rel = file.relative_to(SRC).as_posix()[:-4]
    if rel == "init":
        return ""
    return rel[:-5] if rel.endswith("/init") else rel


def variable(path: str) -> str:
    return "__Node_Root" if not path else "__Node_" + re.sub(r"[^A-Za-z0-9_]", "_", path)


def main() -> None:
    original = BUNDLE.read_text(encoding="utf-8")
    first = re.search(r"(?m)^__DimensiModules\['([^']*)'\] = function\(script, require\)\n", original)
    if not first:
        raise RuntimeError("Bundle module markers were not found")
    suffix_match = re.search(r"(?m)^return __DimensiRequire\(__RootNode\)\s*$", original)
    if not suffix_match:
        raise RuntimeError("Bundle runtime footer was not found")

    files = sorted(SRC.rglob("*.lua"), key=lambda f: (module_path(f).count("/"), module_path(f)))
    modules = {module_path(file): file for file in files}
    if "" not in modules:
        raise RuntimeError("src/init.lua is required")

    folders = set()
    for path in modules:
        parts = path.split("/") if path else []
        for index in range(1, len(parts)):
            folders.add("/".join(parts[:index]))
    folders.update(path for path in modules if path and any(other.startswith(path + "/") for other in modules))

    node_lines = ["local __RootNode = __MakeNode(\"\", \"DimensiUI\", nil, true)"]
    all_paths = sorted(folders | {path for path in modules if path}, key=lambda p: (p.count("/"), p))
    for path in all_paths:
        parent = path.rpartition("/")[0]
        parent_var = "__RootNode" if not parent else variable(parent)
        name = path.rsplit("/", 1)[-1]
        is_module = "true" if path in modules else "false"
        node_lines.append(f"local {variable(path)} = __MakeNode('{path}', '{name}', {parent_var}, {is_module})")

    init_source = modules[""].read_text(encoding="utf-8")
    version_match = re.search(r'(?m)^\s*Version = "([0-9]+\.[0-9]+\.[0-9]+)",\s*$', init_source)
    if not version_match:
        raise RuntimeError("Library version metadata was not found in src/init.lua")
    version = version_match.group(1)

    prefix = original[:first.start()]
    prefix = re.sub(
        r"(?s)^--\[\[.*?\]\]\s*",
        f"--[[\n    DimensiUI v{version} (Bundled Single-File Build)\n    Standalone DimensiUI | Theme: Dimensi | Author: telatnakal\n]]\n\n",
        prefix,
        count=1,
    )
    root_start = prefix.find("local __RootNode = __MakeNode(")
    real_require = prefix.find("local __RealRequire", root_start)
    if root_start < 0 or real_require < 0:
        raise RuntimeError("Bundle node declaration section was not found")
    prefix = prefix[:root_start] + "\n".join(node_lines) + "\n\n\n\n" + prefix[real_require:]

    module_chunks = []
    for path, file in modules.items():
        source = file.read_text(encoding="utf-8").rstrip()
        module_chunks.append(f"__DimensiModules['{path}'] = function(script, require)\n{source}\nend\n")

    suffix = original[suffix_match.start():]
    BUNDLE.write_text(prefix + "\n".join(module_chunks) + "\n" + suffix, encoding="utf-8")
    print(f"Built dist/main.lua from {len(modules)} source modules")


if __name__ == "__main__":
    main()
