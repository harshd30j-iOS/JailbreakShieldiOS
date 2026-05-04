# JailbreakShield iOS SDK

A lightweight, drop-in security SDK for iOS apps. Detects jailbreak, simulator, debugger, screenshot, and screen recording — instantly blocks with a built-in full-screen UI. Just 2 lines of code.

## Requirements
- iOS 13.0+
- Xcode 14+
- Swift 5.0+ or Objective-C

## Installation
```swift
.package(url: "https://github.com/harshd30j-iOS/JailbreakShieldiOS.git", from: "6.2.1")
```

Or in Xcode: File → Add Package Dependencies → paste URL above

## Quick Start

### SwiftUI
```swift
import JailbreakShield

@main
struct MyApp: App {
    init() {
        HDJailbreakDetection.simulatorBypassEnabled = false
        HDJailbreakDetection.enforceSecurity()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    HDJailbreakDetection.enforceScreenProtection()
                }
        }
    }
}
```

### Swift UIKit
```swift
import JailbreakShield

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    HDJailbreakDetection.simulatorBypassEnabled = false
    HDJailbreakDetection.enforceSecurity()
    HDJailbreakDetection.enforceScreenProtection()
    return true
}
```

### Objective-C
```objc
#import <JailbreakShield/JailbreakShield.h>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    HDJailbreakDetection.simulatorBypassEnabled = NO;
    [HDJailbreakDetection enforceSecurity];
    [HDJailbreakDetection enforceScreenProtection];
    return YES;
}
```

## What It Blocks

- Jailbreak → Red block screen — Security Alert
- Simulator → Orange block screen — Simulator Detected
- Debugger → Red block screen — Debug Mode Detected
- Screen Recording → Blue block screen — Screen Recording Detected
- Screenshot → Purple block screen — Screenshot Blocked + banking layer trick (black in saved photo)

All screens have Exit App button and cannot be dismissed.

## API Reference

- HDJailbreakDetection.enforceSecurity() — blocks jailbreak + simulator + debugger
- HDJailbreakDetection.enforceScreenProtection() — blocks screenshot + screen recording
- HDJailbreakDetection.simulatorBypassEnabled — set false to block simulator
- HDJailbreakDetection.isJailbroken() — check without blocking
- HDJailbreakDetection.isRunningOnSimulator() — check without blocking
- ScreenProtectionManager.screenshotProtectionEnabled — enable/disable screenshot protection
- ScreenProtectionManager.screenRecordingProtectionEnabled — enable/disable screen recording protection

## Changelog

### v6.2.1
- Screenshot purple block screen with camera icon
- Banking layer trick — black image in saved screenshot
- Screen recording blue block screen
- UI centered, no scroll

### v6.2.0
- enforceSecurity() no window needed
- enforceScreenProtection() auto window detection
- Exit App button on all block screens

### v6.1.0
- Redesigned block screen UI
- XCFramework iOS + Simulator

## License
Copyright 2026 Harsh Dwivedi. All rights reserved.# JailbreakShield iOS SDK

Lightweight security SDK for iOS apps. Detects jailbreak, simulator, debugger, and screen recording — blocks with a built-in UI. No window parameter needed.

## Requirements
- iOS 13.0+
- Xcode 14+
- Swift or Objective-C

## Installation — Swift Package Manager

```swift
.package(url: "https://github.com/harshd30j-iOS/JailbreakShieldiOS.git", from: "6.2.0")
```

## Usage

### SwiftUI
```swift
import JailbreakShield

@main
struct MyApp: App {
    init() {
        HDJailbreakDetection.enforceSecurity()
        HDJailbreakDetection.enforceScreenProtection()
    }
    var body: some Scene {
        WindowGroup { ContentView() }
    }
}
```

### Swift (UIKit)
```swift
func application(_ application: UIApplication,
                 didFinishLaunchingWithOptions launchOptions: [...]?) -> Bool {
    HDJailbreakDetection.enforceSecurity()
    HDJailbreakDetection.enforceScreenProtection()
    return true
}
```

### Objective-C
```objc
- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [HDJailbreakDetection enforceSecurity];
    [HDJailbreakDetection enforceScreenProtection];
    return YES;
}
```

## What It Blocks

| Threat | Block Screen | Accent |
|---|---|---|
| Jailbreak | Security Alert | 🔴 Red |
| Simulator | Simulator Detected | 🟠 Orange |
| Debugger | Debug Mode Detected | 🔴 Red |
| Screen Recording | Screen Recording Detected | 🔵 Blue |

All screens include an **Exit App** button. Cannot be dismissed.

## Changelog
### v6.2.0
- `enforceSecurity()` — no window parameter needed
- `enforceScreenProtection()` — auto window detection with retry
- Screen recording → full block screen (blue accent)
- Exit App button on all block screens

### v6.1.0
- Redesigned centered block screen UI
- XCFramework iOS + Simulator
