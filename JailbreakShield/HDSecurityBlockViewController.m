//
//  HDSecurityBlockViewController.m
//  JailbreakShield
//
//  Created by Harsh Dwivedi
//  Copyright © 2026 Harsh Dwivedi. All rights reserved.
//

#import "HDSecurityBlockViewController.h"

@implementation HDSecurityBlockViewController

// ─────────────────────────────────────────
#pragma mark - Anti-Bypass Lifecycle Guards
// ─────────────────────────────────────────

/// Prevent any attempt to pop or dismiss this VC
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // Re-present if something tries to dismiss us
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.isBeingDismissed || self.isMovingFromParentViewController) {
            [self.view.window.rootViewController
                presentViewController:self animated:NO completion:nil];
        }
    });
}

- (BOOL)shouldAutorotate { return YES; }
- (UIStatusBarStyle)preferredStatusBarStyle { return UIStatusBarStyleLightContent; }
- (BOOL)prefersStatusBarHidden { return NO; }

/// Block swipe-to-dismiss on iOS 13+ modal sheets
- (BOOL)isModalInPresentation { return YES; }


// ─────────────────────────────────────────
#pragma mark - Lifecycle
// ─────────────────────────────────────────

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildUI];
}


// ─────────────────────────────────────────
#pragma mark - UI Build
// ─────────────────────────────────────────

