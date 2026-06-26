#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScreenProtectionManager : NSObject

+ (instancetype)sharedManager NS_SWIFT_NAME(shared());

@property (nonatomic, assign) BOOL screenshotProtectionEnabled;
@property (nonatomic, assign) BOOL screenRecordingProtectionEnabled;

- (void)setupProtectionForWindow:(UIWindow *)window
    NS_SWIFT_NAME(setupProtection(for:));

- (void)setupNotificationsIfNeeded;

- (void)applySecureTextFieldTrickToWindow:(UIWindow *)window
    NS_SWIFT_NAME(applySecureTextFieldTrick(to:));

- (BOOL)isScreenBeingRecorded;

@end

NS_ASSUME_NONNULL_END
