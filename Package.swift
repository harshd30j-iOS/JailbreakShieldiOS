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
            url: "https://github.com/harshd30j-iOS/JailbreakShieldiOS/releases/download/1.5.0/JailbreakShield-1.5.0.zip",
            checksum: "932665364f3f520d0b2151149e0d22f3a2cbadac473c7b4d1cb158592dc89431"
        )
    ]
)
