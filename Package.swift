// swift-tools-version:5.3
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
            url: "https://github.com/harshd30j-iOS/JailbreakShieldiOS/releases/download/6.1.0/JailbreakShield-6.1.0.zip",
            checksum: "41ed2223125b0fd46ad084903cef1685101eca06a58bd541e7ff62abffb98661"
        )
    ]
)
