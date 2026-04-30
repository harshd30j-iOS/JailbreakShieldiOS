//
//  HDSecurityBlockWindow.m
//  JailbreakShield
//
//  Created by Harsh Dwivedi
//  Copyright © 2026 Harsh Dwivedi. All rights reserved.
//

#import "HDSecurityBlockWindow.h"

// Static strong retain — ARC will never release this window
static HDSecurityBlockWindow *_activeBlockWindow = nil;

@implementation HDSecurityBlockWindow

// ─────────────────────────────────────────
#pragma mark - Factory
// ─────────────────────────────────────────

+ (void)showWithReason:(HDBlockReason)reason
               message:(NSString *)message
           triggerCode:(NSString *)code {

    dispatch_async(dispatch_get_main_queue(), ^{

        if (_activeBlockWindow) return; // already shown

        // Create bypass-proof window
        HDSecurityBlockWindow *win;
        if (@available(iOS 13.0, *)) {
            UIWindowScene *scene = (UIWindowScene *)[UIApplication.sharedApplication.connectedScenes
                filteredSetWithEvaluate:^BOOL(UIScene *s, BOOL *stop) {
                    return [s isKindOfClass:[UIWindowScene class]] &&
                           s.activationState == UISceneActivationStateForegroundActive;
                }].anyObject;
            win = scene ? [[HDSecurityBlockWindow alloc] initWithWindowScene:scene]
                        : [[HDSecurityBlockWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        } else {
            win = [[HDSecurityBlockWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        }

        // Maximum window level — above system alerts, keyboards, everything
        win.windowLevel         = UIWindowLevelAlert + 10000;
        win.backgroundColor     = [UIColor blackColor];
        win.userInteractionEnabled = YES;

        // Set block view controller
        HDSecurityBlockViewController *vc = [[HDSecurityBlockViewController alloc] init];
        vc.blockReason    = reason;
        vc.detailMessage  = message;
        vc.triggerCode    = code;
        win.rootViewController = vc;

        // Static retain — impossible to deallocate
        _activeBlockWindow = win;

        [win makeKeyAndVisible];

        // Listen for foreground — re-assert window in case anything pushed over it
        [[NSNotificationCenter defaultCenter] addObserver:win
                                                 selector:@selector(handleAppForeground)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    });
}

+ (BOOL)isActive {
    return _activeBlockWindow != nil;
}


// ─────────────────────────────────────────
#pragma mark - Anti-Bypass Overrides
// ─────────────────────────────────────────

/// Prevent anyone from hiding this window
- (void)setHidden:(BOOL)hidden {
    if (_activeBlockWindow == self) {
        [super setHidden:NO]; // always visible
    } else {
        [super setHidden:hidden];
    }
}

/// Prevent anyone from lowering the window level
- (void)setWindowLevel:(UIWindowLevel)windowLevel {
    if (_activeBlockWindow == self) {
        [super setWindowLevel:UIWindowLevelAlert + 10000]; // always max
    } else {
        [super setWindowLevel:windowLevel];
    }
}

/// Reclaim key window status if anything tries to steal it
- (void)resignKeyWindow {
    [super resignKeyWindow];
    if (_activeBlockWindow == self) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self makeKeyAndVisible];
        });
    }
}

/// Re-assert on app foreground (in case something covered us)
- (void)handleAppForeground {
    if (_activeBlockWindow == self) {
        [self makeKeyAndVisible];
        self.windowLevel = UIWindowLevelAlert + 10000;
    }
}

/// Block all swipe-down / swipe gestures to prevent dismissal
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hit = [super hitTest:point withEvent:event];
    // Consume all touches — only buttons inside the VC pass through
    return hit ?: self;
}

@end
