//
//  eyedleApp.swift
//  eyedle
//
//  Created by 2qp on 2025-05-01.
//

import OverlayFeature
import PreferencesFeature
import SwiftData
import SwiftUI

@main
struct eyedleApp: App {
    //
    @Environment(\.openWindow) var openWindow
    /// mmm osx 15
    //
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    let container: AppContainer

    init() {
        let container = AppContainer()
        self.container = container

        self.appDelegate.windowManager = container.windowManager
        self.appDelegate.preferencesService = container.preferencesService
        self.appDelegate.notificationService = container.notificationService

    }

    var body: some Scene {

        Window("Preferences", id: "preferences") {
            PreferencesView()

        }
        .defaultSize(width: 480, height: 350)
        .defaultLaunchBehavior(.suppressed)
        .handlesExternalEvents(matching: ["preferences"])
        .environment(\.preferencesService, container.preferencesService)
        .environment(\.launchAgentService, container.launchAgentService)
        .environment(\.fileManagerService, container.fileManagerService)

        MenuBarExtra("App Menu", systemImage: "eye") {

            //
            Button("Preferences") {
                openWindow(id: "preferences")
            }

            //
            Button("Overlay") {
                container.windowManager.showOverlayWindow(content: {

                    OverlayView().actionable {
                        // NSApplication.shared.terminate(nil)
                        container.windowManager.dismissAllWidows()
                    }
                })
            }

            //
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }

        }

    }

}
