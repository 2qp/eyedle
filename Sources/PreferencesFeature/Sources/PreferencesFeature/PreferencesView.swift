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
        taskInterval: 0,
        notifyTime: 0,
        coolDown: 0,
        isAutomationEnabled: false
    )
    @State private var isLoading = false
    @State private var error: String?

    @Environment(\.preferencesService) private var preferencesService
    @Environment(\.launchAgentService) private var launchAgentService

    let prefKey: String = "Preferences"

    public init() {

    }

    public var body: some View {

        VStack(spacing: 24) {
            Text("🔁 Eyedle Config")
                .font(.title2)
                .fontWeight(.semibold)

            Group {
                InputRow(label: "Notify Before", value: $preferences.notifyTime)
                InputRow(label: "Interval", value: $preferences.taskInterval)
                InputRow(label: "Overlay Time", value: $preferences.coolDown)
            }

            VStack(spacing: 12) {
                Button(action: {
                    savePreferences(
                        interval: preferences.taskInterval,
                        coolDown: preferences.coolDown,
                        notifyTime: preferences.notifyTime
                    )
                }) {
                    Text("💾 Save Preferences & Enable Automation")
                        .fontWeight(.medium)

                        .padding()
                        .background(Color.accentColor.opacity(0.2))
                        .cornerRadius(8)
                }

                Button(action: disableAutomation) {
                    Text("🛑 Disable Automation")
                        .fontWeight(.medium)
                        .foregroundColor(.red)
                }
            }
        }
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

    public func savePreferences(interval: Int, coolDown: Int, notifyTime: Int) {
        print(interval)

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
