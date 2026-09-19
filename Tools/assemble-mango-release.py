import hashlib
import os
from pathlib import Path
import plistlib
import re
import shutil
import subprocess

artifacts = Path('artifacts')
libraries = {}
for target in artifacts.iterdir():
    framework = target / 'MatrixSDKFFI.xcframework'
    info = plistlib.loads((framework / 'Info.plist').read_bytes())
    entry = info['AvailableLibraries'][0]
    directory = framework / entry['LibraryIdentifier']
    libraries[target.name] = (directory / entry['LibraryPath'], directory / entry['HeadersPath'])

groups = {
    'macos': ['aarch64-apple-darwin', 'x86_64-apple-darwin'],
    'ios': ['aarch64-apple-ios'],
    'simulator': ['aarch64-apple-ios-sim', 'x86_64-apple-ios'],
}
command = ['xcodebuild', '-create-xcframework']
for platform, targets in groups.items():
    directory = Path('assembled') / platform
    directory.mkdir(parents=True, exist_ok=True)
    library = directory / 'libmatrix_sdk_ffi.a'
    subprocess.run(['lipo', '-create', *(str(libraries[t][0]) for t in targets), '-output', str(library)], check=True)
    command += ['-library', str(library), '-headers', str(libraries[targets[0]][1])]
command += ['-output', 'MatrixSDKFFI.xcframework']
subprocess.run(command, check=True)
subprocess.run(['ditto', '-c', '-k', '--sequesterRsrc', '--keepParent', 'MatrixSDKFFI.xcframework', 'MatrixSDKFFI.xcframework.zip'], check=True)

sources = Path('Sources/MatrixRustSDK')
shutil.rmtree(sources)
shutil.copytree(artifacts / 'aarch64-apple-darwin' / 'swift', sources)
checksum = hashlib.sha256(Path('MatrixSDKFFI.xcframework.zip').read_bytes()).hexdigest()
manifest = Path('Package.swift')
text = manifest.read_text().replace('// swift-tools-version:5.7', '// swift-tools-version:6.0')
text = re.sub(r'let checksum = ".*"', f'let checksum = "{checksum}"', text)
text = re.sub(r'let version = ".*"', f'let version = "{os.environ["RELEASE_VERSION"]}"', text)
text = text.replace('github.com/matrix-org/', 'github.com/kanzelsberger/')
text = text.replace('.iOS(.v16)', '.iOS(.v17)').replace('.macOS(.v12)', '.macOS(.v15)')
manifest.write_text(text)
