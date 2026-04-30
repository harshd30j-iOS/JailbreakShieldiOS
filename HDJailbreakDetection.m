//
// HDJailbreakDetection.m
// JailbreakShield
//
// Created by Harsh Dwivedi
// Copyright © 2026 Harsh Dwivedi. All rights reserved.
//

#import "HDJailbreakDetection.h"
#import "HDSecurityBlockWindow.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <dlfcn.h>
#import <sys/sysctl.h>
#import <sys/stat.h>
#import <sys/mount.h>
#import <sys/statvfs.h>
#include <unistd.h>
#include <mach-o/dyld.h>

#ifdef DEBUG
#define JSLog(fmt, ...) NSLog(@"[JailbreakShield] " fmt, ##__VA_ARGS__)
#else
#define JSLog(fmt, ...)
#endif

#pragma mark - JailbreakCheckResult

@implementation JailbreakCheckResult
@end

#pragma mark - HDJailbreakDetection

@implementation HDJailbreakDetection

#pragma mark - Simulator Bypass

static BOOL _simulatorBypassEnabled = YES;

+ (BOOL)simulatorBypassEnabled { return _simulatorBypassEnabled; }
+ (void)setSimulatorBypassEnabled:(BOOL)enabled { _simulatorBypassEnabled = enabled; }

+ (BOOL)isRunningOnSimulator {
    return [NSProcessInfo processInfo].environment[@"SIMULATOR_DEVICE_NAME"] != nil;
}

+ (BOOL)shouldSkipForSimulator {
    return [self isRunningOnSimulator] && _simulatorBypassEnabled;
}

#pragma mark - Path Lists

+ (NSArray<NSString *> *)allJailbreakPaths {
    return @[
        @"/bin/bash", @"/bin/sh",
        @"/usr/bin/ssh", @"/usr/sbin/sshd",
        @"/usr/libexec/ssh-keysign",
        @"/usr/libexec/sftp-server",
        @"/etc/ssh/sshd_config",
        @"/etc/apt", @"/var/log/apt", @"/var/cache/apt",
        @"/private/var/cache/apt/", @"/private/var/lib/apt",
        @"/private/var/lib/cydia", @"/var/lib/cydia",
        @"/usr/libexec/cydia/firmware.sh",
        @"/private/var/tmp/cydia.log",
        @"/Applications/Cydia.app",
        @"/Applications/Sileo.app",
        @"/etc/apt/sources.list.d/sileo.sources",
        @"/Library/MobileSubstrate/MobileSubstrate.dylib",
        @"/Library/MobileSubstrate/CydiaSubstrate.dylib",
        @"/Library/MobileSubstrate/DynamicLibraries",
        @"/usr/lib/ABDYLD.dylib", @"/usr/lib/ABSubLoader.dylib",
        @"/usr/lib/libcycript.dylib", @"/usr/lib/libjailbreak.dylib",
        @"/Applications/Zebra.app", @"/Applications/FlyJB.app",
        @"/Applications/Installer.app", @"/Applications/blackra1n.app",
        @"/usr/sbin/frida-server",
        @"/.bootstrapped_electra", @"/.installed_unc0ver",
        @"/jb/amfid_payload.dylib", @"/jb/libjailbreak.dylib",
        @"/jb/offsets.plist", @"/.cydia_no_stash",
        @"/var/jb/.installed_dopamine",
        @"/var/jb/usr/lib/libjailbreak.dylib",
        @"/var/jb/.installed_palera1n",
        @"/private/var/stash", @"/private/var/log/syslog",
        @"/var/lib/dpkg/info/mobilesubstrate.md5sums",
        @"/Library/BawAppie/ABypass",
    ];
}

