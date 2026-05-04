# JailbreakShield iOS SDK

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
