//
//  AppDelegate.swift
//  eyedle
//
//  Created by 2qp on 2025-05-04.
//

import AppKit
import Core
import OverlayFeature

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {

    var windowManager: (any WindowManagerProtocol)?
    var notificationService: NotificationServiceProtocol?
    var preferencesService: (any PreferencesServiceProtocol)?

    func application(_ application: NSApplication, open urls: [URL]) {
        //

        for url in urls {
            //

            if url.host == "overlay" {

                windowManager?.showOverlayWindow(content: {

                    OverlayView().actionable {
                        NSApplication.shared.terminate(nil)
                        self.windowManager?.dismissAllWidows()

                    }.environment(\.preferencesService, self.preferencesService)
                })

            }

            //
            if url.host == "dispatch" {

                if let pid = url.queryParameters?["pid"] {

                    notificationService?.scheduleNotification(
                        title: "Incoming Eyedle Time",
                        body: "dude just give it a rest",
                        pid: pid
                    )

                }

            }

            //
        }
    }

    func applicationDidFinishLaunching(_ notification: Notification) {

        #if DEBUG
            print("AppDelegate did finish launching")
        #endif

        notificationService?.requestPermission()
    }
}
