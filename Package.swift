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
            url: "https://github.com/harshd30j-iOS/JailbreakShieldiOS/releases/download/1.4.0/JailbreakShield-1.4.0.zip",
            checksum: "43a51bab66f5defb7ca4cf3164772b008f59209c1409ab460601cc6d41777c9a"
        )
    ]
)
