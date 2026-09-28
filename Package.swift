// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription
let checksum = "a89ef0bb3a13207eceb59ef798f97ae3af8071bd03108a0bae164256d5ff7a14"
let version = "26.9.25-mango.2"
let url = "https://github.com/kanzelsberger/matrix-rust-components-swift/releases/download/\(version)/MatrixSDKFFI.xcframework.zip"
let package = Package(
    name: "MatrixRustSDK",
    platforms: [
        .iOS(.v17),
        .macOS(.v15)
    ],
    products: [
        .library(name: "MatrixRustSDK", targets: ["MatrixRustSDK"]),
    ],
    targets: [
        .binaryTarget(name: "MatrixSDKFFI", url: url, checksum: checksum),
        .target(name: "MatrixRustSDK", dependencies: [.target(name: "MatrixSDKFFI")])
    ],
    // UniFFI async callback helpers currently require Swift 5 language mode.
    // Tools 6 is still needed to declare the macOS 15 deployment target.
    swiftLanguageModes: [.v5]
)
