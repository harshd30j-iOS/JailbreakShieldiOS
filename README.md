# JailbreakShield 🛡️

**iOS Security Library — Jailbreak Detection & Screen Protection**

Created by **Harsh Dwivedi**
Version: 1.0.0 | Platform: iOS 13+ | Language: Objective-C

---

## What It Does

JailbreakShield provides two main features:

1. **Jailbreak Detection** — Detects 10+ types of jailbreak indicators
2. **Screen Protection** — Blocks screenshots and screen recording

---

## Files

```
JailbreakShield/
├── JailbreakShield.h            ← Umbrella header (import just this)
├── DTTJailbreakDetection.h      ← Public API for jailbreak detection
├── DTTJailbreakDetection.m      ← Full implementation (hidden in binary)
├── ScreenProtectionManager.h    ← Public API for screen protection
└── ScreenProtectionManager.m    ← Full implementation (hidden in binary)
```

---

## Integration

### Option A — Direct files (add to your project)
Drag all 5 files into your Xcode project.

### Option B — SPM Binary (recommended — hides source)
Add via Swift Package Manager using the XCFramework binary.

```swift
// Package.swift
.binaryTarget(
    name: "JailbreakShield",
    url: "https://github.com/YourUsername/JailbreakShield/releases/download/1.0.0/JailbreakShield.xcframework.zip",
    checksum: "your_checksum_here"
)
```

---

## Jailbreak Detection

### Import
```objc
#import <JailbreakShield/JailbreakShield.h>
// or
#import "DTTJailbreakDetection.h"
```

### Quick Check
```objc
if ([DTTJailbreakDetection isDeviceJailbroken]) {
    // block the app
}
```

### Recommended — Comprehensive Check with Details
```objc
JailbreakCheckResult *result = [DTTJailbreakDetection comprehensiveCheck];

if (result.isJailbroken) {
    NSLog(@"Blocked by: %@", result.triggerIdentifier);
    NSLog(@"Reason: %@", result.reason);
    // Show alert and exit
}
```

### AppDelegate Example
```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[ScreenProtectionManager sharedManager] setupProtectionForWindow:self.window];
    [self.window makeKeyAndVisible];

    if (TARGET_OS_SIMULATOR == 0) {
        JailbreakCheckResult *result = [DTTJailbreakDetection comprehensiveCheck];
        if (result.isJailbroken) {
            [self showJailbreakAlertWithReason:result.reason];
            return YES;
        }
    }

    // Normal app launch...
    return YES;
}

- (void)showJailbreakAlertWithReason:(NSString *)reason {
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:@"Security Violation"
        message:@"This app cannot run on a jailbroken device."
        preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction
        actionWithTitle:@"Close App"
        style:UIAlertActionStyleDestructive
        handler:^(UIAlertAction *action) { exit(0); }]];

    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}
```

---

## Screen Protection

### Import
```objc
#import "ScreenProtectionManager.h"
```

### Basic Setup (in AppDelegate)
```objc
// Both screenshot and recording protection ON by default
[[ScreenProtectionManager sharedManager] setupProtectionForWindow:self.window];
```

### Custom Configuration
```objc
ScreenProtectionManager *spm = [ScreenProtectionManager sharedManager];

// Enable/disable individual features
spm.screenshotProtectionEnabled      = YES;   // blocks screenshots
spm.screenRecordingProtectionEnabled = YES;   // blocks screen recording

// Custom blocked image (replace with your own)
spm.blockedImage = [UIImage imageNamed:@"my_blocked_image"];

[spm setupProtectionForWindow:self.window];
```

### Disable Screenshot Protection Only
```objc
ScreenProtectionManager *spm = [ScreenProtectionManager sharedManager];
spm.screenshotProtectionEnabled = NO;   // screenshots allowed
spm.screenRecordingProtectionEnabled = YES; // recording still blocked
[spm setupProtectionForWindow:self.window];
```

### Disable Screen Recording Protection Only
```objc
ScreenProtectionManager *spm = [ScreenProtectionManager sharedManager];
spm.screenshotProtectionEnabled = YES;  // screenshots blocked
spm.screenRecordingProtectionEnabled = NO; // recording allowed
[spm setupProtectionForWindow:self.window];
```

### Disable Both (not recommended)
```objc
ScreenProtectionManager *spm = [ScreenProtectionManager sharedManager];
spm.screenshotProtectionEnabled      = NO;
spm.screenRecordingProtectionEnabled = NO;
[spm setupProtectionForWindow:self.window];
```

### Temporarily Allow Screenshot (e.g. for share sheet)
```objc
[[ScreenProtectionManager sharedManager] allowScreenshotTemporarily];
// ... do your share action ...
[[ScreenProtectionManager sharedManager] reEnableScreenshotProtection];
```

### Check if Screen is Being Recorded
```objc
if ([[ScreenProtectionManager sharedManager] isScreenBeingRecorded]) {
    NSLog(@"Screen recording in progress");
}
```

---

## Checks Covered

| # | Check | Source |
|---|-------|--------|
| 1 | 70+ jailbreak file paths | CarPro + Bajaj Research |
| 2 | fopen / stat / access triple check | Bajaj Research |
| 3 | Sandbox write test | CarPro + Bajaj Research |
| 4 | /Applications writable | Bajaj Research |
| 5 | 10+ suspicious URL schemes | CarPro + Bajaj + New |
| 6 | 30+ suspicious dylib names | Bajaj + New |
| 7 | DYLD_INSERT_LIBRARIES env | Bajaj Research |
| 8 | Filesystem mount flags (statvfs/statfs) | Bajaj Research |
| 9 | Shadow jailbreak bypass (ObjC runtime) | Bajaj Research |
| 10 | fork() syscall detection | Bajaj Research |
| 11 | Modern tools: unc0ver, checkra1n, palera1n, Dopamine | **New (Harsh Dwivedi)** |

---

## Supported Jailbreaks Detected

- Cydia / Sileo / Zebra
- unc0ver
- checkra1n
- palera1n
- Dopamine
- Electra
- Frida / Frida Gadget
- Shadow bypass
- TrollStore
- SSLKillSwitch2
- FlyJB / ABypass

---

## Source Code Protection

To protect your `.m` source files from being seen:

**Option 1 — XCFramework Binary (SPM)**
Compile to `.xcframework` and distribute via SPM `binaryTarget`.
Only your `.h` headers are visible. `.m` files are compiled into binary.

**Option 2 — git-crypt (repo-level)**
```bash
brew install git-crypt
git-crypt init
# Add to .gitattributes:
*.m filter=git-crypt diff=git-crypt
*.h filter=git-crypt diff=git-crypt
```
Files are AES-256 encrypted in the repo. Only your machine (with the key) can decrypt.

**Option 3 — Private GitHub Repo + SPM Binary**
Keep source in a private repo. Only publish the compiled `.xcframework.zip` in a public repo for SPM.

---

## Screenshot Blocked Image

Add an image named `Screenshot_blocked_Image` to your project's `Assets.xcassets`.
This image appears in saved screenshots and during screen recordings.

Recommended: A plain screen with your logo and text like:
> "Screenshot not permitted for security reasons"

---

## Notes

- Simulator always returns `NO` for all jailbreak checks (safe to test in simulator)
- To test in simulator: temporarily change `TARGET_OS_SIMULATOR == 0` to `TARGET_OS_SIMULATOR == 1`
- Always revert before App Store submission
- `fork()` check may cause warnings in some Xcode versions — suppress with `#pragma`

---

## License

Private — Created by Harsh Dwivedi. All rights reserved.
Not for redistribution without permission.
