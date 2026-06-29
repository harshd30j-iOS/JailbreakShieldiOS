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
            url: "https://github.com/harshd30j-iOS/JailbreakShieldiOS/releases/download/1.1.2/JailbreakShield.xcframework.zip",
            checksum: "a8b89f79c84054e8ae1d8230d6bdf86afdb8d9e0202683a444abf0b70a426d9a"
        )
    ]
)
