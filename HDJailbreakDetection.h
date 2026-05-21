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

+ (BOOL)enforceSecurityIn:(UIWindow *)window;
+ (BOOL)enforceSecurity;
+ (void)enforceScreenProtection;

@property (class, nonatomic, assign) BOOL simulatorBypassEnabled;
@property (class, nonatomic, assign) BOOL debuggerBypassEnabled;

@property (class, nonatomic, copy, nullable)
    void (^onDetection)(NSString *triggerIdentifier, NSString *reason);

+ (nullable void (^)(NSString *triggerIdentifier, NSString *reason))onDetectionHandler;
+ (void)setOnDetectionHandler:(nullable void (^)(NSString *triggerIdentifier, NSString *reason))handler;

+ (BOOL)isRunningOnSimulator;

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
