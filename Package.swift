// swift-tools-version:5.7
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
            url: "https://github.com/harshd30j-iOS/JailbreakShieldiOS/releases/download/1.1.0/JailbreakShield.xcframework.zip",
            checksum: "206c712371e491054b451ae54de04754c53b943d36d47f541b39f9dddb7e3ab8"
        )
    ]
)
