//
//  DTTJailbreakDetection.h
//  JailbreakShield
//
//  Created by Harsh Dwivedi
//  Copyright © 2026 Harsh Dwivedi. All rights reserved.
//
//  Consolidated from research across multiple production apps.
//  Covers: CarPro iOS, Bajaj Allianz Insurance Wallet, and custom additions.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// Result model returned by comprehensive check
@interface JailbreakCheckResult : NSObject

/// YES if jailbreak was detected
@property (nonatomic, assign) BOOL isJailbroken;

/// Short identifier of which check triggered (e.g. "dylib", "path", "fork", "env")
@property (nonatomic, copy) NSString *triggerIdentifier;

/// Human-readable reason string
@property (nonatomic, copy) NSString *reason;

@end


@interface DTTJailbreakDetection : NSObject

// ─────────────────────────────────────────
// MARK: - Basic Checks
// ─────────────────────────────────────────

/// Quick single check — path + sandbox write test
+ (BOOL)isJailbroken;

/// Full consolidated check — paths, dylibs, env, fork, URL schemes, filesystem flags
+ (BOOL)isDeviceJailbroken;

// ─────────────────────────────────────────
// MARK: - Comprehensive Check (Recommended)
// ─────────────────────────────────────────

/// Runs ALL checks and returns detailed result object
+ (JailbreakCheckResult *)comprehensiveCheck;

/// YES if any check from isJailbroken OR isDeviceJailbroken triggers
+ (BOOL)hasComprehensiveJailbreakCheck;

// ─────────────────────────────────────────
// MARK: - Granular Checks
// ─────────────────────────────────────────

/// Check for suspicious dylibs injected at runtime (Substrate, Frida, FlyJB, Shadow etc.)
+ (BOOL)hasSuspiciousDylibsLoaded;

/// Check DYLD_INSERT_LIBRARIES environment variable
+ (BOOL)hasDYLDEnvironmentInjection;

/// Check if filesystem is mounted read-write (should be read-only on clean device)
+ (BOOL)hasFilesystemMountedWritable;

/// Detect Shadow jailbreak bypass tool via ObjC runtime
+ (BOOL)hasShadowJailbreakBypass;

/// Check if fork() succeeds — not allowed in sandboxed apps on clean device
+ (BOOL)canFork;

/// Check suspicious URL schemes (Cydia, Sileo, Zbra, Filza, Installer etc.)
+ (BOOL)hasSuspiciousURLSchemes;

/// Check presence of jailbreak indicator files/paths
+ (BOOL)hasJailbreakPaths;

/// Attempt write outside sandbox
+ (BOOL)canWriteOutsideSandbox;

/// Check stat/access/fopen on jailbreak paths (triple-layer file check)
+ (BOOL)hasAccessibleJailbreakFiles;

// ─────────────────────────────────────────
// MARK: - Debug Info
// ─────────────────────────────────────────

/// Returns human-readable string describing what was detected
+ (NSString *)jailbreakDetectionDetails;

@end

NS_ASSUME_NONNULL_END
