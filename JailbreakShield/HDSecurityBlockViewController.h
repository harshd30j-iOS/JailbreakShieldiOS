//
// HDSecurityBlockViewController.h
// JailbreakShield
//
// Created by Harsh Dwivedi
// Copyright © 2026 Harsh Dwivedi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HDBlockReason) {
    HDBlockReasonJailbreak,        // Device is jailbroken
    HDBlockReasonSimulator,        // Running on simulator
    HDBlockReasonDebugger,         // Debugger attached
    HDBlockReasonScreenRecording,
    HDBlockReasonScreenshot
};;

@interface HDSecurityBlockViewController : UIViewController

@property (nonatomic, assign) HDBlockReason blockReason;
@property (nonatomic, copy) NSString *detailMessage;
@property (nonatomic, copy) NSString *triggerCode;

@end

NS_ASSUME_NONNULL_END
