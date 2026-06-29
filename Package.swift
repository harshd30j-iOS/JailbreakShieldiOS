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
            url: "https://github.com/harshd30j-iOS/JailbreakShieldiOS/releases/download/1.1.3/JailbreakShield.xcframework.zip",
            checksum: "1df9a3904199db78ea3de1cc67164cfd5c083e875e67de3bab79d69c5f5ef2d8"
        )
    ]
)
