// swift-tools-version: 5.9
//
//  Package.swift
//  JailbreakShield
//
//  Created by Harsh Dwivedi
//  Copyright © 2026 Harsh Dwivedi. All rights reserved.
//
//  ─────────────────────────────────────────────────────────────────
//  TWO-TARGET STRUCTURE — Why?
//
//  Swift cannot see ObjC classes from the same SPM target unless
//  headers are in a special 'include' folder AND publicHeadersPath
//  is set. The cleanest solution is two separate targets:
//
//  JailbreakShieldCore  ← ObjC only (.h in include/ + .m files)
//  JailbreakShield      ← Swift only (imports JailbreakShieldCore)
//
//  This is the standard Apple-recommended pattern for mixed-language
//  Swift Packages. The consumer only imports 'JailbreakShield'.
//  ─────────────────────────────────────────────────────────────────
//
//  REQUIRED FOLDER STRUCTURE:
//
//  Sources/
//  ├── JailbreakShieldCore/
//  │   ├── include/                         ← ALL .h files go here
//  │   │   ├── JailbreakShield.h            (umbrella header)
//  │   │   ├── HDJailbreakDetection.h
//  │   │   ├── HDSecurityBlockViewController.h
//  │   │   ├── HDSecurityBlockWindow.h
//  │   │   └── ScreenProtectionManager.h
//  │   ├── HDJailbreakDetection.m           ← .m files stay here
//  │   ├── HDSecurityBlockViewController.m
//  │   ├── HDSecurityBlockWindow.m
//  │   └── ScreenProtectionManager.m
//  └── JailbreakShield/
//      └── JailbreakShield.swift            ← Swift wrapper only
//
//  ─────────────────────────────────────────────────────────────────

import PackageDescription

let package = Package(
    name: "JailbreakShield",
    platforms: [
        .iOS(.v13)   // iOS 13+ required for UIWindowScene, isCaptured etc.
    ],
    products: [
        // What consumers import: 'import JailbreakShield'
        // This exposes both ObjC + Swift APIs through one module.
        .library(
            name: "JailbreakShield",
            targets: ["JailbreakShield"]
        ),
    ],
    targets: [

        // ── Target 1: ObjC Core ──────────────────────────────────
        // Contains all .h and .m files.
        // publicHeadersPath: "include" exposes headers to Swift target.
        // DO NOT put Swift files here.
        .target(
            name: "JailbreakShieldCore",
            path: "Sources/JailbreakShieldCore",
            publicHeadersPath: "include",   // ← this makes ObjC visible to Swift
            cSettings: [
                // Silence deprecation warnings from legacy ObjC APIs
                .unsafeFlags(["-Wno-deprecated-declarations"])
            ]
        ),

        // ── Target 2: Swift Wrapper ──────────────────────────────
        // Contains only JailbreakShield.swift.
        // Depends on JailbreakShieldCore — so it can see all ObjC types.
        // 'import JailbreakShieldCore' at top of JailbreakShield.swift.
        .target(
            name: "JailbreakShield",
            dependencies: ["JailbreakShieldCore"],
            path: "Sources/JailbreakShield"
        ),

        // ── Test Target (optional) ───────────────────────────────
        // Uncomment if you add unit tests later.
        // .testTarget(
        //     name: "JailbreakShieldTests",
        //     dependencies: ["JailbreakShield"],
        //     path: "Tests/JailbreakShieldTests"
        // ),
    ]
)
