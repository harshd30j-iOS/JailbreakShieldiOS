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
            checksum: "d65c667e668a786085efb5d279679e5ae1c07121d6306af51db1f5d7ceb960a0"
        )
    ]
)
