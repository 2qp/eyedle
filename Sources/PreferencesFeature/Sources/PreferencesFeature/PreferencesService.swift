//
//  PreferencesService.swift
//  Services
//
//  Created by 2qp on 2025-05-01.
//

import Core
import Foundation

public class PreferencesService: PreferencesServiceProtocol {
    //

    public init() {}

    public func updateSettings(
        _ settingsKey: String,
        _ payload: PreferencesProtocol?,
        _ update: PreferencesUpdateProtocol
    ) -> PreferencesProtocol {

        var settings = getSettings(settingsKey)

        var updatedSettings = settings

        // Use update values first, and fall back to payload if update doesn't provide a value
        if let taskInterval = update.taskInterval ?? payload?.taskInterval {
            updatedSettings.taskInterval = taskInterval
        }
        if let notifyTime = update.notifyTime ?? payload?.notifyTime {
            updatedSettings.notifyTime = notifyTime
        }
        if let coolDown = update.coolDown ?? payload?.coolDown {
            updatedSettings.coolDown = coolDown
        }
        if let isAutomationEnabled = update.isAutomationEnabled
            ?? payload?.isAutomationEnabled
        {
            updatedSettings.isAutomationEnabled = isAutomationEnabled
        }

        settings = updatedSettings

        setSettings(settingsKey, settings)

        return settings
    }

    public func getSettings(_ settingsKey: String) -> PreferencesProtocol {
        if let data = UserDefaults.standard.data(forKey: settingsKey),
            let settings = try? JSONDecoder().decode(
                Preferences.self,
                from: data
            )
        {
            return settings
        }
        return Preferences(
            taskInterval: 10,
            notifyTime: 15,
            coolDown: 5,
            isAutomationEnabled: false
        )
    }

    public func setSettings(
        _ settingsKey: String,
        _ settings: PreferencesProtocol
    ) {

        if let data = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(data, forKey: settingsKey)
        }
    }

    public func getAllSettings() -> PreferencesProtocol {

        let prefKey: String = "Preferences"

        return getSettings(prefKey)
    }

}
