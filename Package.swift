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
            url: "https://github.com/harshd30j-iOS/JailbreakShieldiOS/releases/download/1.1.1/JailbreakShield.xcframework.zip",
            checksum: "0659bfbc40f58fc9bb1870ae7af961fa4ce49ef0cb1121a1c46ede480712232e"
        )
    ]
)
