# JailbreakShield iOS SDK

A comprehensive jailbreak, debugger, and tamper detection framework for iOS.
Detects 30+ jailbreak indicators including Frida, TrollStore, RootHide, Dopamine, and modern rootless jailbreaks.

## Installation via Swift Package Manager

1. In Xcode go to **File → Add Package Dependencies**
2. Paste URL: `https://github.com/harshd30j-iOS/JailbreakShieldiOS`
3. Change dropdown to **Exact Version** → type `1.1.3`
4. Click **Add Package**
5. In Build Settings add Other Linker Flags: `-ObjC`

## Usage — Swift

```swift
import JailbreakShield

// One-liner in AppDelegate or SceneDelegate:
JailbreakShieldSDK.enforce()

// Enable screen recording + screenshot protection:
JailbreakShieldSDK.enforceScreenProtection()

// Optional: Receive detection events for analytics
JailbreakShieldSDK.onDetection = { trigger, reason in
    print("Security trigger: \(trigger) — \(reason)")
}

// Individual checks:
if JailbreakShieldSDK.isJailbroken {
    // handle jailbreak
}

if JailbreakShieldSDK.hasFridaServer {
    // handle Frida
}

// Bypass for testing on simulator:
JailbreakShieldSDK.simulatorBypassEnabled = true
JailbreakShieldSDK.debuggerBypassEnabled = true
```

## Usage — Objective-C

```objc
#import <JailbreakShield/HDJailbreakDetection.h>

// One-liner enforcement:
[HDJailbreakDetection enforceSecurity];

// Screen protection:
[HDJailbreakDetection enforceScreenProtection];

// Individual checks:
if ([HDJailbreakDetection isJailbroken]) {
    // handle jailbreak
}
```

## Available Checks

| Check | Description |
|---|---|
| `isJailbroken` | Composite check of all indicators |
| `isDebugged` | Detects attached debugger (sysctl P_TRACED) |
| `hasSuspiciousDylibs` | MobileSubstrate, Frida, Shadow, cynject |
| `hasDYLDInjection` | DYLD_INSERT_LIBRARIES injection |
| `hasWritableFilesystem` | Root filesystem mounted writable |
| `hasShadowBypass` | Shadow jailbreak bypass framework |
| `hasJailbreakURLSchemes` | cydia://, sileo://, dopamine:// |
| `canFork` | fork() succeeds (sandbox broken) |
| `hasFridaServer` | Frida server port 27042/27043 open |
| `hasFridaGadget` | Frida gadget dylib loaded |
| `hasRootHide` | RootHide/rootless bypass |
| `hasTrollStore` | TrollStore sideloading |
| `hasJailbreakSymlinks` | Jailbreak-related symlinks |
| `hasSuspiciousParent` | Non-standard parent process |
| `hasFrameworkAnomaly` | System framework method hooking |
| `hasModernJailbreak` | Dopamine, palera1n, etc. |
| `hasAnalysisTools` | Cycript, Frida, objection, lldb |
| `hasModifiedBinary` | Cracked/re-signed binary |

## License

Copyright © 2026 Harsh Dwivedi. All rights reserved.
