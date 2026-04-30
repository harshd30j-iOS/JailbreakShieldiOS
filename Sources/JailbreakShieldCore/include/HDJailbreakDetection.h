//
//  HDJailbreakDetection.h
//  JailbreakShield
//
//  Created by Harsh Dwivedi
//  Copyright © 2026 Harsh Dwivedi. All rights reserved.
//
//  Consolidated from research across multiple production apps.
//  Covers: CarPro iOS, Bajaj Allianz Insurance Wallet, and custom additions [2026].
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HDSecurityBlockViewController.h"

NS_ASSUME_NONNULL_BEGIN

// ─────────────────────────────────────────────────────────────────
// MARK: - JailbreakCheckResult
// ─────────────────────────────────────────────────────────────────

/// Detailed result returned by comprehensiveCheck
@interface JailbreakCheckResult : NSObject

/// YES if any jailbreak indicator was found
@property (nonatomic, assign) BOOL isJailbroken;

/// Short code identifying which check triggered
/// e.g. "path", "dylib", "fork", "urlscheme", "shadow", "simulator"
@property (nonatomic, copy) NSString *triggerIdentifier;

/// Human-readable explanation of what was detected
@property (nonatomic, copy) NSString *reason;

@end


// ─────────────────────────────────────────────────────────────────
// MARK: - HDJailbreakDetection
// ─────────────────────────────────────────────────────────────────

@interface HDJailbreakDetection : NSObject


// ─────────────────────────────────────────
// MARK: - One-Line SDK Enforcement (Recommended)
// ─────────────────────────────────────────

/// ★ PRIMARY METHOD ★
/// Runs ALL checks (jailbreak + simulator + debugger).
/// If triggered: shows the built-in bypass-proof security block screen
/// with an Exit App button. The window cannot be dismissed.
/// Returns YES if the device was blocked.
///
/// Usage (ObjC): [HDJailbreakDetection enforceSecurityIn:window];
/// Usage (Swift): HDJailbreakDetection.enforceSecurity(in: window)
+ (BOOL)enforceSecurityIn:(UIWindow *)window;


// ─────────────────────────────────────────
// MARK: - Simulator Control
// ─────────────────────────────────────────

/// When YES (default): simulator is allowed through — no block shown.
/// When NO: simulator triggers the block screen (for UI testing).
@property (class, nonatomic, assign) BOOL simulatorBypassEnabled;

/// Returns YES if code is currently running on the iOS Simulator.
+ (BOOL)isRunningOnSimulator;


// ─────────────────────────────────────────
// MARK: - Basic Checks
// ─────────────────────────────────────────

/// Quick check — jailbreak paths + sandbox write test (fast, use for launch gate)
+ (BOOL)isJailbroken;

/// Full check — paths, dylibs, env, fork, URL schemes, filesystem flags
+ (BOOL)isDeviceJailbroken;

/// Runs both isJailbroken and isDeviceJailbroken
+ (BOOL)hasComprehensiveJailbreakCheck;


// ─────────────────────────────────────────
// MARK: - Comprehensive Check with Result
// ─────────────────────────────────────────

/// Runs ALL 10 checks. Returns a JailbreakCheckResult with trigger + reason.
/// Use this when you want to log or handle each case differently.
+ (JailbreakCheckResult *)comprehensiveCheck;


// ─────────────────────────────────────────
// MARK: - Granular Checks
// ─────────────────────────────────────────

/// 70+ known jailbreak file paths (Cydia, Sileo, Substrate, Dopamine, unc0ver, etc.)
+ (BOOL)hasJailbreakPaths;

/// Triple-layer file check: fopen + stat + access() on all jailbreak paths
+ (BOOL)hasAccessibleJailbreakFiles;

/// Attempt to write outside the app sandbox to /private/
+ (BOOL)canWriteOutsideSandbox;

/// 25+ suspicious dylibs at runtime (Substrate, Frida, FlyJB, Shadow, KernBypass etc.)
+ (BOOL)hasSuspiciousDylibsLoaded;

/// DYLD_INSERT_LIBRARIES environment variable check
+ (BOOL)hasDYLDEnvironmentInjection;

/// statvfs + statfs root filesystem mount flag check (should be read-only)
+ (BOOL)hasFilesystemMountedWritable;

/// Objective-C runtime check for Shadow jailbreak bypass tool
+ (BOOL)hasShadowJailbreakBypass;

/// fork() syscall — not permitted in sandboxed apps on clean devices
+ (BOOL)canFork;

/// Cydia, Sileo, Zbra, Filza, Dopamine, TrollStore URL scheme check
+ (BOOL)hasSuspiciousURLSchemes;

/// sysctl P_TRACED flag — detects if a debugger is attached
+ (BOOL)isBeingDebugged;


// ─────────────────────────────────────────
// MARK: - Debug Info
// ─────────────────────────────────────────

/// Returns a human-readable string listing all triggered checks.
/// Returns "Device is not jailbroken." on clean devices.
+ (NSString *)jailbreakDetectionDetails;

@end

NS_ASSUME_NONNULL_END
