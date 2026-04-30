//
//  ScreenProtectionManager.h
//  JailbreakShield
//
//  Created by Harsh Dwivedi
//  Copyright © 2026 Harsh Dwivedi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// Blocks screenshots and screen recording using the banking app secure layer trick.
/// Works in both Objective-C and Swift.
@interface ScreenProtectionManager : NSObject

// ─────────────────────────────────────────
// MARK: - Singleton
// ─────────────────────────────────────────

/// Shared singleton instance
+ (instancetype)sharedManager;


// ─────────────────────────────────────────
// MARK: - Setup (call once at launch)
// ─────────────────────────────────────────

/// Call once from AppDelegate/SceneDelegate AFTER window is key and visible.
/// ObjC: [[ScreenProtectionManager sharedManager] setupProtectionForWindow:window];
/// Swift: ScreenProtectionManager.shared().setupProtection(forWindow: window)
- (void)setupProtectionForWindow:(UIWindow *)window;


// ─────────────────────────────────────────
// MARK: - Feature Toggles
// ─────────────────────────────────────────

/// Block screenshots (UITextField secure layer trick). Default: YES.
/// Screenshot saved to Photos shows blockedImage or black screen.
@property (nonatomic, assign) BOOL screenshotProtectionEnabled;

/// Block screen recording (iOS 11+). Default: YES.
/// Shows black overlay with message while recording is active.
@property (nonatomic, assign) BOOL screenRecordingProtectionEnabled;

/// Image shown in screenshots and during recording instead of real UI.
/// Set nil for solid black. Default: "Screenshot_blocked_Image" asset.
@property (nonatomic, strong, nullable) UIImage *blockedImage;


// ─────────────────────────────────────────
// MARK: - Manual Controls
// ─────────────────────────────────────────

/// Temporarily disable screenshot protection (e.g. for a share sheet).
/// Call reEnableScreenshotProtection when done.
- (void)allowScreenshotTemporarily;

/// Re-enable screenshot protection after temporarily allowing.
- (void)reEnableScreenshotProtection;

/// Returns YES if the screen is currently being recorded (iOS 11+).
- (BOOL)isScreenBeingRecorded;

@end

NS_ASSUME_NONNULL_END
