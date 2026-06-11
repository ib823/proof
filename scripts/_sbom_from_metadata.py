#!/usr/bin/env python3
"""Transform `cargo metadata` JSON (stdin) into a deterministic CycloneDX 1.5 SBOM.

Deterministic by construction: components sorted by purl, no timestamp/serial
number (so the committed file is reproducible and drift-checkable). The app name
is taken from $APPNAME. A component is marked external iff cargo reports a
`source` (i.e. it is not a local `path+file://` workspace crate).
"""
import json
import os
import sys


def main() -> None:
    meta = json.load(sys.stdin)
    app = os.environ.get("APPNAME", "riina")
    packages = meta.get("packages", [])

    components = []
    external = 0
    for p in packages:
        name = p["name"]
        version = p["version"]
        is_external = bool(p.get("source"))
        if is_external:
            external += 1
        comp = {
            "type": "library",
            "bom-ref": f"pkg:cargo/{name}@{version}",
            "name": name,
            "version": version,
            "purl": f"pkg:cargo/{name}@{version}",
            "scope": "required",
            "properties": [
                {"name": "riina:origin", "value": "external" if is_external else "workspace"}
            ],
        }
        lic = p.get("license")
        if lic:
            comp["licenses"] = [{"license": {"name": lic}}]
        components.append(comp)

    components.sort(key=lambda c: c["purl"])

    bom = {
        "bomFormat": "CycloneDX",
        "specVersion": "1.5",
        "version": 1,
        "metadata": {
            "component": {"type": "application", "name": app},
            "properties": [
                {"name": "riina:totalComponents", "value": str(len(components))},
                {"name": "riina:externalComponents", "value": str(external)},
                {
                    "name": "riina:note",
                    "value": (
                        "Deterministic SBOM (no timestamp/serial). Regenerate: "
                        "bash scripts/generate-sbom.sh"
                    ),
                },
            ],
        },
        "components": components,
    }
    # Sorted keys + trailing newline ⇒ byte-stable output.
    json.dump(bom, sys.stdout, indent=2, sort_keys=True, ensure_ascii=False)
    sys.stdout.write("\n")


if __name__ == "__main__":
    main()
