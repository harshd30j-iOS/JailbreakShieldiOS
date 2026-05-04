//
// HDJailbreakDetection.h
// JailbreakShield
//
// Created by Harsh Dwivedi
// Copyright © 2026 Harsh Dwivedi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <JailbreakShield/HDSecurityBlockViewController.h>

NS_ASSUME_NONNULL_BEGIN

@interface JailbreakCheckResult : NSObject
@property (nonatomic, assign) BOOL isJailbroken;
@property (nonatomic, copy) NSString *triggerIdentifier;
@property (nonatomic, copy) NSString *reason;
@end

@interface HDJailbreakDetection : NSObject

// ─────────────────────────────────────────
// MARK: - Primary Enforcement
// ─────────────────────────────────────────

/// Blocks jailbreak + simulator + debugger.
/// Shows built-in block screen with Exit button.
+ (BOOL)enforceSecurityIn:(UIWindow *)window;

/// ★ Auto finds window internally — no parameter needed.
/// Works in ObjC, Swift, and SwiftUI.
+ (BOOL)enforceSecurity;

/// ★ Attach screenshot + screen recording protection.
/// Finds the window automatically with retry logic.
/// Call once at app launch — no window parameter needed.
+ (void)enforceScreenProtection;

// ─────────────────────────────────────────
// MARK: - Simulator Control
// ─────────────────────────────────────────

@property (class, nonatomic, assign) BOOL simulatorBypassEnabled;
+ (BOOL)isRunningOnSimulator;

// ─────────────────────────────────────────
// MARK: - Individual Checks
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

@end

NS_ASSUME_NONNULL_END
