#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <JailbreakShield/HDSecurityBlockViewController.h>

NS_ASSUME_NONNULL_BEGIN

/// Result object returned by `comprehensiveCheck`.
NS_SWIFT_NAME(JailbreakCheckResult)
@interface HDS_c5 : NSObject
@property (nonatomic, assign) BOOL isJailbroken;
@property (nonatomic, copy)   NSString *triggerIdentifier;
@property (nonatomic, copy)   NSString *reason;
@end
@compatibility_alias JailbreakCheckResult HDS_c5;

/// Core jailbreak, debugger, and integrity detection engine.
///
/// **Swift users**: Prefer the `JailbreakShieldSDK` Swift enum for a cleaner API.
/// This ObjC class is fully accessible from Swift via `import JailbreakShield`.
NS_SWIFT_NAME(HDJailbreakDetection)
@interface HDS_c1 : NSObject
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new  NS_UNAVAILABLE;

+ (BOOL)enforceSecurityIn:(UIWindow *)window
    NS_SWIFT_NAME(enforceSecurity(in:))
    __attribute__((deprecated("window param unused; call enforceSecurity")));
+ (BOOL)enforceSecurity;
+ (void)enforceSecurityAsync:(void (^)(BOOL violated))completion;
+ (void)enforceScreenProtection;
+ (void)stopPeriodicChecks;

@property (class, nonatomic, assign) BOOL simulatorBypassEnabled;
@property (class, nonatomic, assign) BOOL debuggerBypassEnabled;
@property (class, nonatomic, copy, nullable) NSString *expectedBundleIdentifier;
@property (class, nonatomic, copy, nullable) NSString *customJailbreakMessage;
@property (class, nonatomic, copy, nullable) NSString *customScreenRecordingMessage;
@property (class, nonatomic, copy, nullable) NSString *customScreenshotMessage;
@property (class, nonatomic, copy, nullable) void (^exitHandler)(void);

@property (class, nonatomic, copy, nullable)
    void (^onDetection)(NSString *triggerIdentifier, NSString *reason);
+ (nullable void (^)(NSString *, NSString *))onDetectionHandler NS_SWIFT_NAME(onDetectionHandler());
+ (void)setOnDetectionHandler:(nullable void (^)(NSString *, NSString *))handler
    NS_SWIFT_NAME(setOnDetectionHandler(_:));

+ (BOOL)isJailbroken;
+ (BOOL)isDeviceJailbroken;
+ (BOOL)isJailbreakDetected NS_SWIFT_NAME(isJailbreakDetected());
+ (BOOL)hasComprehensiveJailbreakCheck;
+ (HDS_c5 *)comprehensiveCheck;

+ (BOOL)isRunningOnSimulator;
+ (BOOL)isBeingDebugged;
+ (BOOL)hasJailbreakPaths;
+ (BOOL)hasAccessibleJailbreakFiles;
+ (BOOL)canWriteOutsideSandbox;
+ (BOOL)hasSuspiciousDylibsLoaded;
+ (BOOL)hasDYLDEnvironmentInjection;
+ (BOOL)hasFilesystemMountedWritable;
+ (BOOL)hasShadowJailbreakBypass;
+ (BOOL)canFork;
+ (BOOL)hasSuspiciousURLSchemes;
+ (NSString *)jailbreakDetectionDetails;

// Advanced Checks (v6.3.0)
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
@compatibility_alias HDJailbreakDetection HDS_c1;

NS_ASSUME_NONNULL_END
