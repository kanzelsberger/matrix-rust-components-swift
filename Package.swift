// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription
let checksum = "f4bb050399d3f91fbaa2b9d20529d4c055d5575d8391fbce36b1dd65e64a5a57"
let version = "26.9.7-mango.3"
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
    ]
)
