// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "JailbreakShield",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "JailbreakShield", targets: ["JailbreakShield"])
    ],
    targets: [
        .target(
            name: "JailbreakShieldCore",
            path: "Sources/JailbreakShieldCore",
            publicHeadersPath: "include"
        ),
        .target(
            name: "JailbreakShield",
            dependencies: ["JailbreakShieldCore"],
            path: "Sources/JailbreakShield"
        )
    ]
)
