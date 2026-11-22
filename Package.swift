// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription
let checksum = "b23fa0a04e5c82c154202921fc9fcf853a8f1a39eb34fe4619abea268e7bcfb0"
let version = "26.11.17-mango.1"
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
