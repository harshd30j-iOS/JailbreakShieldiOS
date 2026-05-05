//
// ScreenProtectionManager.h
// JailbreakShield
//
// Created by Harsh Dwivedi
// Copyright © 2026 Harsh Dwivedi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScreenProtectionManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, assign) BOOL screenshotProtectionEnabled;
@property (nonatomic, assign) BOOL screenRecordingProtectionEnabled;

/// Full setup — registers notification observers AND applies the secure-field
/// banking trick to the provided window.
- (void)setupProtectionForWindow:(UIWindow *)window;

/// Register notification observers only (no window needed).
/// Called immediately at launch so recording/screenshot events are caught
/// even before the key window is available.
- (void)setupNotificationsIfNeeded;

/// Apply the secure UITextField trick that makes screenshots appear black.
/// Called separately once the key window is available.
- (void)applySecureTextFieldTrickToWindow:(UIWindow *)window;

- (BOOL)isScreenBeingRecorded;

@end

NS_ASSUME_NONNULL_END
