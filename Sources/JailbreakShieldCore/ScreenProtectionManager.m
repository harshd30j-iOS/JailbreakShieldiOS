//
//  ScreenProtectionManager.m
//  JailbreakShield
//
//  Created by Harsh Dwivedi
//  Copyright © 2026 Harsh Dwivedi. All rights reserved.
//

#import "ScreenProtectionManager.h"

@interface ScreenProtectionManager ()
@property (nonatomic, weak)   UIWindow    *window;
@property (nonatomic, strong) UIView      *screenRecordingOverlay;
@property (nonatomic, strong) UITextField *secureField;
@property (nonatomic, strong) UIImageView *secureBackgroundImageView;
@property (nonatomic, assign) BOOL        screenProtectionApplied;
@end

@implementation ScreenProtectionManager

// ─────────────────────────────────────────
#pragma mark - Singleton
// ─────────────────────────────────────────

+ (instancetype)sharedManager {
    static ScreenProtectionManager *instance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{ instance = [[self alloc] init]; });
    return instance;
}

- (instancetype)init {
    if ((self = [super init])) {
        _screenshotProtectionEnabled      = YES;
        _screenRecordingProtectionEnabled = YES;
        _blockedImage = [UIImage imageNamed:@"Screenshot_blocked_Image"];
    }
    return self;
}


// ─────────────────────────────────────────
#pragma mark - Setup
// ─────────────────────────────────────────

- (void)setupProtectionForWindow:(UIWindow *)window {
    self.window = window;

    if (self.screenshotProtectionEnabled)
        [self applySecureTextFieldTrickToWindow:window];

    [[NSNotificationCenter defaultCenter]
        addObserver:self selector:@selector(userDidTakeScreenshot)
        name:UIApplicationUserDidTakeScreenshotNotification object:nil];

    if (@available(iOS 11.0, *)) {
        [[NSNotificationCenter defaultCenter]
            addObserver:self selector:@selector(screenCaptureStatusChanged)
            name:UIScreenCapturedDidChangeNotification object:nil];
        [self screenCaptureStatusChanged];
    }
}


// ─────────────────────────────────────────
#pragma mark - Screenshot Protection (Secure Layer Trick)
// ─────────────────────────────────────────

/// Banking app trick: UITextField with secureTextEntry=YES
/// iOS excludes secure layers from screenshots and recordings.
/// The blocked image shows instead of the real UI.
- (void)applySecureTextFieldTrickToWindow:(UIWindow *)window {
    if (!window || self.screenProtectionApplied) return;

    self.secureField = [[UITextField alloc] initWithFrame:window.bounds];
    self.secureField.secureTextEntry        = YES;
    self.secureField.userInteractionEnabled = NO;
    self.secureField.backgroundColor        = [UIColor clearColor];
    self.secureField.autoresizingMask       = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    self.secureBackgroundImageView = [[UIImageView alloc] initWithFrame:window.bounds];
    self.secureBackgroundImageView.image            = self.blockedImage;
    self.secureBackgroundImageView.contentMode      = UIViewContentModeScaleAspectFill;
    self.secureBackgroundImageView.backgroundColor  = [UIColor blackColor];
    self.secureBackgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.secureField insertSubview:self.secureBackgroundImageView atIndex:0];

    [window addSubview:self.secureField];
    [window sendSubviewToBack:self.secureField];
    [self.secureField layoutIfNeeded];

    // Swap CALayers: window content goes inside the secure sublayer
    if (window.layer.superlayer)
        [window.layer.superlayer addSublayer:self.secureField.layer];
    if (self.secureField.layer.sublayers.lastObject)
        [self.secureField.layer.sublayers.lastObject addSublayer:window.layer];

    self.screenProtectionApplied = YES;
}

- (void)removeSecureTextFieldTrick {
    [self.secureField removeFromSuperview];
    self.secureField               = nil;
    self.secureBackgroundImageView = nil;
    self.screenProtectionApplied   = NO;
}


// ─────────────────────────────────────────
#pragma mark - Screenshot Flash Overlay
// ─────────────────────────────────────────

