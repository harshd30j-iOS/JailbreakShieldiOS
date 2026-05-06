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
            url: "https://github.com/harshd30j-iOS/JailbreakShieldiOS/releases/download/v1.0.0/JailbreakShield.xcframework.zip",
            checksum: "d158b09b483af1fbcc54606c22a3bf44913250b0bbd3ac91acaad86f25a347c6"
        )
    ]
)
