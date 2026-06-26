import UIKit

/// Pure-Swift facade for JailbreakShield.
///
/// Usage from Swift:
/// ```swift
/// import JailbreakShield
///
/// // One-liner at app launch:
/// JailbreakShieldSDK.enforce()
///
/// // With screen protection:
/// JailbreakShieldSDK.enforceScreenProtection()
///
/// // Custom callback:
/// JailbreakShieldSDK.onDetection = { trigger, reason in
///     print("Detected: \(trigger) — \(reason)")
/// }
/// ```
public enum JailbreakShieldSDK {

    // MARK: - Bypass Controls

    /// When `true` (default), simulator devices are not flagged as jailbroken.
    public static var simulatorBypassEnabled: Bool {
        get { HDJailbreakDetection.simulatorBypassEnabled }
        set { HDJailbreakDetection.simulatorBypassEnabled = newValue }
    }

    /// When `true` (default), attached debuggers are not flagged.
    public static var debuggerBypassEnabled: Bool {
        get { HDJailbreakDetection.debuggerBypassEnabled }
        set { HDJailbreakDetection.debuggerBypassEnabled = newValue }
    }

    // MARK: - Detection Callback

    /// Optional callback fired whenever a security violation is detected.
    /// - Parameters:
    ///   - triggerIdentifier: Machine-readable ID (e.g. `"frida_server"`, `"paths"`).
    ///   - reason: Human-readable explanation.
    public static var onDetection: ((String, String) -> Void)? {
        get { HDJailbreakDetection.onDetectionHandler() }
        set { HDJailbreakDetection.setOnDetectionHandler(newValue) }
    }

    // MARK: - Primary Enforcement

    /// Run all security checks and show a block screen if violated.
    /// Auto-finds the key window. Works in UIKit and SwiftUI.
    /// - Returns: `true` if a violation was detected (screen shown).
    @discardableResult
    public static func enforce() -> Bool {
        return HDJailbreakDetection.enforceSecurity()
    }

    /// Run all security checks using the given window for the block screen.
    /// - Parameter window: The window to present the block screen in.
    /// - Returns: `true` if a violation was detected (screen shown).
    @discardableResult
    public static func enforce(in window: UIWindow) -> Bool {
        return HDJailbreakDetection.enforceSecurity(in: window)
    }

    /// Attach screenshot + screen recording protection.
    /// Call once at launch (e.g. in `application(_:didFinishLaunchingWithOptions:)`).
    public static func enforceScreenProtection() {
        HDJailbreakDetection.enforceScreenProtection()
    }

    // MARK: - Individual Check Results

    /// `true` if any jailbreak indicator is found.
    public static var isJailbroken: Bool { HDJailbreakDetection.isJailbroken() }

    /// Alias for `isJailbroken`.
    public static var isDeviceJailbroken: Bool { HDJailbreakDetection.isDeviceJailbroken() }

    /// `true` if running on the iOS Simulator.
    public static var isSimulator: Bool { HDJailbreakDetection.isRunningOnSimulator() }

    /// `true` if a debugger (lldb, etc.) is attached.
    public static var isDebugged: Bool { HDJailbreakDetection.isBeingDebugged() }

    /// `true` if suspicious dylibs (MobileSubstrate, Frida, etc.) are loaded.
    public static var hasSuspiciousDylibs: Bool { HDJailbreakDetection.hasSuspiciousDylibsLoaded() }

    /// `true` if DYLD environment injection is detected.
    public static var hasDYLDInjection: Bool { HDJailbreakDetection.hasDYLDEnvironmentInjection() }

    /// `true` if the root filesystem is mounted writable.
    public static var hasWritableFilesystem: Bool { HDJailbreakDetection.hasFilesystemMountedWritable() }

    /// `true` if Shadow jailbreak bypass is detected.
    public static var hasShadowBypass: Bool { HDJailbreakDetection.hasShadowJailbreakBypass() }

    /// `true` if jailbreak URL schemes (cydia://, sileo://, etc.) can be opened.
    public static var hasJailbreakURLSchemes: Bool { HDJailbreakDetection.hasSuspiciousURLSchemes() }

    /// `true` if `fork()` succeeds (sandboxing broken).
    public static var canFork: Bool { HDJailbreakDetection.canFork() }

    /// Human-readable summary of all detected jailbreak indicators.
    public static var detectionDetails: String { HDJailbreakDetection.jailbreakDetectionDetails() }

    // MARK: - Advanced Checks (v6.3.0)

    /// `true` if Frida server port is open.
    public static var hasFridaServer: Bool { HDJailbreakDetection.hasFridaServerRunning() }

    /// `true` if Frida gadget signature found in loaded dylibs.
    public static var hasFridaGadget: Bool { HDJailbreakDetection.hasFridaGadgetSignature() }

    /// `true` if RootHide jailbreak bypass is detected.
    public static var hasRootHide: Bool { HDJailbreakDetection.hasRootHideIndicators() }

    /// `true` if TrollStore sideloading detected.
    public static var hasTrollStore: Bool { HDJailbreakDetection.hasTrollStoreIndicators() }

    /// `true` if jailbreak-related symlinks are found.
    public static var hasJailbreakSymlinks: Bool { HDJailbreakDetection.hasJailbreakSymlinks() }

    /// `true` if the parent process is suspicious (not SpringBoard/launchd).
    public static var hasSuspiciousParent: Bool { HDJailbreakDetection.hasSuspiciousParentProcess() }

    /// `true` if system framework methods appear to be hooked.
    public static var hasFrameworkAnomaly: Bool { HDJailbreakDetection.hasSystemFrameworkAnomaly() }

    /// `true` if modern jailbreak fingerprints (Dopamine, palera1n, etc.) are found.
    public static var hasModernJailbreak: Bool { HDJailbreakDetection.hasModernJailbreakFingerprints() }

    /// `true` if analysis tools (Frida, Cycript, lldb, etc.) are running.
    public static var hasAnalysisTools: Bool { HDJailbreakDetection.hasAnalysisToolsRunning() }

    /// `true` if the main binary appears modified (cryptid check).
    public static var hasModifiedBinary: Bool { HDJailbreakDetection.hasModifiedBinary() }

    /// Run the comprehensive check and get a detailed result.
    public static var comprehensiveResult: JailbreakCheckResult {
        HDJailbreakDetection.comprehensiveCheck()
    }

    // MARK: - Debug Logging

    /// Debug-only log helper. Output is suppressed in Release builds.
    public static func JSLog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        #if DEBUG
        let output = items.map { "\($0)" }.joined(separator: separator)
        Swift.print("🛡 " + output, terminator: terminator)
        #endif
    }
}
