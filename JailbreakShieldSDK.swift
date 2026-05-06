//
// JailbreakShieldNew.swift
// JailbreakShield
//
// Created by Harsh Dwivedi
// Copyright © 2026 Harsh Dwivedi. All rights reserved.
//

import UIKit

public enum JailbreakShieldSDK {

    // MARK: - Simulator Bypass
        public static var simulatorBypassEnabled: Bool {
            get { HDJailbreakDetection.simulatorBypassEnabled }
            set { HDJailbreakDetection.simulatorBypassEnabled = newValue }
        }

    // MARK: - Primary Enforcement

    @discardableResult
    public static func enforce() -> Bool {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })
            ?? UIApplication.shared.windows.first
        else { return false }
        return HDJailbreakDetection.enforceSecurity(in: window)
    }

    @discardableResult
    public static func enforce(in window: UIWindow) -> Bool {
        return HDJailbreakDetection.enforceSecurity(in: window)
    }

    // MARK: - Individual Checks

    public static var isJailbroken: Bool          { HDJailbreakDetection.isJailbroken() }
    public static var isDeviceJailbroken: Bool    { HDJailbreakDetection.isDeviceJailbroken() }
    public static var isSimulator: Bool           { HDJailbreakDetection.isRunningOnSimulator() }
    public static var isDebugged: Bool            { HDJailbreakDetection.isBeingDebugged() }
    public static var hasSuspiciousDylibs: Bool   { HDJailbreakDetection.hasSuspiciousDylibsLoaded() }
    public static var hasDYLDInjection: Bool      { HDJailbreakDetection.hasDYLDEnvironmentInjection() }
    public static var hasWritableFilesystem: Bool { HDJailbreakDetection.hasFilesystemMountedWritable() }
    public static var hasShadowBypass: Bool       { HDJailbreakDetection.hasShadowJailbreakBypass() }
    public static var hasJailbreakURLSchemes: Bool{ HDJailbreakDetection.hasSuspiciousURLSchemes() }
    public static var canFork: Bool               { HDJailbreakDetection.canFork() }
    public static var detectionDetails: String    { HDJailbreakDetection.jailbreakDetectionDetails() }
    
    // MARK: - Debugger Bypass
        public static var debuggerBypassEnabled: Bool {
            get { HDJailbreakDetection.debuggerBypassEnabled }
            set { HDJailbreakDetection.debuggerBypassEnabled = newValue }
        }
}

/// 10/10 FIX: Added 'public' so your whole project can see it.
/// Added 'items: Any...' so it works exactly like the standard print() function.
public func JSLog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    // Only works in Debug mode
    let output = items.map { "\($0)" }.joined(separator: separator)
    Swift.print(output, terminator: terminator)
    #endif
}

