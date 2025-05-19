//
//  NotificationServiceProtocol.swift
//  Core
//
//  Created by 2qp on 2025-05-03.
//

import UserNotifications

public protocol NotificationServiceProtocol {

    func requestPermission()

    func scheduleNotification(title: String, body: String, pid: String)

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async

    func sendSignal(pid: String) async

    @MainActor
    func terminateApp()
}
