// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "JailbreakShield",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "JailbreakShield",
            targets: ["JailbreakShield"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "JailbreakShield",
            url: "https://github.com/harshd30j-iOS/JailbreakShieldiOS/releases/download/1.0.0/JailbreakShield.xcframework.zip",
            checksum: "d1b62303e98eab4be9ffaf1c25745f6dc414580e1f6b2980a8d4a1b319a1f623"
        )
    ]
)