- (void)buildUI {
    self.view.backgroundColor = [UIColor blackColor];

    BOOL isSimulator = (self.blockReason == HDBlockReasonSimulator);
    BOOL isDebugger  = (self.blockReason == HDBlockReasonDebugger);

    // Accent color: orange for simulator, red for jailbreak/debugger
    UIColor *accentColor = isSimulator
        ? [UIColor colorWithRed:1.0 green:0.58 blue:0.0 alpha:1.0]
        : [UIColor colorWithRed:0.93 green:0.22 blue:0.22 alpha:1.0];

    NSString *title = isSimulator ? @"Simulator Detected"
                    : isDebugger  ? @"Debug Mode Detected"
                                  : @"Security Alert";

    NSString *sfSymbol = isSimulator
        ? @"desktopcomputer.trianglebadge.exclamationmark"
        : @"lock.shield.fill";

    // ── Scroll-safe container ─────────────────────────
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.translatesAutoresizingMaskIntoConstraints = NO;
    scroll.alwaysBounceVertical = YES;
    [self.view addSubview:scroll];

    UIView *container = [[UIView alloc] init];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    [scroll addSubview:container];

    // ── Icon ─────────────────────────────────────────
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.translatesAutoresizingMaskIntoConstraints = NO;
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    iconView.tintColor   = accentColor;
    if (@available(iOS 13.0, *)) {
        UIImageSymbolConfiguration *cfg = [UIImageSymbolConfiguration
            configurationWithPointSize:72 weight:UIImageSymbolWeightMedium];
        iconView.image = [UIImage systemImageNamed:sfSymbol withConfiguration:cfg];
    } else {
        iconView.image = [UIImage imageNamed:sfSymbol];
    }
    [container addSubview:iconView];

    // ── Title ─────────────────────────────────────────
    UILabel *titleLabel = [self labelWithText:title
                                         font:[UIFont boldSystemFontOfSize:26]
                                        color:[UIColor whiteColor]
                                        lines:1];
    [container addSubview:titleLabel];

    // ── Separator ─────────────────────────────────────
    UIView *sep = [[UIView alloc] init];
    sep.translatesAutoresizingMaskIntoConstraints = NO;
    sep.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.12];
    [container addSubview:sep];

    // ── Detail message ────────────────────────────────
    UILabel *messageLabel = [self labelWithText:self.detailMessage
                                           font:[UIFont systemFontOfSize:15
                                                                  weight:UIFontWeightRegular]
                                          color:[[UIColor whiteColor] colorWithAlphaComponent:0.65]
                                          lines:0];
    [container addSubview:messageLabel];

    // ── Support line ──────────────────────────────────
    UILabel *supportLabel = [self labelWithText:@"If you believe this is a mistake,\nplease contact your app's support team."
                                           font:[UIFont systemFontOfSize:12
                                                                  weight:UIFontWeightRegular]
                                          color:[[UIColor whiteColor] colorWithAlphaComponent:0.30]
                                          lines:0];
    [container addSubview:supportLabel];

    // ── Trigger code ──────────────────────────────────
    UILabel *codeLabel = [[UILabel alloc] init];
    codeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    codeLabel.text = [NSString stringWithFormat:@"Code: %@", self.triggerCode ?: @"unknown"];
    codeLabel.textColor    = [[UIColor whiteColor] colorWithAlphaComponent:0.18];
    if (@available(iOS 13.0, *)) {
        codeLabel.font = [UIFont monospacedSystemFontOfSize:11 weight:UIFontWeightRegular];
    } else {
        codeLabel.font = [UIFont fontWithName:@"Courier" size:11];
    }
    codeLabel.textAlignment = NSTextAlignmentCenter;
    [container addSubview:codeLabel];

    // ── Exit Button ───────────────────────────────────
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    exitBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [exitBtn setTitle:@"Exit App" forState:UIControlStateNormal];
    [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [exitBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6]
                 forState:UIControlStateHighlighted];
    exitBtn.titleLabel.font   = [UIFont boldSystemFontOfSize:17];
    exitBtn.backgroundColor   = accentColor;
    exitBtn.layer.cornerRadius = 14;
    exitBtn.layer.masksToBounds = YES;
    [exitBtn addTarget:self action:@selector(exitTapped)
      forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:exitBtn];

    // ── Layout ────────────────────────────────────────
    [NSLayoutConstraint activateConstraints:@[
        // Scroll fills view
        [scroll.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [scroll.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [scroll.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [scroll.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],

        // Container fills scroll width
        [container.topAnchor constraintEqualToAnchor:scroll.topAnchor],
        [container.bottomAnchor constraintEqualToAnchor:scroll.bottomAnchor],
        [container.leadingAnchor constraintEqualToAnchor:scroll.leadingAnchor],
        [container.trailingAnchor constraintEqualToAnchor:scroll.trailingAnchor],
        [container.widthAnchor constraintEqualToAnchor:scroll.widthAnchor],
        [container.heightAnchor constraintGreaterThanOrEqualToAnchor:scroll.heightAnchor],

        // Icon — centered, top 25%
        [iconView.topAnchor constraintGreaterThanOrEqualToAnchor:container.topAnchor constant:80],
        [iconView.centerXAnchor constraintEqualToAnchor:container.centerXAnchor],
        [iconView.widthAnchor constraintEqualToConstant:80],
        [iconView.heightAnchor constraintEqualToConstant:80],

        // Title
        [titleLabel.topAnchor constraintEqualToAnchor:iconView.bottomAnchor constant:24],
        [titleLabel.leadingAnchor constraintEqualToAnchor:container.leadingAnchor constant:32],
        [titleLabel.trailingAnchor constraintEqualToAnchor:container.trailingAnchor constant:-32],

        // Separator
        [sep.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:20],
        [sep.leadingAnchor constraintEqualToAnchor:container.leadingAnchor constant:48],
        [sep.trailingAnchor constraintEqualToAnchor:container.trailingAnchor constant:-48],
        [sep.heightAnchor constraintEqualToConstant:1],

        // Message
        [messageLabel.topAnchor constraintEqualToAnchor:sep.bottomAnchor constant:20],
        [messageLabel.leadingAnchor constraintEqualToAnchor:container.leadingAnchor constant:32],
        [messageLabel.trailingAnchor constraintEqualToAnchor:container.trailingAnchor constant:-32],

        // Support
        [supportLabel.topAnchor constraintEqualToAnchor:messageLabel.bottomAnchor constant:14],
        [supportLabel.leadingAnchor constraintEqualToAnchor:container.leadingAnchor constant:32],
        [supportLabel.trailingAnchor constraintEqualToAnchor:container.trailingAnchor constant:-32],

        // Code
        [codeLabel.topAnchor constraintEqualToAnchor:supportLabel.bottomAnchor constant:24],
        [codeLabel.centerXAnchor constraintEqualToAnchor:container.centerXAnchor],

        // Exit button
        [exitBtn.topAnchor constraintEqualToAnchor:codeLabel.bottomAnchor constant:32],
        [exitBtn.leadingAnchor constraintEqualToAnchor:container.leadingAnchor constant:32],
        [exitBtn.trailingAnchor constraintEqualToAnchor:container.trailingAnchor constant:-32],
        [exitBtn.heightAnchor constraintEqualToConstant:54],
        [exitBtn.bottomAnchor constraintEqualToAnchor:container.bottomAnchor constant:-48],
    ]];
}

- (UILabel *)labelWithText:(NSString *)text
                      font:(UIFont *)font
                     color:(UIColor *)color
                     lines:(NSInteger)lines {
    UILabel *l = [[UILabel alloc] init];
    l.translatesAutoresizingMaskIntoConstraints = NO;
    l.text            = text;
    l.font            = font;
    l.textColor       = color;
    l.textAlignment   = NSTextAlignmentCenter;
    l.numberOfLines   = lines;
    l.lineBreakMode   = NSLineBreakByWordWrapping;
    return l;
}


// ─────────────────────────────────────────
#pragma mark - Actions
// ─────────────────────────────────────────

- (void)exitTapped {
    exit(0);
}

@end
