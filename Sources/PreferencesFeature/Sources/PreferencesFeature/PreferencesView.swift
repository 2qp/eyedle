//
//  PreferenceView.swift
//  PreferencesFeature
//
//  Created by 2qp on 2025-05-01.
//

import Core
import Services
import SwiftUI

public struct PreferencesView: View {

    @State private var preferences: PreferencesProtocol = Preferences(
        taskInterval: 1200,
        notifyTime: 10,
        coolDown: 30,
        isAutomationEnabled: false
    )
    @State private var isLoading = false
    @State private var error: String?

    @Environment(\.preferencesService) private var preferencesService
    @Environment(\.launchAgentService) private var launchAgentService
    @Environment(\.fileManagerService) private var fileManagerService

    let prefKey: String = "Preferences"

    public init() {}

    public var body: some View {

        VStack(alignment: .center, spacing: 24) {

            // Input Fields
            VStack(alignment: .leading, spacing: 16) {
                InputRow(label: "Notify Before", value: $preferences.notifyTime)
                InputRow(label: "Interval", value: $preferences.taskInterval)
                InputRow(label: "Overlay Time", value: $preferences.coolDown)
            }

            // Buttons
            VStack(spacing: 8, ) {

                //
                Button(action: {
                    savePreferences(
                        interval: preferences.taskInterval,
                        coolDown: preferences.coolDown,
                        notifyTime: preferences.notifyTime
                    )
                }) {
                    Text("Save Preferences & Enable Automation")

                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                //
                Button(action: disableAutomation) {
                    Text("Disable Automation")

                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }
            .padding(.top, 8)

            // Repository
            HStack {

                Spacer()

                Link(destination: URL(string: "https://github.com/2qp/eyedle")!)
                {
                    Image("github-mark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)

                }.pointerStyle(.link)

            }

        }
        .padding(24)
        .frame(width: 400, height: 300)

        //

        .task {
            guard let preferencesService = preferencesService else { return }

            do {
                //
                preferences = try preferencesService.getSettings(prefKey)
            } catch {
                print("Error fetching preferences: \(error)")
            }
        }

    }

    public func prepareDirectories() {
        // Define paths
        let preScriptsDir = "documents/eyedle/pre"
        let postScriptsDir = "documents/eyedle/post"

        // Create the directories
        let preDirCreated = fileManagerService?.createDirectoryIfNeeded(
            at: preScriptsDir
        )
        let postDirCreated = fileManagerService?.createDirectoryIfNeeded(
            at: postScriptsDir
        )
    }

    public func savePreferences(interval: Int, coolDown: Int, notifyTime: Int) {

        guard let agent = launchAgentService else { return }
        guard let preferencesService = preferencesService else { return }

        let pref = Preferences(
            taskInterval: interval,
            notifyTime: notifyTime,
            coolDown: coolDown,
            isAutomationEnabled: true
        )
        preferences = pref
        preferencesService.setSettings(prefKey, pref)

        //
        do {
            try agent.uninstallLaunchAgent()
        } catch {
            print("Uninstallation failed: \(error.localizedDescription)")
        }

        //
        do {
            try agent.installLaunchAgent(
                interval: interval,
                notifyTime: notifyTime
            )
        } catch {
            print("Installation failed: \(error.localizedDescription)")
        }

        //
        do {
            try prepareDirectories()
        } catch {
            print("Error preparing directories: \(error)")
        }

    }

    public func disableAutomation() {

        guard let agent = launchAgentService else { return }
        guard let preferencesService = preferencesService else { return }

        let savedPref = preferencesService.updateSettings(
            prefKey,
            preferences,
            PreferencesUpdate(isAutomationEnabled: false)
        )

        preferences = savedPref

        do {
            try agent.uninstallLaunchAgent()
        } catch {
            print("Uninstallation failed: \(error.localizedDescription)")
        }
    }
}

#Preview { PreferencesView() }