+ (NSArray<NSString *> *)suspiciousDylibNames {
    return @[
        @"systemhook.dylib", @"SubstrateLoader.dylib",
        @"SSLKillSwitch2.dylib", @"SSLKillSwitch.dylib",
        @"MobileSubstrate.dylib", @"TweakInject.dylib",
        @"CydiaSubstrate", @"cynject", @"CustomWidgetIcons",
        @"PreferenceLoader", @"RocketBootstrap", @"WeeLoader",
        @"libhooker", @"SubstrateInserter", @"SubstrateBootstrap",
        @"ABypass", @"FlyJB", @"Substitute", @"Cephei", @"Electra",
        @"AppSyncUnified-FrontBoard.dylib", @"Shadow",
        @"FridaGadget", @"frida", @"libcycript",
        @"palera1n", @"Dopamine", @"unc0ver", @"TrollStore",
        @"libhooker.dylib", @"KernBypass", @"xCon",
    ];
}

+ (NSArray<NSString *> *)suspiciousURLSchemes {
    return @[
        @"cydia://", @"sileo://", @"zbra://", @"filza://",
        @"activator://", @"installer://", @"undecimus://",
        @"dopamine://", @"trollstore://", @"santa://",
    ];
}

#pragma mark - Primary Enforcement

+ (BOOL)enforceSecurityIn:(UIWindow *)window {
    if ([self isRunningOnSimulator]) {
        if (_simulatorBypassEnabled) {
            JSLog(@"Simulator detected — bypass enabled.");
            return NO;
        }
        JSLog(@"Simulator detected — bypass disabled, showing block.");
        [HDSecurityBlockWindow showWithReason:HDBlockReasonSimulator
                                      message:@"You are running this app on an iOS Simulator. This app is designed for real devices only."
                                  triggerCode:@"simulator"];
        return YES;
    }

    if ([self isBeingDebugged]) {
        JSLog(@"Debugger attached — blocking.");
        [HDSecurityBlockWindow showWithReason:HDBlockReasonDebugger
                                      message:@"A debugger has been detected. This app cannot run while being actively debugged."
                                  triggerCode:@"debugger"];
        return YES;
    }

    JailbreakCheckResult *result = [self comprehensiveCheck];
    if (result.isJailbroken) {
        JSLog(@"Jailbreak detected: %@ — %@", result.triggerIdentifier, result.reason);
        [HDSecurityBlockWindow showWithReason:HDBlockReasonJailbreak
                                      message:@"This app has detected that your device has been jailbroken or modified. For security reasons, the app cannot run on a compromised device."
                                  triggerCode:result.triggerIdentifier];
        return YES;
    }

    JSLog(@"✅ All security checks passed.");
    return NO;
}

#pragma mark - Basic API

+ (BOOL)isJailbroken {
    if ([self shouldSkipForSimulator]) return NO;
    return [self hasJailbreakPaths] ||
           [self canWriteOutsideSandbox] ||
           [self hasSuspiciousURLSchemes] ||
           [self hasSuspiciousDylibsLoaded];
}

+ (BOOL)isDeviceJailbroken {
    if ([self shouldSkipForSimulator]) return NO;
    return [self hasJailbreakPaths] ||
           [self hasAccessibleJailbreakFiles] ||
           [self canWriteOutsideSandbox] ||
           [self hasSuspiciousURLSchemes] ||
           [self hasSuspiciousDylibsLoaded] ||
           [self hasDYLDEnvironmentInjection] ||
           [self hasFilesystemMountedWritable] ||
           [self hasShadowJailbreakBypass] ||
           [self canFork];
}

+ (BOOL)hasComprehensiveJailbreakCheck {
    return [self isJailbroken] || [self isDeviceJailbroken];
}

#pragma mark - Comprehensive Check

