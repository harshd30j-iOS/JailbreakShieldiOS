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
            url: "https://github.com/harshd30j-iOS/JailbreakShieldiOS/releases/download/v1.0.3/JailbreakShield.xcframework.zip",
            checksum: "bc7f8897ebbc01543df9786d2cd43b559bfe41dfe3d605a4787f4a6df1e610cf"
        )
    ]
)
