// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "JailbreakShield",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "JailbreakShield", targets: ["JailbreakShield"])
    ],
    targets: [
        .binaryTarget(
            name: "JailbreakShield",
            url: "https://github.com/harshd30j-iOS/JailbreakShieldiOS/releases/download/1.2.0/JailbreakShield.xcframework.zip",
            checksum: "PASTE_CHECKSUM_FROM_STEP_1_HERE"
        )
    ]
)
