# JailbreakShield

**JailbreakShield** is a closed-source iOS security SDK that provides jailbreak detection and screen protection for your iOS application. It is distributed as a binary XCFramework — all internal implementation is compiled into the binary and is not accessible or readable by integrators.

> Built for iOS 13.0+ | Objective-C & Swift compatible | Distributed via Swift Package Manager

---

## What This SDK Does

JailbreakShield provides two core security features:

| Feature | Class | Purpose |
|---|---|---|
| Jailbreak Detection | `DTTJailbreakDetection` | Detects if the device is jailbroken using multiple layered checks |
| Screen Protection | `ScreenProtectionManager` | Prevents screenshots and screen recordings from capturing app content |

The SDK checks for modern jailbreak tools including Dopamine, palera1n, TrollStore, unc0ver, and others. Internal detection logic, file paths, and algorithm details are hidden inside the binary and are never exposed.

---

## Requirements

- iOS 13.0 or later
- Xcode 14 or later
- Swift Package Manager

---

## Installation

### Swift Package Manager (Recommended)

1. Open your project in Xcode
2. Go to **File → Add Package Dependencies**
3. Paste this URL in the search field:

```
https://github.com/harshd30j-iOS/JailbreakShieldiOS
```

4. Select version **1.0.0** (Up to Next Major Version)
5. Choose your app target under **Add to Project**
6. Click **Add Package**

---

## Usage

### Objective-C

Import the umbrella header at the top of your file:

```objc
#import <JailbreakShield/JailbreakShield.h>
```

### Swift

```swift
import JailbreakShield
```

---

## Jailbreak Detection

### Quick Check

Returns `YES`/`true` immediately if the device is jailbroken.

**Objective-C:**
```objc
if ([DTTJailbreakDetection isDeviceJailbroken]) {
    // Device is jailbroken — take action
    exit(0);
}
```

**Swift:**
```swift
if DTTJailbreakDetection.isDeviceJailbroken() {
    // Device is jailbroken — take action
}
```

---

### Comprehensive Check

Returns a detailed result object with the trigger identifier and human-readable reason. Recommended for production use.

**Objective-C:**
```objc
JailbreakCheckResult *result = [DTTJailbreakDetection comprehensiveCheck];

if (result.isJailbroken) {
    NSLog(@"Jailbreak detected");
    NSLog(@"Trigger: %@", result.triggerIdentifier);
    NSLog(@"Reason: %@", result.reason);
    // Block app access
}
```

**Swift:**
```swift
let result = DTTJailbreakDetection.comprehensiveCheck()

if result.isJailbroken {
    print("Trigger: \(result.triggerIdentifier ?? "")")
    print("Reason: \(result.reason ?? "")")
}
```

### JailbreakCheckResult Properties

| Property | Type | Description |
|---|---|---|
| `isJailbroken` | `BOOL` | `YES` if jailbreak was detected |
| `triggerIdentifier` | `NSString` | Internal identifier of the check that triggered |
| `reason` | `NSString` | Human-readable description of what was detected |

---

## Screen Protection

`ScreenProtectionManager` is a singleton that manages screenshot and screen recording protection for your app window.

### Setup

Call this once inside `application:didFinishLaunchingWithOptions:` in your AppDelegate.

**Objective-C:**
```objc
ScreenProtectionManager *manager = [ScreenProtectionManager sharedManager];
manager.screenshotProtectionEnabled = YES;
manager.screenRecordingProtectionEnabled = YES;
[manager setupProtectionForWindow:self.window];
```

**Swift:**
```swift
let manager = ScreenProtectionManager.shared()
manager.screenshotProtectionEnabled = true
manager.screenRecordingProtectionEnabled = true
manager.setupProtection(for: window)
```

---

### Individual Toggles

You can enable or disable screenshot and recording protection independently at any time.

```objc
// Disable only screenshot protection (allow screenshots)
manager.screenshotProtectionEnabled = NO;

// Keep recording protection active
manager.screenRecordingProtectionEnabled = YES;
```

---

### Temporary Screenshot Access

Use this when you need to allow a screenshot momentarily — for example, during a user-initiated share flow.

```objc
// Temporarily allow screenshots
[manager allowScreenshotTemporarily];

// Re-enable protection after your flow completes
[manager reEnableScreenshotProtection];
```

---

### Check if Screen is Being Recorded

```objc
if ([manager isScreenBeingRecorded]) {
    // Screen recording is active — warn user or restrict content
}
```

---

### Custom Blocked Image

You can provide a custom image to display when the screen is protected (instead of a blank screen).

```objc
manager.blockedImage = [UIImage imageNamed:@"screen_protected"];
```

---

## Recommended Integration — AppDelegate

Place all security checks at the earliest possible point in your app lifecycle.

**Objective-C:**
```objc
#import <JailbreakShield/JailbreakShield.h>

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Jailbreak check — run first
    JailbreakCheckResult *result = [DTTJailbreakDetection comprehensiveCheck];
    if (result.isJailbroken) {
        UIAlertController *alert = [UIAlertController
            alertControllerWithTitle:@"Security Alert"
            message:@"This device is not supported."
            preferredStyle:UIAlertControllerStyleAlert];
        // Show alert and prevent app from loading
        return YES;
    }

    // Screen protection
    ScreenProtectionManager *manager = [ScreenProtectionManager sharedManager];
    manager.screenshotProtectionEnabled = YES;
    manager.screenRecordingProtectionEnabled = YES;
    [manager setupProtectionForWindow:self.window];

    return YES;
}
```

---

## Public API Reference

### DTTJailbreakDetection

| Method | Return Type | Description |
|---|---|---|
| `+ isJailbroken` | `BOOL` | Basic jailbreak check |
| `+ isDeviceJailbroken` | `BOOL` | Alias for `isJailbroken` |
| `+ comprehensiveCheck` | `JailbreakCheckResult *` | Full multi-layered check with result details |

### JailbreakCheckResult

| Property | Type | Description |
|---|---|---|
| `isJailbroken` | `BOOL` | Detection result |
| `triggerIdentifier` | `NSString *` | Which check triggered |
| `reason` | `NSString *` | Human-readable reason |

### ScreenProtectionManager

| Method / Property | Type | Description |
|---|---|---|
| `+ sharedManager` | `instancetype` | Singleton accessor |
| `- setupProtectionForWindow:` | `void` | Initialise protection on a window |
| `screenshotProtectionEnabled` | `BOOL` | Toggle screenshot protection |
| `screenRecordingProtectionEnabled` | `BOOL` | Toggle recording protection |
| `- allowScreenshotTemporarily` | `void` | Temporarily lift screenshot block |
| `- reEnableScreenshotProtection` | `void` | Restore screenshot protection |
| `- isScreenBeingRecorded` | `BOOL` | Check active recording status |
| `blockedImage` | `UIImage *` | Custom image shown when blocked |

---

## Privacy

JailbreakShield does not collect, transmit, or store any user data. All checks run entirely on-device. No network requests are made.

---

## License

This SDK is proprietary and closed-source. The binary may be integrated into your iOS application. Reverse engineering, redistribution, or modification of the binary is prohibited.

© 2026 Harsh Dwivedi / Emotion Mobility. All rights reserved.
