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
            checksum: "6aaba4533d7768206d4ef91f2e20297f3b9a25650d3cfbcbdda74cecd9be25b7"
        )
    ]
)