+ (JailbreakCheckResult *)comprehensiveCheck {
    if ([self shouldSkipForSimulator]) {
        JailbreakCheckResult *r = [JailbreakCheckResult new];
        r.isJailbroken = NO;
        r.triggerIdentifier = @"simulator_bypassed";
        r.reason = @"Running on simulator — bypass enabled.";
        return r;
    }

    if ([self hasJailbreakPaths])
        return [self resultWithID:@"path" reason:@"Jailbreak indicator path detected"];
    if ([self hasAccessibleJailbreakFiles])
        return [self resultWithID:@"fileaccess" reason:@"Jailbreak file accessible via stat/access/fopen"];
    if ([self canWriteOutsideSandbox])
        return [self resultWithID:@"sandboxwrite" reason:@"App can write outside its sandbox"];
    if ([[NSFileManager defaultManager] isWritableFileAtPath:@"/Applications"])
        return [self resultWithID:@"appwrite" reason:@"/Applications directory is writable"];
    if ([self hasSuspiciousURLSchemes])
        return [self resultWithID:@"urlscheme" reason:@"Jailbreak app URL scheme is accessible"];
    if ([self hasSuspiciousDylibsLoaded])
        return [self resultWithID:@"dylib" reason:@"Suspicious dylib loaded at runtime"];
    if ([self hasDYLDEnvironmentInjection])
        return [self resultWithID:@"dyldenv" reason:@"DYLD_INSERT_LIBRARIES environment variable set"];
    if ([self hasFilesystemMountedWritable])
        return [self resultWithID:@"mountflag" reason:@"Root filesystem mounted as read-write"];
    if ([self hasShadowJailbreakBypass])
        return [self resultWithID:@"shadow" reason:@"Shadow jailbreak bypass tool detected"];
    if ([self canFork])
        return [self resultWithID:@"fork" reason:@"fork() syscall succeeded — sandbox violation"];

    JailbreakCheckResult *clean = [JailbreakCheckResult new];
    clean.isJailbroken = NO;
    clean.triggerIdentifier = @"none";
    clean.reason = @"Device appears clean.";
    return clean;
}

+ (JailbreakCheckResult *)resultWithID:(NSString *)identifier reason:(NSString *)reason {
    JailbreakCheckResult *r = [JailbreakCheckResult new];
    r.isJailbroken = YES;
    r.triggerIdentifier = identifier;
    r.reason = reason;
    JSLog(@"[DETECTED] %@ → %@", identifier, reason);
    return r;
}

#pragma mark - Granular Checks

+ (BOOL)hasJailbreakPaths {
    NSFileManager *fm = [NSFileManager defaultManager];
    for (NSString *path in [self allJailbreakPaths]) {
        if ([fm fileExistsAtPath:path]) {
            JSLog(@"Path found: %@", path);
            return YES;
        }
    }
    return NO;
}

+ (BOOL)hasAccessibleJailbreakFiles {
    for (NSString *path in [self allJailbreakPaths]) {
        const char *cPath = [path fileSystemRepresentation];
        FILE *f = fopen(cPath, "r");
        if (f) { fclose(f); JSLog(@"fopen: %@", path); return YES; }
        struct stat statbuf;
        if (stat(cPath, &statbuf) == 0) { JSLog(@"stat: %@", path); return YES; }
        if (access(cPath, R_OK) == 0) { JSLog(@"access: %@", path); return YES; }
    }
    return NO;
}

