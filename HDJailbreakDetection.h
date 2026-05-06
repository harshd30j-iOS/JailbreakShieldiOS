//
// HDJailbreakDetection.h
// JailbreakShield
//
// Created by Harsh Dwivedi
// Copyright © 2026 Harsh Dwivedi. All rights reserved.
//
// v6.3.0 — Enhanced with 15 new detection layers:
//   Anti-Frida, timing anomaly, Mach exception ports, PT_DENY_ATTACH,
//   RootHide/rootless, TrollStore, symlink analysis, parent process,
//   SSH port probe, csops entitlement, binary integrity, and more.
//

//
// HDJailbreakDetection.h
// JailbreakShield
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <JailbreakShield/HDSecurityBlockViewController.h>

NS_ASSUME_NONNULL_BEGIN

@interface JailbreakCheckResult : NSObject
@property (nonatomic, assign) BOOL isJailbroken;
@property (nonatomic, copy)   NSString *triggerIdentifier;
@property (nonatomic, copy)   NSString *reason;
@end

@interface HDJailbreakDetection : NSObject

// ─────────────────────────────────────────
// MARK: - Primary Enforcement
// ─────────────────────────────────────────

/// Blocks jailbreak + simulator + debugger. Shows built-in block screen.
+ (BOOL)enforceSecurityIn:(UIWindow *)window;

/// ★ Auto-finds window internally. Works in ObjC, Swift, SwiftUI.
+ (BOOL)enforceSecurity;

/// ★ Attach screenshot + screen recording protection. Call once at launch.
+ (void)enforceScreenProtection;

// ─────────────────────────────────────────
// MARK: - Bypasses for Testing
// ─────────────────────────────────────────
// Swift will read both of these perfectly now!
@property (class, nonatomic, assign) BOOL simulatorBypassEnabled;
@property (class, nonatomic, assign) BOOL debuggerBypassEnabled;

+ (BOOL)isRunningOnSimulator;

// ─────────────────────────────────────────
// MARK: - Core Checks (Original)
// ─────────────────────────────────────────

+ (BOOL)isJailbroken;
+ (BOOL)isDeviceJailbroken;
+ (BOOL)hasComprehensiveJailbreakCheck;
+ (JailbreakCheckResult *)comprehensiveCheck;

+ (BOOL)hasJailbreakPaths;
+ (BOOL)hasAccessibleJailbreakFiles;
+ (BOOL)canWriteOutsideSandbox;
+ (BOOL)hasSuspiciousDylibsLoaded;
+ (BOOL)hasDYLDEnvironmentInjection;
+ (BOOL)hasFilesystemMountedWritable;
+ (BOOL)hasShadowJailbreakBypass;
+ (BOOL)canFork;
+ (BOOL)hasSuspiciousURLSchemes;
+ (BOOL)isBeingDebugged;
+ (NSString *)jailbreakDetectionDetails;

// ─────────────────────────────────────────
// MARK: - New Checks (v6.3.0)
// ─────────────────────────────────────────

+ (BOOL)hasFridaServerRunning;
+ (BOOL)hasFridaGadgetSignature;
+ (BOOL)hasRootHideIndicators;
+ (BOOL)hasTrollStoreIndicators;
+ (BOOL)hasJailbreakSymlinks;
+ (BOOL)hasSuspiciousParentProcess;
+ (BOOL)hasHookingTimingAnomaly;
+ (BOOL)hasMachExceptionPortsSet;
+ (BOOL)hasTamperedHostsFile;
+ (BOOL)hasValidBundleIdentifier;
+ (BOOL)hasSSHDaemonRunning;
+ (BOOL)hasDebugEntitlementSet;
+ (BOOL)hasSystemFrameworkAnomaly;
+ (BOOL)hasModernJailbreakFingerprints;
+ (BOOL)hasAnalysisToolsRunning;
+ (BOOL)hasModifiedBinary;
+ (void)denyDebuggerAttach;
+ (void)enforceLogSuppression;

@end

NS_ASSUME_NONNULL_END
