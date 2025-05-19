//
//  PreferencesServiceProtocol.swift
//  Core
//
//  Created by 2qp on 2025-05-01.
//

import Foundation

public protocol PreferencesProtocol: Codable {
    var taskInterval: Int { get set }
    var notifyTime: Int { get set }
    var coolDown: Int { get set }
    var isAutomationEnabled: Bool { get set }

    init(
        taskInterval: Int,
        notifyTime: Int,
        coolDown: Int,
        isAutomationEnabled: Bool
    )

    //    func updateSettings(taskInterval: Int, notifyTime: Int, coolDown: Int, isAutomationEnabled: Bool)
}

public protocol PreferencesUpdateProtocol {
    var taskInterval: Int? { get set }
    var notifyTime: Int? { get set }
    var coolDown: Int? { get set }
    var isAutomationEnabled: Bool? { get set }

    init(
        taskInterval: Int?,
        notifyTime: Int?,
        coolDown: Int?,
        isAutomationEnabled: Bool?
    )

}

public protocol PreferencesServiceProtocol: ObservableObject {
    func getSettings(_ settingsKey: String) -> PreferencesProtocol
    func setSettings(_ settingsKey: String, _ settings: PreferencesProtocol)
    func updateSettings(
        _ settingsKey: String,
        _ payload: PreferencesProtocol?,
        _ update: PreferencesUpdateProtocol
    ) -> PreferencesProtocol

    func getAllSettings() -> PreferencesProtocol
}
