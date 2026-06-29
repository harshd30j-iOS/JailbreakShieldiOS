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
            url: "https://github.com/harshd30j-iOS/JailbreakShieldiOS/releases/download/1.1.8/JailbreakShield.xcframework.zip",
            checksum: "eb19ce3df9cce47c1b3f91cb7522ed8a6cadab444bd66dc0f3210100ff35007e"
        )
    ]
)
