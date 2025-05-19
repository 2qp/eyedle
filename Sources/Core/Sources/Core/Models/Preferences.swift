//
//  Preferences.swift
//  Core
//
//  Created by 2qp on 2025-05-02.
//

public struct Preferences: PreferencesProtocol {
    public var taskInterval: Int
    public var notifyTime: Int
    public var coolDown: Int
    public var isAutomationEnabled: Bool

    // Declare the initializer as public
    public init(
        taskInterval: Int,
        notifyTime: Int,
        coolDown: Int,
        isAutomationEnabled: Bool
    ) {
        self.taskInterval = taskInterval
        self.notifyTime = notifyTime
        self.coolDown = coolDown
        self.isAutomationEnabled = isAutomationEnabled
    }
}

public struct PreferencesUpdate: PreferencesUpdateProtocol {
    public var taskInterval: Int?
    public var notifyTime: Int?
    public var coolDown: Int?
    public var isAutomationEnabled: Bool?

    public init(
        taskInterval: Int? = nil,
        notifyTime: Int? = nil,
        coolDown: Int? = nil,
        isAutomationEnabled: Bool? = nil
    ) {
        self.taskInterval = taskInterval
        self.notifyTime = notifyTime
        self.coolDown = coolDown
        self.isAutomationEnabled = isAutomationEnabled
    }
}
