#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDS_c4 : NSObject

@property (nonatomic, assign) BOOL screenshotProtectionEnabled;
@property (nonatomic, assign) BOOL screenRecordingProtectionEnabled;
@property (nonatomic, copy, nullable) NSString *customScreenRecordingMessage;
@property (nonatomic, copy, nullable) NSString *customScreenshotMessage;

+ (instancetype)sharedManager NS_SWIFT_NAME(shared());

- (void)setupProtectionForWindow:(UIWindow *)window
    NS_SWIFT_NAME(setupProtection(for:));

- (void)setupNotificationsIfNeeded;

- (void)applySecureTextFieldTrickToWindow:(UIWindow *)window
    NS_SWIFT_NAME(applySecureTextFieldTrick(to:));

- (BOOL)isScreenBeingRecorded;

@end

@compatibility_alias ScreenProtectionManager HDS_c4;

NS_ASSUME_NONNULL_END
