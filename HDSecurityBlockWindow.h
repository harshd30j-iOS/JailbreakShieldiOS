#import <UIKit/UIKit.h>
#import <JailbreakShield/HDSecurityBlockViewController.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDS_c2 : UIWindow

+ (void)showWithReason:(HDBlockReason)reason
               message:(NSString *)message
           triggerCode:(NSString *)code;

+ (BOOL)isActive;
+ (void)dismiss;
+ (void)show;
+ (HDBlockReason)activeBlockReason;

@end

@compatibility_alias HDSecurityBlockWindow HDS_c2;

NS_ASSUME_NONNULL_END
