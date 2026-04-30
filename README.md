**JailbreakShield 🛡️**

**iOS Security SDK --- Jailbreak Detection, Screen Protection &
Bypass-Proof Block Screen**

Created by **Harsh Dwivedi**\
Version: **1.2.0** \| Platform: **iOS 13+** \| Languages: **Objective-C
· Swift · SwiftUI**

**Why Use JailbreakShield?**

Banking apps, payment apps, and enterprise apps must protect themselves
from:

- **Jailbroken devices** --- where the iOS sandbox is broken and
  attackers can read memory, hook methods, and steal data

- **Screen recording attacks** --- where users or malware silently
  record the screen to capture PINs, card numbers, or OTPs

- **Screenshots** --- where sensitive data like payment screens or user
  info can be saved

- **Debuggers** --- where attackers attach lldb/Frida to inspect and
  modify app behaviour at runtime

- **Simulator abuse** --- where app logic is reverse-engineered by
  running it in the iOS Simulator

JailbreakShield handles all of the above in **one SDK with one method
call**.

**What It Does**

  ----------------------------------- -----------------------------------
  Feature                             Description

  🔍 Jailbreak Detection              10 layered checks covering 70+ file
                                      paths, dylibs, URL schemes, fork(),
                                      DYLD, filesystem flags

  📵 Screenshot Block                 Secure layer trick prevents real UI
                                      from appearing in saved screenshots

  🎥 Screen Recording Block           Detects UIScreen.isCaptured and
                                      covers the UI instantly

  🚫 Bypass-Proof Block Window        A UIWindow at maximum level that
                                      cannot be hidden, dismissed, or
                                      bypassed

  🖥️ Simulator Detection              Detects simulator at runtime ---
                                      toggleable for development

  🐛 Debugger Detection               Detects attached debuggers via
                                      sysctl P_TRACED flag
  ----------------------------------- -----------------------------------

**Files in the SDK**

JailbreakShield/\
├── JailbreakShield.h ← Umbrella header --- import ONLY this in ObjC\
├── JailbreakShield.swift ← Swift wrapper --- idiomatic Swift API\
├── HDJailbreakDetection.h ← Public ObjC API for jailbreak detection\
├── HDJailbreakDetection.m ← Implementation (compiled into binary)\
├── HDSecurityBlockViewController.h ← Block screen UI (used internally)\
├── HDSecurityBlockViewController.m ← Full-screen block UI with Exit
button\
├── HDSecurityBlockWindow.h ← Bypass-proof UIWindow (used internally)\
├── HDSecurityBlockWindow.m ← Cannot be hidden, dismissed, or lowered\
├── ScreenProtectionManager.h ← Public API for screen protection\
└── ScreenProtectionManager.m ← Screenshot + recording prevention

> **You only need to import JailbreakShield.h (ObjC) or import
> JailbreakShield (Swift).**\
> All internal files are included automatically.

**Integration**

**Option A --- Add Source Files Directly**

1.  Drag all 10 files into your Xcode project

2.  Make sure **\"Add to target\"** is checked for your app target

3.  Done --- no Podfile, no Package.swift needed

**Option B --- Swift Package Manager (Recommended for Teams)**

Add this to your Package.swift or via **Xcode → File → Add Package
Dependencies**:

// Package.swift\
.binaryTarget(\
name: \"JailbreakShield\",\
url:
\"https://github.com/harshd30j-iOS/JailbreakShieldiOS/releases/download/1.2.0/JailbreakShield.xcframework.zip\",\
checksum: \"your_checksum_here\" // get this by running: swift package
compute-checksum JailbreakShield.xcframework.zip\
)

**Quick Start --- One Method Does Everything**

This is the **recommended way** to use JailbreakShield.\
One call checks for jailbreak + debugger + simulator and shows the block
screen automatically.

**Objective-C**

// AppDelegate.m\
#import \<JailbreakShield/JailbreakShield.h\> // import the umbrella
header\
\
- (BOOL)application:(UIApplication \*)application\
didFinishLaunchingWithOptions:(NSDictionary \*)launchOptions {\
\
// STEP 1 --- Jailbreak + debugger + simulator check\
// If triggered: shows a full-screen block window with an Exit App
button.\
// The window sits at UIWindowLevel max and CANNOT be dismissed.\
// Returns YES if the app was blocked.\
\[HDJailbreakDetection enforceSecurityIn:self.window\];\
\
// STEP 2 --- Screenshot + screen recording protection\
// Call AFTER makeKeyAndVisible so the window layer is ready.\
\[\[ScreenProtectionManager sharedManager\]
setupProtectionForWindow:self.window\];\
\
return YES;\
}

