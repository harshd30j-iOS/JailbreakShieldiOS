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
            url: "https://github.com/harshd30j-iOS/JailbreakShieldiOS/releases/download/v1.0.5/JailbreakShield.xcframework.zip",
            checksum: "425e12cbbdd4fdd5ac573c4d294c234acaf432dcbb26fe9a3ec486e94482a128"
        )
    ]
)
