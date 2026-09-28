"""Compile the assembled Swift package before publishing its remote binary URL."""

from pathlib import Path
import subprocess

manifest = Path("Package.swift")
original = manifest.read_text()
remote_target = '.binaryTarget(name: "MatrixSDKFFI", url: url, checksum: checksum)'
local_target = '.binaryTarget(name: "MatrixSDKFFI", path: "MatrixSDKFFI.xcframework")'
if original.count(remote_target) != 1:
    raise RuntimeError("Expected exactly one remote MatrixSDKFFI target")
try:
    manifest.write_text(original.replace(remote_target, local_target))
    subprocess.run(["swift", "build"], check=True)
finally:
    manifest.write_text(original)
