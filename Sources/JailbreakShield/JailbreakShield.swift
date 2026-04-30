//
//  JailbreakShield.swift
//  JailbreakShield
//
//  Created by Harsh Dwivedi
//  Copyright © 2026 Harsh Dwivedi. All rights reserved.
//
//  ─────────────────────────────────────────────────────────────────
//  Swift-native wrapper over the Objective-C SDK.
//  ─────────────────────────────────────────────────────────────────
//
//  HOW TO USE:
//
//  SwiftUI (one-liner in App.init):
//    JailbreakShield.enforce()
//
//  UIKit SceneDelegate / AppDelegate:
//    JailbreakShield.enforce(in: window)
//
//  Screen protection:
//    JailbreakShield.screenProtection.setup(window: window)
//
//  Manual checks:
//    JailbreakShield.isJailbroken
//    JailbreakShield.isSimulator
//    JailbreakShield.isDebugged
//
//  ─────────────────────────────────────────────────────────────────
//
//  FIX NOTE:
//  'Cannot find HDJailbreakDetection in scope' happens because
//  Swift cannot see ObjC classes from the same SPM target without
//  proper module exposure.
//
//  This file belongs in the SWIFT target (JailbreakShield).
//  ObjC files belong in a SEPARATE target (JailbreakShieldCore).
//  This file imports JailbreakShieldCore — which makes ObjC visible.
//
//  See Package.swift and folder structure below in comments.
//  ─────────────────────────────────────────────────────────────────

// ★ THIS IMPORT IS THE FIX ★
// JailbreakShieldCore is the separate ObjC-only SPM target.
// It exposes all ObjC headers via publicHeadersPath: "include".
// Without this import Swift cannot see HDJailbreakDetection etc.
import JailbreakShieldCore
import UIKit

/// Swift-native interface to JailbreakShield SDK.
public enum JailbreakShield {

    // ─────────────────────────────────────────
    // MARK: - Simulator Bypass
    // ─────────────────────────────────────────

    /// When true (default): simulator is allowed through — no block shown.
    /// Set to false only for UI testing the block screen on simulator.
    /// Always keep true before App Store submission.
    public static var simulatorBypassEnabled: Bool {
        get { HDJailbreakDetection.simulatorBypassEnabled() }
        set { HDJailbreakDetection.setSimulatorBypassEnabled(newValue) }
    }


    // ─────────────────────────────────────────
    // MARK: - ★ Primary Enforcement
    // ─────────────────────────────────────────

    /// Auto-detects the key window and runs all security checks.
    /// Use this in SwiftUI App.init() or any place without a window reference.
    /// Shows the bypass-proof block screen if jailbreak/debugger/simulator found.
    /// Returns true if the app was blocked.
    @discardableResult
    public static func enforce() -> Bool {
        // Find the key window automatically across all connected scenes
        let window = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first(where: { $0.isKeyWindow })
            ?? UIApplication.shared.windows.first

        guard let window = window else { return false }
        return HDJailbreakDetection.enforceSecurity(in: window)
    }

    /// Use this in AppDelegate or SceneDelegate where you have the UIWindow reference.
    /// Preferred over enforce() when window is available — more reliable.
    @discardableResult
    public static func enforce(in window: UIWindow) -> Bool {
        HDJailbreakDetection.enforceSecurity(in: window)
    }


    // ─────────────────────────────────────────
    // MARK: - Individual Checks
    // ─────────────────────────────────────────

    /// Quick check — jailbreak paths + sandbox write test.
    /// Fastest check, good for an early launch gate.
    public static var isJailbroken: Bool {
        HDJailbreakDetection.isJailbroken()
    }

    /// Full check — all 10 detection methods combined.
    /// Use this when you want maximum coverage (slightly slower).
    public static var isDeviceJailbroken: Bool {
        HDJailbreakDetection.isDeviceJailbroken()
    }

    /// Returns true if the app is running on iOS Simulator.
    /// Automatically skipped in enforceSecurityIn: when simulatorBypassEnabled = true.
    public static var isSimulator: Bool {
        HDJailbreakDetection.isRunningOnSimulator()
    }

    /// Returns true if a debugger (lldb, Frida) is currently attached.
    /// Detected via sysctl P_TRACED flag.
    public static var isDebugged: Bool {
        HDJailbreakDetection.isBeingDebugged()
    }

    /// Returns true if suspicious dylibs (Substrate, Frida, Shadow, KernBypass etc.)
    /// are loaded in the process at runtime via _dyld_image_count.
    public static var hasSuspiciousDylibs: Bool {
        HDJailbreakDetection.hasSuspiciousDylibsLoaded()
    }

    /// Returns true if DYLD_INSERT_LIBRARIES is set in the environment.
    /// This means tweak injection is active.
    public static var hasDYLDInjection: Bool {
        HDJailbreakDetection.hasDYLDEnvironmentInjection()
    }

    /// Returns true if the root filesystem is mounted read-write.
    /// On clean devices it is always read-only.
    public static var hasWritableFilesystem: Bool {
        HDJailbreakDetection.hasFilesystemMountedWritable()
    }

    /// Returns true if the Shadow jailbreak bypass tool is active.
    /// Detected via Objective-C runtime class lookup.
    public static var hasShadowBypass: Bool {
        HDJailbreakDetection.hasShadowJailbreakBypass()
    }

    /// Returns true if Cydia, Sileo, Zebra, Filza, Dopamine, TrollStore
    /// URL schemes can be opened — meaning those jailbreak apps are installed.
    public static var hasJailbreakURLSchemes: Bool {
        HDJailbreakDetection.hasSuspiciousURLSchemes()
    }

    /// Returns true if fork() succeeds — not allowed in a proper iOS sandbox.
    /// WARNING: Remove/comment this before App Store submission to avoid rejection.
    public static var canFork: Bool {
        HDJailbreakDetection.canFork()
    }

    /// Runs all 10 checks and returns a result object with:
    ///   result.isJailbroken       — Bool
    ///   result.triggerIdentifier  — "path", "dylib", "fork", "shadow" etc.
    ///   result.reason             — Human-readable explanation
    /// Use this when you want to log or handle each trigger differently.
    public static var comprehensiveResult: JailbreakCheckResult {
        HDJailbreakDetection.comprehensiveCheck()
    }

    /// Returns a human-readable string listing all triggered checks.
    /// Useful for crash reports, analytics, or debugging.
    /// Returns "Device is not jailbroken." on a clean device.
    public static var detectionDetails: String {
        HDJailbreakDetection.jailbreakDetectionDetails()
    }


    // ─────────────────────────────────────────
    // MARK: - Screen Protection
    // ─────────────────────────────────────────

    /// Access the screen protection manager.
    /// Configure properties first, then call .setup(window:).
    ///
    /// Example:
    ///   let spm = JailbreakShield.screenProtection
    ///   spm.screenshotProtectionEnabled      = true
    ///   spm.screenRecordingProtectionEnabled = true
    ///   spm.setup(window: window)
    public static var screenProtection: ScreenProtectionManager {
        ScreenProtectionManager.sharedManager()
    }
}


// ─────────────────────────────────────────
// MARK: - ScreenProtectionManager Swift Extension
// ─────────────────────────────────────────

public extension ScreenProtectionManager {

    /// Swift-friendly alias for setupProtectionForWindow:
    /// Call once AFTER makeKeyAndVisible / window is visible.
    func setup(window: UIWindow) {
        setupProtection(forWindow: window)
    }

    /// Returns true if the screen is currently being recorded (iOS 11+).
    var isRecording: Bool {
        isScreenBeingRecorded()
    }
}
