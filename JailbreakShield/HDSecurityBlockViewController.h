//
//  HDSecurityBlockViewController.h
//  JailbreakShield
//
//  Created by Harsh Dwivedi
//  Copyright © 2026 Harsh Dwivedi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// The type of security violation detected
typedef NS_ENUM(NSInteger, HDBlockReason) {
    HDBlockReasonJailbreak,   // Device is jailbroken
    HDBlockReasonSimulator,   // Running on simulator
    HDBlockReasonDebugger,    // Debugger is attached
};

/// Full-screen security block UI — built into the SDK.
/// Do NOT present directly. Use HDJailbreakDetection.enforceSecurityIn: instead.
@interface HDSecurityBlockViewController : UIViewController

@property (nonatomic, assign) HDBlockReason blockReason;
@property (nonatomic, copy)   NSString *detailMessage;
@property (nonatomic, copy)   NSString *triggerCode;

@end

NS_ASSUME_NONNULL_END
