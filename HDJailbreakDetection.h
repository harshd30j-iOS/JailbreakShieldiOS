//
// HDJailbreakDetection.h
// JailbreakShield
//
// Created by Harsh Dwivedi
// Copyright © 2026 Harsh Dwivedi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "HDSecurityBlockViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JailbreakCheckResult : NSObject
@property (nonatomic, assign) BOOL isJailbroken;
@property (nonatomic, copy) NSString *triggerIdentifier;
@property (nonatomic, copy) NSString *reason;
@end

@interface HDJailbreakDetection : NSObject

+ (BOOL)enforceSecurityIn:(UIWindow *)window;

@property (class, nonatomic, assign) BOOL simulatorBypassEnabled;
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

@end

NS_ASSUME_NONNULL_END
