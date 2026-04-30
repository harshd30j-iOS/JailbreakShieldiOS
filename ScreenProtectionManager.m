//
// ScreenProtectionManager.m
// JailbreakShield
//
// Created by Harsh Dwivedi
// Copyright © 2026 Harsh Dwivedi. All rights reserved.
//

#import "ScreenProtectionManager.h"

@interface ScreenProtectionManager ()
@property (nonatomic, weak) UIWindow *protectedWindow;
@property (nonatomic, strong) UITextField *secureField;
@end

@implementation ScreenProtectionManager

+ (instancetype)sharedManager {
    static ScreenProtectionManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ScreenProtectionManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _screenshotProtectionEnabled = YES;
        _screenRecordingProtectionEnabled = YES;
    }
    return self;
}

- (void)setupProtectionForWindow:(UIWindow *)window {
    self.protectedWindow = window;

    if (_screenshotProtectionEnabled) {
        self.secureField = [[UITextField alloc] init];
        self.secureField.secureTextEntry = YES;
        self.secureField.userInteractionEnabled = NO;
        if (self.secureField.subviews.count > 0) {
            UIView *overlay = self.secureField.subviews.firstObject;
            overlay.translatesAutoresizingMaskIntoConstraints = NO;
            [window addSubview:overlay];
            [NSLayoutConstraint activateConstraints:@[
                [overlay.topAnchor constraintEqualToAnchor:window.topAnchor],
                [overlay.bottomAnchor constraintEqualToAnchor:window.bottomAnchor],
                [overlay.leadingAnchor constraintEqualToAnchor:window.leadingAnchor],
                [overlay.trailingAnchor constraintEqualToAnchor:window.trailingAnchor],
            ]];
        }
    }

    if (_screenRecordingProtectionEnabled) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(screenCaptureDidChange)
                                                     name:UIScreenCapturedDidChangeNotification
                                                   object:nil];
    }
}

- (void)screenCaptureDidChange {
    if (@available(iOS 11.0, *)) {
        if ([UIScreen mainScreen].isCaptured && _screenRecordingProtectionEnabled) {
            self.protectedWindow.hidden = YES;
        } else {
            self.protectedWindow.hidden = NO;
        }
    }
}

- (BOOL)isScreenBeingRecorded {
    if (@available(iOS 11.0, *)) {
        return [UIScreen mainScreen].isCaptured;
    }
    return NO;
}

@end
