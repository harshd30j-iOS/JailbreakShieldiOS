//
// HDSecurityBlockWindow.h
// JailbreakShield
//

#import <UIKit/UIKit.h>
#import <JailbreakShield/HDSecurityBlockViewController.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDSecurityBlockWindow : UIWindow

+ (void)showWithReason:(HDBlockReason)reason
               message:(NSString *)message
           triggerCode:(NSString *)code;

+ (BOOL)isActive;
+ (void)dismiss;
+ (void)show;

// FIX: Exposes the reason so dismissing CarPlay/AirPlay doesn't override actual jailbreak blocks
+ (HDBlockReason)activeBlockReason;

@end

NS_ASSUME_NONNULL_END
