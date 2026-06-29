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
            url: "https://github.com/harshd30j-iOS/JailbreakShieldiOS/releases/download/1.1.0/JailbreakShield.xcframework.zip",
            checksum: "4df0015bdbc3d2e067e9a1db25ab2b1a1e2a9d6badd8c6fb3405f792f324bbee"
        )
    ]
)
