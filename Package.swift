// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "JailbreakShield",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "JailbreakShield",
            targets: ["JailbreakShield"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "JailbreakShield",
            url: "https://github.com/harshd30j-iOS/JailbreakShieldiOS/releases/download/v1.0.1/JailbreakShield.xcframework.zip",
            checksum: "4c57af858e6684e9beb789f7c87f052c7ea9cff240a59054a96100273a43e28a"
        )
    ]
)
