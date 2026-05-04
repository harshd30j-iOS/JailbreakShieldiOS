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
            url: "https://github.com/harshd30j-iOS/JailbreakShieldiOS/releases/download/6.2.0/JailbreakShield-6.2.0.zip",
            checksum: "8af527a49d0aeb599348ad3fa62ad7bbaffd77812aac671ede44f94208eaa937"
        )
    ]
)
