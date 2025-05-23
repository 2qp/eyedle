//
//  EnvironmentValues.swift
//  Core
//
//  Created by 2qp on 2025-05-01.
//
import SwiftUI

extension EnvironmentValues {
    public var preferencesService: (any PreferencesServiceProtocol)? {
        get { self[PreferencesServiceKey.self] }
        set { self[PreferencesServiceKey.self] = newValue }
    }

    public var launchAgentService: (any LaunchAgentServiceProtocol)? {
        get { self[LaunchAgentServiceKey.self] }
        set { self[LaunchAgentServiceKey.self] = newValue }
    }

    public var fileManagerService: (any FileManagerServiceProtocol)? {
        get { self[FileManagerServiceKey.self] }
        set { self[FileManagerServiceKey.self] = newValue }
    }

}
