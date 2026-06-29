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
            url: "https://github.com/harshd30j-iOS/JailbreakShieldiOS/releases/download/1.1.5/JailbreakShield.xcframework.zip",
            checksum: "49f8d89c90db8812064a6a3496929f2b6ffbc75c5085c532bbda871a73d00dd0"
        )
    ]
)