**Swift (AppDelegate / SceneDelegate)**

// SceneDelegate.swift\
import JailbreakShield\
\
func scene(\_ scene: UIScene, willConnectTo session: UISceneSession,\
options: UIScene.ConnectionOptions) {\
\
guard let windowScene = scene as? UIWindowScene else { return }\
\
let window = UIWindow(windowScene: windowScene)\
window.rootViewController = UIStoryboard(name: \"Main\", bundle: nil)\
.instantiateInitialViewController()\
window.makeKeyAndVisible()\
self.window = window\
\
// STEP 1 --- Jailbreak + debugger + simulator enforcement\
// Shows bypass-proof block screen if any check fails.\
JailbreakShield.enforce(in: window)\
\
// STEP 2 --- Screenshot + screen recording protection\
JailbreakShield.screenProtection.setup(window: window)\
}

**SwiftUI**

// MyApp.swift\
import SwiftUI\
import JailbreakShield\
\
\@main\
struct MyApp: App {\
\
init() {\
// For SwiftUI --- JailbreakShield finds the key window automatically.\
// Call in init() before the first view appears.\
\
// STEP 1 --- Enforce security (jailbreak + debugger + simulator)\
JailbreakShield.enforce()\
\
// STEP 2 --- Screen protection\
// Note: In SwiftUI, the window is ready after a short delay.\
// Use onAppear in your root view for screen protection (see below).\
}\
\
var body: some Scene {\
WindowGroup {\
ContentView()\
}\
}\
}\
\
// ContentView.swift --- attach screen protection here for SwiftUI\
struct ContentView: View {\
var body: some View {\
HomeView()\
.onAppear {\
// Screen protection needs the window to be fully ready.\
// onAppear is the right place in SwiftUI.\
if let window = UIApplication.shared.connectedScenes\
.compactMap({ \$0 as? UIWindowScene })\
.flatMap({ \$0.windows })\
.first(where: { \$0.isKeyWindow }) {\
JailbreakShield.screenProtection.setup(window: window)\
}\
}\
}\
}

**Simulator Control**

By default, the **simulator is allowed through** so you can develop
normally.\
Set simulatorBypassEnabled = NO / false to test the block screen UI.

**Objective-C**

// Allow simulator (default --- use during development)\
\[HDJailbreakDetection setSimulatorBypassEnabled:YES\];\
\
// Block simulator --- shows \"Simulator Detected\" block screen\
// Use this to visually test the block screen UI\
\[HDJailbreakDetection setSimulatorBypassEnabled:NO\];\
\
// Check at runtime if running on simulator\
if (\[HDJailbreakDetection isRunningOnSimulator\]) {\
NSLog(@\"Running on simulator\");\
}

**Swift / SwiftUI**

// Allow simulator through (default)\
JailbreakShield.simulatorBypassEnabled = true\
\
// Test block screen on simulator\
JailbreakShield.simulatorBypassEnabled = false\
\
// Check at runtime\
if JailbreakShield.isSimulator {\
print(\"Running on simulator\")\
}

> ⚠️ Always keep simulatorBypassEnabled = YES/true before App Store
> submission.

**Individual Jailbreak Checks**

Use these when you want **custom handling** instead of the automatic
block screen.

**Objective-C**

#import \<JailbreakShield/JailbreakShield.h\>\
\
// Quick check --- paths + sandbox write (fastest, use for launch gate)\
if (\[HDJailbreakDetection isJailbroken\]) {\
// device is likely jailbroken\
}\
\
// Full check --- all 10 methods combined\
if (\[HDJailbreakDetection isDeviceJailbroken\]) {\
// comprehensive detection\
}\
\
// Comprehensive check with trigger details --- use for
logging/analytics\
JailbreakCheckResult \*result = \[HDJailbreakDetection
comprehensiveCheck\];\
if (result.isJailbroken) {\
NSLog(@\"Trigger: %@\", result.triggerIdentifier); // e.g. \"dylib\",
\"fork\", \"path\"\
NSLog(@\"Reason: %@\", result.reason); // human-readable explanation\
}\
\
// Individual granular checks --- use if you need to handle each case
differently\
BOOL paths = \[HDJailbreakDetection hasJailbreakPaths\]; // 70+ path
check\
BOOL files = \[HDJailbreakDetection hasAccessibleJailbreakFiles\]; //
fopen+stat+access\
BOOL sandbox = \[HDJailbreakDetection canWriteOutsideSandbox\]; //
sandbox escape\
BOOL dylibs = \[HDJailbreakDetection hasSuspiciousDylibsLoaded\]; //
Substrate/Frida\
BOOL dyld = \[HDJailbreakDetection hasDYLDEnvironmentInjection\]; //
DYLD_INSERT\
BOOL mount = \[HDJailbreakDetection hasFilesystemMountedWritable\]; //
rw root fs\
BOOL shadow = \[HDJailbreakDetection hasShadowJailbreakBypass\]; //
Shadow bypass tool\
BOOL canFork = \[HDJailbreakDetection canFork\]; // fork() allowed\
BOOL urlScheme = \[HDJailbreakDetection hasSuspiciousURLSchemes\]; //
Cydia/Sileo etc.\
BOOL debugger = \[HDJailbreakDetection isBeingDebugged\]; // lldb/Frida
attached\
\
// Human-readable summary of all triggers (great for crash reports /
logging)\
NSString \*details = \[HDJailbreakDetection
jailbreakDetectionDetails\];\
NSLog(@\"%@\", details);

**Swift**

import JailbreakShield\
\
// Quick check\
if JailbreakShield.isJailbroken { /\* block \*/ }\
\
// Full check\
if JailbreakShield.isDeviceJailbroken { /\* block \*/ }\
\
// Comprehensive result with trigger info\
let result = JailbreakShield.comprehensiveResult\
if result.isJailbroken {\
print(\"Trigger: \\(result.triggerIdentifier)\") // \"dylib\", \"fork\",
\"path\" etc.\
print(\"Reason: \\(result.reason)\")\
}\
\
// Individual checks\
let hasPaths = JailbreakShield.isJailbroken\
let hasDylibs = JailbreakShield.hasSuspiciousDylibs\
let hasDYLD = JailbreakShield.hasDYLDInjection\
let hasRwMount = JailbreakShield.hasWritableFilesystem\
let hasShadow = JailbreakShield.hasShadowBypass\
let hasSchemes = JailbreakShield.hasJailbreakURLSchemes\
let forkAllowed = JailbreakShield.canFork\
let isDebugged = JailbreakShield.isDebugged\
let isSim = JailbreakShield.isSimulator\
\
// Full details string for logging\
print(JailbreakShield.detectionDetails)

**SwiftUI --- Run Check and Show Custom Alert**

import SwiftUI\
import JailbreakShield\
\
struct ContentView: View {\
\@State private var showJailbreakAlert = false\
\@State private var jailbreakReason = \"\"\
\
var body: some View {\
HomeView()\
.onAppear {\
let result = JailbreakShield.comprehensiveResult\
if result.isJailbroken {\
jailbreakReason = result.reason\
showJailbreakAlert = true\
}\
}\
.alert(\"Security Violation\", isPresented: \$showJailbreakAlert) {\
Button(\"Exit App\", role: .destructive) { exit(0) }\
} message: {\
Text(jailbreakReason)\
}\
}\
}

**Screen Protection**

**How It Works**

  ----------------------------------- -----------------------------------
  Feature                             Mechanism

  **Screenshot Block**                UITextField(secureTextEntry: YES)
                                      wraps the window layer. iOS
                                      excludes secure layers from
                                      screenshots --- Photos saves a
                                      black screen or your custom blocked
                                      image.

  **Recording Block**                 Monitors UIScreen.isCaptured. When
                                      recording starts, a full-screen
                                      opaque overlay appears immediately.
                                      Disappears when recording stops.

  **Screenshot Flash**                When a screenshot is taken, a flash
                                      overlay briefly shows your blocked
                                      image over the real UI for extra
                                      protection.
  ----------------------------------- -----------------------------------

**Objective-C --- All Configurations**

#import \<JailbreakShield/JailbreakShield.h\>\
\
ScreenProtectionManager \*spm = \[ScreenProtectionManager
sharedManager\];\
\
// ── Configuration (set BEFORE calling setup) ────────────────────\
\
// Block screenshots (default: YES)\
spm.screenshotProtectionEnabled = YES;\
\
// Block screen recording (default: YES)\
spm.screenRecordingProtectionEnabled = YES;\
\
// Custom image shown in screenshots and during recording\
// Add \"Screenshot_blocked_Image\" to Assets.xcassets for automatic
loading\
// Or set your own:\
spm.blockedImage = \[UIImage imageNamed:@\"my_security_screen\"\];\
\
// ── Activate ────────────────────────────────────────────────────\
// Call AFTER makeKeyAndVisible\
\[spm setupProtectionForWindow:self.window\];\
\
\
// ── Runtime Controls ────────────────────────────────────────────\
\
// Temporarily allow screenshots (e.g. user wants to share content)\
\[spm allowScreenshotTemporarily\];\
// \... do share action \...\
\[spm reEnableScreenshotProtection\];\
\
// Check if someone is recording right now\
if (\[spm isScreenBeingRecorded\]) {\
NSLog(@\"Screen recording in progress --- be careful!\");\
}\
\
// Disable screenshot block only (recording still blocked)\
spm.screenshotProtectionEnabled = NO;\
\
// Disable recording block only (screenshots still blocked)\
spm.screenRecordingProtectionEnabled = NO;\
\
// Disable both --- NOT recommended for sensitive apps\
spm.screenshotProtectionEnabled = NO;\
spm.screenRecordingProtectionEnabled = NO;

**Swift --- All Configurations**

import JailbreakShield\
\
let spm = JailbreakShield.screenProtection //
ScreenProtectionManager.sharedManager()\
\
// ── Configuration ───────────────────────────────────────────────\
spm.screenshotProtectionEnabled = true // block screenshots\
spm.screenRecordingProtectionEnabled = true // block recording\
\
// Custom blocked image (optional --- defaults to
\"Screenshot_blocked_Image\" asset)\
spm.blockedImage = UIImage(named: \"my_security_screen\")\
\
// ── Activate ────────────────────────────────────────────────────\
spm.setup(window: window) // call after window is visible\
\
// ── Runtime Controls ────────────────────────────────────────────\
\
// Temporarily allow screenshots for a share sheet\
spm.allowScreenshotTemporarily()\
// \... share action \...\
spm.reEnableScreenshotProtection()\
\
// Check recording status\
if spm.isRecording {\
print(\"Recording detected\")\
}

**SwiftUI --- Screen Protection**

// In your root view\'s .onAppear (window must be ready)\
.onAppear {\
guard let window = UIApplication.shared.connectedScenes\
.compactMap({ \$0 as? UIWindowScene })\
.flatMap({ \$0.windows })\
.first(where: { \$0.isKeyWindow }) else { return }\
\
let spm = JailbreakShield.screenProtection\
spm.screenshotProtectionEnabled = true\
spm.screenRecordingProtectionEnabled = true\
spm.blockedImage = UIImage(named: \"Screenshot_blocked_Image\")\
spm.setup(window: window)\
}

**The Block Screen --- How It Cannot Be Bypassed**

When enforceSecurityIn: detects a threat, it creates a
HDSecurityBlockWindow.\
This is a custom UIWindow subclass with these anti-bypass protections:

✓ windowLevel = UIWindowLevelAlert + 10,000 → above all alerts,
keyboards, and system UI\
✓ setHidden: override → ignores any attempt to hide it\
✓ setWindowLevel: override → always resets to max level\
✓ resignKeyWindow override → immediately reclaims key window status\
✓ UIApplicationDidBecomeActiveNotification → re-asserts itself every
time app comes to foreground\
✓ Static retain (\_activeBlockWindow) → ARC can never release or
deallocate the window\
✓ isModalInPresentation = YES → prevents swipe-to-dismiss on iOS 13+\
✓ viewWillDisappear guard → re-presents itself if anything dismisses it\
✓ The ONLY exit is exit(0) via the Exit button

There is **no way** to dismiss this window from code or user
interaction.\
It cannot be covered by another window, an alert, or a system prompt.

**Detection Coverage**

**10 Layered Checks**

  ----------------------- --------------------------- -----------------------
  \#                      Check                       What It Catches

  1                       **70+ jailbreak file        Cydia, Sileo,
                          paths**                     MobileSubstrate, Frida,
                                                      unc0ver, Dopamine,
                                                      palera1n, checkra1n,
                                                      Electra

  2                       **Triple file access**      Hidden jailbreak files
                          (fopen + stat + access)     that evade
                                                      NSFileManager

  3                       **Sandbox write test**      App can write to
                                                      /private/ --- sandbox
                                                      is broken

  4                       **/Applications writable**  Root filesystem
                                                      protection is removed

  5                       **URL scheme check**        Cydia, Sileo, Zebra,
                                                      Filza, Dopamine,
                                                      TrollStore can be
                                                      opened

  6                       **30+ suspicious dylibs**   Substrate, Frida,
                                                      FlyJB, Shadow,
                                                      KernBypass, xCon
                                                      injected at runtime

  7                       **DYLD_INSERT_LIBRARIES**   Tweak injection via
                                                      environment variable

  8                       **Filesystem mount flags**  Root / is mounted
                                                      read-write via
                                                      statvfs + statfs

  9                       **Shadow bypass detection** ObjC runtime check for
                                                      ShadowRuleset class

  10                      **fork() syscall**          Sandboxed apps cannot
                                                      fork --- success means
                                                      jailbroken

  \+                      **Debugger detection**      sysctl P_TRACED flag
                                                      --- detects lldb and
                                                      Frida

  \+                      **Simulator detection**     SIMULATOR_DEVICE_NAME
                                                      env variable
  ----------------------- --------------------------- -----------------------

**Jailbreaks Specifically Detected**

- unc0ver · checkra1n · palera1n · Dopamine · Electra

- Cydia · Sileo · Zebra · Filza

- Frida / FridaGadget · Shadow bypass

- TrollStore · SSLKillSwitch2 · FlyJB · ABypass · KernBypass · xCon

**Screenshot Blocked Image**

Add an image named **Screenshot_blocked_Image** to your Assets.xcassets.

Recommended content:

- Your app logo

- Text: *\"Screenshot not permitted for security reasons\"*

- Brand colours

If no image is provided, screenshots and recordings show a **solid black
screen**.

**App Store Compliance**

> ⚠️ The fork() check (canFork) can cause App Store rejection if left
> in.

Before submitting to the App Store, either:

**Option A** --- Comment out the fork line in HDJailbreakDetection.m:

// Comment out before App Store submission:\
// pid_t pid = fork();

**Option B** --- The comprehensiveCheck and enforceSecurityIn: still
trigger\
on 9 other checks without fork() --- the app is still well-protected.

All other checks (hasJailbreakPaths, hasSuspiciousDylibsLoaded, etc.)
are fully App Store safe.

**Source Code Protection**

Your .m files contain the detection logic. To hide them from
competitors:

**Option 1 --- XCFramework Binary (Best)**

Compile to .xcframework and distribute only the binary + headers.\
No .m files are visible.

\# Build for device + simulator\
xcodebuild archive -scheme JailbreakShield -destination
\"generic/platform=iOS\" \\\
-archivePath build/ios.xcarchive SKIP_INSTALL=NO\
xcodebuild archive -scheme JailbreakShield -destination
\"generic/platform=iOS Simulator\" \\\
-archivePath build/sim.xcarchive SKIP_INSTALL=NO\
\
\# Create XCFramework\
xcodebuild -create-xcframework \\\
-framework
build/ios.xcarchive/Products/Library/Frameworks/JailbreakShield.framework
\\\
-framework
build/sim.xcarchive/Products/Library/Frameworks/JailbreakShield.framework
\\\
-output JailbreakShield.xcframework

**Option 2 --- Private Repo + Public Binary**

Keep .m source in a **private GitHub repo**.\
Push only the compiled .xcframework.zip to the public SPM repo.

**Option 3 --- git-crypt (Encrypt Source in Repo)**

brew install git-crypt\
git-crypt init\
\# .gitattributes:\
\*.m filter=git-crypt diff=git-crypt\
\*.h filter=git-crypt diff=git-crypt

Files are AES-256 encrypted. Only your machine with the key can decrypt.

**Troubleshooting**

  ----------------------------------- -----------------------------------
  Issue                               Fix

  Block screen shows on simulator     Set simulatorBypassEnabled = YES
                                      (it\'s YES by default)

  Screen protection not working       Call setupProtectionForWindow:
                                      AFTER makeKeyAndVisible

  Screenshots still saving            Make sure
                                      screenshotProtectionEnabled = YES
                                      before calling setup

  App Store warning about fork()      Comment out the fork() line in
                                      HDJailbreakDetection.m

  Block window not appearing          Ensure enforceSecurityIn: is called
                                      with a non-nil UIWindow

  Build error: missing                All 10 files must be in the same
  HDSecurityBlockWindow               target --- check target membership

  Swift can\'t find types             Import module: import
                                      JailbreakShield at top of file
  ----------------------------------- -----------------------------------

**License**

**Private --- Created by Harsh Dwivedi. All rights reserved.**\
Not for redistribution or commercial use without permission.
