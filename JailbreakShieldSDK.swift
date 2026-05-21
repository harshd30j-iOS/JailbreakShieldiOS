//
//  JailbreakShieldSDK.swift
//  JailbreakShield
//

import UIKit

public enum JailbreakShieldSDK {

    public static var simulatorBypassEnabled: Bool {
        get { HDJailbreakDetection.simulatorBypassEnabled }
        set { HDJailbreakDetection.simulatorBypassEnabled = newValue }
    }

    public static var debuggerBypassEnabled: Bool {
        get { HDJailbreakDetection.debuggerBypassEnabled }
        set { HDJailbreakDetection.debuggerBypassEnabled = newValue }
    }

    public static var onDetection: ((String, String) -> Void)? {
        get { HDJailbreakDetection.onDetection }
        set { HDJailbreakDetection.onDetection = newValue }
    }

    @discardableResult
    public static func enforce() -> Bool {
        return HDJailbreakDetection.enforceSecurity()
    }

    @discardableResult
    public static func enforce(in window: UIWindow) -> Bool {
        return HDJailbreakDetection.enforceSecurity()
    }

    public static func enforceScreenProtection() {
        HDJailbreakDetection.enforceScreenProtection()
    }

    public static var isJailbroken: Bool { HDJailbreakDetection.isJailbroken() }
    public static var isDeviceJailbroken: Bool { HDJailbreakDetection.isDeviceJailbroken() }
    public static var isSimulator: Bool { HDJailbreakDetection.isRunningOnSimulator() }
    public static var isDebugged: Bool { HDJailbreakDetection.isBeingDebugged() }
    public static var hasSuspiciousDylibs: Bool { HDJailbreakDetection.hasSuspiciousDylibsLoaded() }
    public static var hasDYLDInjection: Bool { HDJailbreakDetection.hasDYLDEnvironmentInjection() }
    public static var hasWritableFilesystem: Bool { HDJailbreakDetection.hasFilesystemMountedWritable() }
    public static var hasShadowBypass: Bool { HDJailbreakDetection.hasShadowJailbreakBypass() }
    public static var hasJailbreakURLSchemes: Bool { HDJailbreakDetection.hasSuspiciousURLSchemes() }
    public static var canFork: Bool { HDJailbreakDetection.canFork() }
    public static var detectionDetails: String { HDJailbreakDetection.jailbreakDetectionDetails() }

    public static func JSLog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        #if DEBUG
        let output = items.map { "\($0)" }.joined(separator: separator)
        Swift.print("🛡 " + output, terminator: terminator)
        #endif
    }
}
