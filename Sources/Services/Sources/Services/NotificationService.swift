//
//  NotificationService.swift
//  Services
//
//  Created by 2qp on 2025-05-03.
//

import AppKit
import Core
import Foundation
import UserNotifications

public class NotificationService: NSObject, ObservableObject,
    UNUserNotificationCenterDelegate, NotificationServiceProtocol
{
    public override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    // MARK: - Permissions

    public func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [
            .alert, .sound, .badge,
        ]) { granted, error in
            if granted {
                // print("Notification permission granted.")
            } else {
                // print("Notification permission denied: \(String(describing: error))")
            }
        }
    }

    // MARK: - Notification Scheduling

    public func scheduleNotification(title: String, body: String, pid: String) {
        // Define Skip Action
        let skipAction = UNNotificationAction(
            identifier: "skipAction",
            title: "Skip",
            options: .foreground
        )

        // Define Category with Skip Action
        let category = UNNotificationCategory(
            identifier: "skipCategory",
            actions: [skipAction],
            intentIdentifiers: [],
            options: []
        )

        // Register Category
        UNUserNotificationCenter.current().setNotificationCategories([category])

        // Configure Notification Content
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "skipCategory"
        content.userInfo = ["pid": pid]

        // Set Trigger (1 second)
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 1,
            repeats: false
        )

        // Create Request
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )

        // Schedule Notification
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                // print("Error scheduling notification: $error)")
            } else {
                // print("Notification scheduled.")
            }
        }
    }

    // MARK: - UNUserNotificationCenterDelegate

    /// Presents notification when app is in foreground.
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        return [.banner, .sound]
    }

    /// Handles user interaction with notifications.
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {

        // print("Notification received: $response.notification.request.content.body)")

        if response.actionIdentifier == "skipAction" {
            // Extract PID from userInfo
            let notificationContent = response.notification.request.content

            if let pidString = notificationContent.userInfo["pid"] as? String,
                let pid = Int(pidString)
            {
                // print("Received PID: $pid)")
                await sendSignal(pid: pidString)
            } else {
                // print("PID not found in notification.")
            }

            await terminateApp()
        }
    }

    // MARK: - Helpers

    /// Sends a SIGUSR1 signal to the specified process.
    /// - Parameter pid: Process ID as a String.
    public func sendSignal(pid: String) async {
        do {
            guard let pidInt = Int32(pid) else {
                // print("Invalid PID in file")
                return
            }

            let result = kill(pidInt, SIGUSR1)

            if result == 0 {
                // print("Signal sent successfully to PID $pidInt)")
            } else {
                // print("Failed to send signal to PID $pidInt)")
            }

        } catch {
            // print("Error reading PID file: $error)")
        }
    }

    @MainActor
    public func terminateApp() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            NSApplication.shared.terminate(nil)
        }
    }
}
