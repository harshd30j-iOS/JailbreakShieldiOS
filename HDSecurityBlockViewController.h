#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HDBlockReason) {
    HDBlockReasonNone = -1,
    HDBlockReasonJailbreak = 0,
    HDBlockReasonSimulator = 1,
    HDBlockReasonDebugger = 2,
    HDBlockReasonScreenRecording = 3,
    HDBlockReasonScreenshot = 4,
};

@interface HDSecurityBlockViewController : UIViewController

@property (nonatomic, assign) HDBlockReason blockReason;
@property (nonatomic, copy) NSString *detailMessage;
@property (nonatomic, copy) NSString *triggerCode;

@end

NS_ASSUME_NONNULL_END
