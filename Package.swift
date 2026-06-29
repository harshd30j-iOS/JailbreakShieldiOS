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
            url: "https://github.com/harshd30j-iOS/JailbreakShieldiOS/releases/download/1.1.6/JailbreakShield.xcframework.zip",
            checksum: "708a2f8dd68a4ff63c20929bc30a9a940c8a86e24406586f49eb8a6b7bcccb97"
        )
    ]
)
