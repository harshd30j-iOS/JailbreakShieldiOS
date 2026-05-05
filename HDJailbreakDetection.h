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
// MARK: - Simulator Control
// ─────────────────────────────────────────

@property (class, nonatomic, assign) BOOL simulatorBypassEnabled;
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

/// Detect Frida server listening on default port 27042 or fallback 27043.
+ (BOOL)hasFridaServerRunning;

/// Detect Frida gadget / agent patterns beyond simple dylib name matching.
+ (BOOL)hasFridaGadgetSignature;

/// Detect RootHide-style rootless jailbreaks (/var/jb based).
+ (BOOL)hasRootHideIndicators;

/// Detect TrollStore and related app sideloading tools.
+ (BOOL)hasTrollStoreIndicators;

/// Check /etc/fstab, /etc/hosts, /var/lib/dpkg for suspicious symlinks.
+ (BOOL)hasJailbreakSymlinks;

/// Detect suspicious parent process (frida-server, gdb, lldb, cycript).
+ (BOOL)hasSuspiciousParentProcess;

/// Timing anomaly: bypass tools like Frida inject hooks that add micro-delays.
+ (BOOL)hasHookingTimingAnomaly;

/// Mach exception port check: a debugger sets task exception ports.
+ (BOOL)hasMachExceptionPortsSet;

/// Check for SSH daemon running locally on port 22 (jailbreak indicator).
+ (BOOL)hasSSHDaemonRunning;

/// Detect csops get-task-allow entitlement (set when app is re-signed for debug).
+ (BOOL)hasDebugEntitlementSet;

/// Detect if /System/Library frameworks are missing or abnormal (jailbreak tampering).
+ (BOOL)hasSystemFrameworkAnomaly;

/// Detect Dopamine, Checkra1n, unc0ver, Electra via unique file fingerprints.
+ (BOOL)hasModernJailbreakFingerprints;

/// Check for objection / cycript / LLDB process names in running process list.
+ (BOOL)hasAnalysisToolsRunning;

/// Check that the app binary has not been tampered with (basic Mach-O header verify).
+ (BOOL)hasModifiedBinary;

/// Deny debugger attach using PT_DENY_ATTACH (call once, early at launch).
/// This is separate from isBeingDebugged — it actively prevents future attachment.
+ (void)denyDebuggerAttach;

#pragma mark - Debugger Bypass

+ (BOOL)debuggerBypassEnabled;
+ (void)setDebuggerBypassEnabled:(BOOL)enabled;

@end

NS_ASSUME_NONNULL_END