+ (BOOL)canWriteOutsideSandbox {
    NSString *testPath = @"/private/jb_shield_test.txt";
    NSError *error = nil;
    [@"test" writeToFile:testPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (!error) {
        [[NSFileManager defaultManager] removeItemAtPath:testPath error:nil];
        JSLog(@"Sandbox write succeeded — jailbroken.");
        return YES;
    }
    return NO;
}

+ (BOOL)hasSuspiciousURLSchemes {
    for (NSString *scheme in [self suspiciousURLSchemes]) {
        NSURL *url = [NSURL URLWithString:scheme];
        if (url && [[UIApplication sharedApplication] canOpenURL:url]) {
            JSLog(@"URL scheme open: %@", scheme);
            return YES;
        }
    }
    return NO;
}

+ (BOOL)hasSuspiciousDylibsLoaded {
    uint32_t count = _dyld_image_count();
    NSArray *suspects = [self suspiciousDylibNames];
    for (uint32_t i = 0; i < count; i++) {
        const char *name = _dyld_get_image_name(i);
        if (!name) continue;
        NSString *dylibPath = [NSString stringWithUTF8String:name];
        for (NSString *s in suspects) {
            if ([dylibPath containsString:s]) {
                JSLog(@"Suspicious dylib: %@", dylibPath);
                return YES;
            }
        }
    }
    return NO;
}

+ (BOOL)hasDYLDEnvironmentInjection {
    if ([NSProcessInfo processInfo].environment[@"DYLD_INSERT_LIBRARIES"]) {
        JSLog(@"DYLD_INSERT_LIBRARIES set.");
        return YES;
    }
    return NO;
}

+ (BOOL)hasFilesystemMountedWritable {
    const char *root = "/";
    struct statvfs svfs;
    if (statvfs(root, &svfs) == 0 && (svfs.f_flag & ST_RDONLY) == 0) {
        JSLog(@"statvfs: root is read-write.");
        return YES;
    }
    struct statfs sfs;
    if (statfs(root, &sfs) == 0 && (sfs.f_flags & MNT_RDONLY) == 0) {
        JSLog(@"statfs: root is read-write.");
        return YES;
    }
    return NO;
}

+ (BOOL)hasShadowJailbreakBypass {
    Class cls = objc_getClass("ShadowRuleset");
    SEL sel = NSSelectorFromString(@"internalDictionary");
    if (cls && class_getInstanceMethod(cls, sel)) {
        JSLog(@"Shadow bypass detected.");
        return YES;
    }
    return NO;
}

+ (BOOL)canFork {
    if ([self isRunningOnSimulator]) return NO;
    pid_t pid = fork();
    if (pid >= 0) {
        if (pid > 0) kill(pid, SIGKILL);
        JSLog(@"fork() succeeded — jailbroken.");
        return YES;
    }
    return NO;
}

+ (BOOL)isBeingDebugged {
    if ([self isRunningOnSimulator]) return NO;
    struct kinfo_proc info;
    memset(&info, 0, sizeof(info));
    size_t info_size = sizeof(info);
    int name[4] = { CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid() };
    if (sysctl(name, 4, &info, &info_size, NULL, 0) == 0) {
        return (info.kp_proc.p_flag & P_TRACED) != 0;
    }
    return NO;
}

#pragma mark - Debug Info

+ (NSString *)jailbreakDetectionDetails {
    if (![self isJailbroken]) return @"Device is not jailbroken.";
    NSMutableArray *reasons = [NSMutableArray array];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *checks = @{
        @"/Applications/Cydia.app":                    @"Cydia installed",
        @"/Applications/Sileo.app":                    @"Sileo installed",
        @"/Library/MobileSubstrate/MobileSubstrate.dylib": @"Mobile Substrate present",
        @"/bin/bash":                                  @"Shell access available",
        @"/usr/sbin/sshd":                             @"SSH daemon present",
        @"/etc/apt":                                   @"APT package manager found",
        @"/usr/sbin/frida-server":                     @"Frida server present",
        @"/.installed_unc0ver":                        @"unc0ver jailbreak",
        @"/var/jb/.installed_dopamine":                @"Dopamine jailbreak",
        @"/var/jb/.installed_palera1n":                @"palera1n jailbreak",
    };
    for (NSString *path in checks) {
        if ([fm fileExistsAtPath:path]) [reasons addObject:checks[path]];
    }
    if ([self canWriteOutsideSandbox]) [reasons addObject:@"Sandbox write possible"];
    if ([self hasSuspiciousDylibsLoaded]) [reasons addObject:@"Suspicious dylib loaded"];
    if ([self hasDYLDEnvironmentInjection]) [reasons addObject:@"DYLD injection detected"];
    if ([self hasFilesystemMountedWritable]) [reasons addObject:@"Root filesystem writable"];
    if ([self hasShadowJailbreakBypass]) [reasons addObject:@"Shadow bypass active"];
    if ([self canFork]) [reasons addObject:@"fork() succeeded"];
    return reasons.count > 0 ? [reasons componentsJoinedByString:@", "] : @"Unknown jailbreak method.";
}

@end
