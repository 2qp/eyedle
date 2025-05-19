//
//  AuthServiceKey.swift
//  Core
//
//  Created by 2qp on 2025-05-01.
//

import SwiftUI

public struct PreferencesServiceKey: EnvironmentKey {
    public static var defaultValue: (any PreferencesServiceProtocol)? { nil }
}

public struct LaunchAgentServiceKey: EnvironmentKey {
    public static var defaultValue: (any LaunchAgentServiceProtocol)? { nil }
}

public struct OverlayWindowServiceKey: EnvironmentKey {
    public static var defaultValue: (any OverlayWindowServiceProtocol)? { nil }
}
