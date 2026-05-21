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
+ (HDBlockReason)activeBlockReason;

@end

NS_ASSUME_NONNULL_END
