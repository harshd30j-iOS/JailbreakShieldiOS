//
//  HDSecurityBlockWindow.h
//  JailbreakShield
//
//  Created by Harsh Dwivedi
//  Copyright © 2026 Harsh Dwivedi. All rights reserved.
//
//  ─────────────────────────────────────────────────────────────────
//  BYPASS-PROOF SECURITY WINDOW
//  ─────────────────────────────────────────────────────────────────
//  This UIWindow subclass is designed to be impossible to dismiss:
//   ✓ Sits at maximum UIWindowLevel (above all alerts, keyboards)
//   ✓ Cannot be hidden — overrides setHidden:
//   ✓ Re-asserts itself on app foreground / scene reconnect
//   ✓ Overrides resignKeyWindow to reclaim key status
//   ✓ Static retain prevents ARC dealloc
//   ✓ Only exit(0) is the way out
//  ─────────────────────────────────────────────────────────────────

#import <UIKit/UIKit.h>
#import "HDSecurityBlockViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HDSecurityBlockWindow : UIWindow

/// Present the bypass-proof security block window over everything.
/// Retains itself statically — cannot be deallocated or dismissed.
+ (void)showWithReason:(HDBlockReason)reason
               message:(NSString *)message
           triggerCode:(NSString *)code;

/// Returns YES if block window is currently active
+ (BOOL)isActive;

@end

NS_ASSUME_NONNULL_END