- (void)userDidTakeScreenshot {
    if (!self.screenshotProtectionEnabled || !self.window) return;

    UIImageView *overlay = [[UIImageView alloc] initWithFrame:self.window.bounds];
    overlay.image           = self.blockedImage;
    overlay.contentMode     = UIViewContentModeScaleAspectFill;
    overlay.backgroundColor = [UIColor blackColor];
    overlay.alpha           = 0;
    [self.window addSubview:overlay];

    [UIView animateWithDuration:0.05 animations:^{ overlay.alpha = 1.0; }
                     completion:^(BOOL done) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.15 animations:^{ overlay.alpha = 0; }
                             completion:^(BOOL d) { [overlay removeFromSuperview]; }];
        });
    }];
}


// ─────────────────────────────────────────
#pragma mark - Screen Recording Detection
// ─────────────────────────────────────────

- (void)screenCaptureStatusChanged {
    if (@available(iOS 11.0, *)) {
        if ([UIScreen mainScreen].isCaptured) {
            if (self.screenRecordingProtectionEnabled) [self showScreenRecordingOverlay];
        } else {
            [self hideScreenRecordingOverlay];
        }
    }
}

- (BOOL)isScreenBeingRecorded {
    if (@available(iOS 11.0, *)) return [UIScreen mainScreen].isCaptured;
    return NO;
}

- (void)showScreenRecordingOverlay {
    if (self.screenRecordingOverlay || !self.window) return;

    UIView *overlay = [[UIView alloc] initWithFrame:self.window.bounds];
    overlay.backgroundColor  = [UIColor blackColor];
    overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    if (self.blockedImage) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:overlay.bounds];
        iv.image            = self.blockedImage;
        iv.contentMode      = UIViewContentModeScaleAspectFill;
        iv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [overlay addSubview:iv];
    } else {
        UILabel *icon = [[UILabel alloc] init];
        icon.text          = @"📵";
        icon.font          = [UIFont systemFontOfSize:80];
        icon.textAlignment = NSTextAlignmentCenter;
        icon.translatesAutoresizingMaskIntoConstraints = NO;

        UILabel *msg = [[UILabel alloc] init];
        msg.text          = @"Screen Capture Blocked";
        msg.textColor     = [UIColor redColor];
        msg.font          = [UIFont boldSystemFontOfSize:24];
        msg.numberOfLines = 0;
        msg.textAlignment = NSTextAlignmentCenter;
        msg.translatesAutoresizingMaskIntoConstraints = NO;

        UIView *stack = [[UIView alloc] init];
        stack.translatesAutoresizingMaskIntoConstraints = NO;
        [stack addSubview:icon];
        [stack addSubview:msg];
        [overlay addSubview:stack];

        [NSLayoutConstraint activateConstraints:@[
            [stack.centerXAnchor constraintEqualToAnchor:overlay.centerXAnchor],
            [stack.centerYAnchor constraintEqualToAnchor:overlay.centerYAnchor],
            [icon.topAnchor constraintEqualToAnchor:stack.topAnchor],
            [icon.centerXAnchor constraintEqualToAnchor:stack.centerXAnchor],
            [msg.topAnchor constraintEqualToAnchor:icon.bottomAnchor constant:16],
            [msg.leadingAnchor constraintEqualToAnchor:stack.leadingAnchor],
            [msg.trailingAnchor constraintEqualToAnchor:stack.trailingAnchor],
            [msg.bottomAnchor constraintEqualToAnchor:stack.bottomAnchor],
        ]];
    }

    [self.window addSubview:overlay];
    self.screenRecordingOverlay = overlay;
}

- (void)hideScreenRecordingOverlay {
    [self.screenRecordingOverlay removeFromSuperview];
    self.screenRecordingOverlay = nil;
}


// ─────────────────────────────────────────
#pragma mark - Manual Controls
// ─────────────────────────────────────────

- (void)allowScreenshotTemporarily    { [self removeSecureTextFieldTrick]; }
- (void)reEnableScreenshotProtection  {
    if (self.window && self.screenshotProtectionEnabled)
        [self applySecureTextFieldTrickToWindow:self.window];
}

- (void)dealloc { [[NSNotificationCenter defaultCenter] removeObserver:self]; }

@end
