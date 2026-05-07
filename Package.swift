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
            url: "https://github.com/harshd30j-iOS/JailbreakShieldiOS/releases/download/v1.0.2/JailbreakShield.xcframework.zip",
            checksum: "7a5c20d1babe7c0e60b87d2ce132285735266bfdecaa7f263d5d24dd44aa5055"
        )
    ]
)
