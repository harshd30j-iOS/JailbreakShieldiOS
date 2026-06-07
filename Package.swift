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
            url: "https://github.com/harshd30j-iOS/JailbreakShieldiOS/releases/download/v1.0.6/JailbreakShield.xcframework.zip",
            checksum: "26cd5a6b2c72137d5e8c49563d1aa33e5762aec4112105c3d6f2ee008e936449"
        )
    ]
)
