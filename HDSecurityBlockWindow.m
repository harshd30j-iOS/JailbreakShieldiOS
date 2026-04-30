//
// HDSecurityBlockWindow.m
// JailbreakShield
//
// Created by Harsh Dwivedi
// Copyright © 2026 Harsh Dwivedi. All rights reserved.
//

#import "HDSecurityBlockWindow.h"

static HDSecurityBlockWindow *_activeBlockWindow = nil;

@implementation HDSecurityBlockWindow

#pragma mark - Factory

+ (void)showWithReason:(HDBlockReason)reason
               message:(NSString *)message
           triggerCode:(NSString *)code {

    dispatch_async(dispatch_get_main_queue(), ^{
        if (_activeBlockWindow) return;

        HDSecurityBlockWindow *win;
        if (@available(iOS 13.0, *)) {
            UIWindowScene *scene = nil;
        for (UIScene *s in UIApplication.sharedApplication.connectedScenes) {
            if ([s isKindOfClass:[UIWindowScene class]] &&
                s.activationState == UISceneActivationStateForegroundActive) {
                scene = (UIWindowScene *)s;
                break;
            }
        }
            win = scene ? [[HDSecurityBlockWindow alloc] initWithWindowScene:scene]
                        : [[HDSecurityBlockWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        } else {
            win = [[HDSecurityBlockWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        }

        win.windowLevel = UIWindowLevelAlert + 10000;
        win.backgroundColor = [UIColor blackColor];
        win.userInteractionEnabled = YES;

        HDSecurityBlockViewController *vc = [[HDSecurityBlockViewController alloc] init];
        vc.blockReason = reason;
        vc.detailMessage = message;
        vc.triggerCode = code;
        win.rootViewController = vc;

        _activeBlockWindow = win;
        [win makeKeyAndVisible];

        [[NSNotificationCenter defaultCenter] addObserver:win
                                                 selector:@selector(handleAppForeground)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    });
}

+ (BOOL)isActive {
    return _activeBlockWindow != nil;
}

#pragma mark - Anti-Bypass Overrides

- (void)setHidden:(BOOL)hidden {
    if (_activeBlockWindow == self) {
        [super setHidden:NO];
    } else {
        [super setHidden:hidden];
    }
}

- (void)setWindowLevel:(UIWindowLevel)windowLevel {
    if (_activeBlockWindow == self) {
        [super setWindowLevel:UIWindowLevelAlert + 10000];
    } else {
        [super setWindowLevel:windowLevel];
    }
}

- (void)resignKeyWindow {
    [super resignKeyWindow];
    if (_activeBlockWindow == self) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self makeKeyAndVisible];
        });
    }
}

- (void)handleAppForeground {
    if (_activeBlockWindow == self) {
        [self makeKeyAndVisible];
        self.windowLevel = UIWindowLevelAlert + 10000;
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hit = [super hitTest:point withEvent:event];
    return hit ?: self;
}

@end
