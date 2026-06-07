#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <JailbreakShield/HDSecurityBlockViewController.h>

NS_ASSUME_NONNULL_BEGIN

/// Result object returned by `comprehensiveCheck`.
NS_SWIFT_NAME(JailbreakCheckResult)
@interface JailbreakCheckResult : NSObject
@property (nonatomic, assign) BOOL isJailbroken;
@property (nonatomic, copy) NSString *triggerIdentifier;
@property (nonatomic, copy) NSString *reason;
@end

/// Core jailbreak, debugger, and integrity detection engine.
///
/// **Swift users**: Prefer the `JailbreakShieldSDK` Swift enum for a cleaner API.
/// This ObjC class is fully accessible from Swift via `import JailbreakShield`.
NS_SWIFT_NAME(HDJailbreakDetection)
@interface HDJailbreakDetection : NSObject

// ─────────────────────────────────────────
// MARK: - Primary Enforcement
// ─────────────────────────────────────────

/// Blocks jailbreak + simulator + debugger. Shows built-in block screen.
/// @param window The window to present the block screen in (currently unused).
+ (BOOL)enforceSecurityIn:(UIWindow *)window
    NS_SWIFT_NAME(enforceSecurity(in:));

/// Auto-finds window internally. Works in ObjC, Swift, SwiftUI.
+ (BOOL)enforceSecurity;

/// Attach screenshot + screen recording protection. Call once at launch.
+ (void)enforceScreenProtection;

// ─────────────────────────────────────────
// MARK: - Bypasses for Testing
// ─────────────────────────────────────────

/// When YES (default), simulator devices are not flagged as jailbroken.
@property (class, nonatomic, assign) BOOL simulatorBypassEnabled;

/// When YES (default), attached debuggers are not flagged.
@property (class, nonatomic, assign) BOOL debuggerBypassEnabled;

// ─────────────────────────────────────────
// MARK: - Detection Callback
// ─────────────────────────────────────────

/// Optional callback fired whenever a jailbreak trigger is detected.
/// Parameters: (triggerIdentifier, humanReadableReason).
/// Set via `setOnDetectionHandler:` / read via `onDetectionHandler`.
@property (class, nonatomic, copy, nullable)
    void (^onDetection)(NSString *triggerIdentifier, NSString *reason);

+ (nullable void (^)(NSString *triggerIdentifier, NSString *reason))onDetectionHandler
    NS_SWIFT_NAME(onDetectionHandler());
+ (void)setOnDetectionHandler:(nullable void (^)(NSString *triggerIdentifier, NSString *reason))handler
    NS_SWIFT_NAME(setOnDetectionHandler(_:));

// ─────────────────────────────────────────
// MARK: - Device Info
// ─────────────────────────────────────────

+ (BOOL)isRunningOnSimulator;

// ─────────────────────────────────────────
// MARK: - Core Checks
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
// MARK: - Advanced Checks (v6.3.0)
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
