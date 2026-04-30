//
// HDSecurityBlockWindow.h
// JailbreakShield
//
// Created by Harsh Dwivedi
// Copyright © 2026 Harsh Dwivedi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDSecurityBlockViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HDSecurityBlockWindow : UIWindow

+ (void)showWithReason:(HDBlockReason)reason
               message:(NSString *)message
           triggerCode:(NSString *)code;

+ (BOOL)isActive;

@end

NS_ASSUME_NONNULL_END
