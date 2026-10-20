#!/usr/bin/env python3
"""Transform `cargo metadata` JSON (stdin) into a deterministic CycloneDX 1.5 SBOM.

Deterministic by construction: components sorted by purl, no timestamp/serial
number (so the committed file is reproducible and drift-checkable). The app name
is taken from $APPNAME. A component is marked external iff cargo reports a
`source` (i.e. it is not a local `path+file://` workspace crate).

Every component must carry a licence (mandate S4.8). A crate that names a
licence file instead of an SPDX expression (`license-file`, which is how RIINA's
own crates point at the custom LICENSE) is recorded with the SPDX
`LicenseRef-` form. A component with neither is an error, so an unlicensed
crate cannot slip into the committed SBOM.
"""
import json
import os
import sys

# SPDX form for the RIINA licence, whose text is the repository's LICENSE file.
CUSTOM_LICENSE_REF = "LicenseRef-RIINA-Proprietary"


def main() -> None:
    meta = json.load(sys.stdin)
    app = os.environ.get("APPNAME", "riina")
    packages = meta.get("packages", [])

    components = []
    unlicensed = []
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
        elif p.get("license_file"):
            comp["licenses"] = [{"license": {"name": CUSTOM_LICENSE_REF}}]
        else:
            unlicensed.append(name)
        components.append(comp)

    if unlicensed:
        sys.stderr.write(
            "SBOM: no licence for " + ", ".join(sorted(unlicensed))
            + " (set `license` or `license-file` in its Cargo.toml)\n"
        )
        sys.exit(1)

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
