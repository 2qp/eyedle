//
//  AppContainer.swift
//  eyedle
//
//  Created by 2qp on 2025-05-01.
//

import Core
import Managers
import OverlayFeature
import PreferencesFeature
import Services

@MainActor
public final class AppContainer {

    public let preferencesService: any PreferencesServiceProtocol
    public let launchAgentService: any LaunchAgentServiceProtocol
    public let windowManager: any WindowManagerProtocol
    public let notificationService: NotificationServiceProtocol

    public init() {
        self.preferencesService = PreferencesService()
        self.notificationService = NotificationService()
        self.launchAgentService = LaunchAgentService()

        self.windowManager = WindowManager()

    }

}
