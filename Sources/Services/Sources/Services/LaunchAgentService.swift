//
//  LaunchAgentManager.swift
//  Managers
//
//  Created by 2qp on 2025-05-02.
//

import Core
import Foundation
import OSLog

public struct LaunchAgentService: LaunchAgentServiceProtocol {

    // MARK: - Properties

    public init() {}

    public func getAgentLabel() -> String {

        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            fatalError("Unable to determine the app's bundle identifier.")
        }
        return bundleIdentifier

    }

    public func getPlistPath() -> URL {

        let agentLabel = self.getAgentLabel()

        return FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent("Library/LaunchAgents/\(agentLabel).plist")
    }

    // MARK: - Methods

    public func createLaunchAgentPlist(interval: Int, notifyTime: Int) -> [String: Any] {

        let agentLabel = getAgentLabel()
        let appURL = Bundle.main.bundleURL

        let shURL = appURL.appendingPathComponent(
            "Contents/Resources/eyedle.sh"
        )

        let execURL = appURL.appendingPathComponent(
            "Contents/Resources/eyedle"
        )

        return [
            "Label": agentLabel,
            "ProgramArguments": [
                //                "/bin/sh",
                execURL.path,
                Bundle.main.bundlePath,
                Bundle.main.bundleIdentifier ?? "",
                shURL.path,
                String(notifyTime),
            ],
            "StartInterval": interval,
            "RunAtLoad": true,
            "KeepAlive": false,
        ]
    }

    public func installLaunchAgent(interval: Int, notifyTime: Int) throws {

        print("Installing launch agent...\n")

        let plistPath = getPlistPath()

        print("Plist path: \(plistPath)")

        let newInterval = interval
        let plistDict = createLaunchAgentPlist(interval: newInterval, notifyTime: notifyTime)

        let plistData: Data
        do {
            plistData = try PropertyListSerialization.data(
                fromPropertyList: plistDict,
                format: .xml,
                options: 0
            )
        } catch {
            
            Logger.core.error("Failed to serialize plist: $error.localizedDescription)")
            
            
            throw NSError(
                domain: "LaunchAgentManager",
                code: 1,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "Failed to serialize plist: $error.localizedDescription)"
                ]
            )
        }

        do {
            try plistData.write(to: plistPath)
        } catch {
            throw NSError(
                domain: "LaunchAgentManager",
                code: 2,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "Failed to write plist to file: $error.localizedDescription)"
                ]
            )
        }

        //        _ = runShellCommand("/bin/launchctl", arguments: ["bootout", "gui/$getuid())", plistPath.path])
        //        _ = runShellCommand("/bin/launchctl", arguments: ["bootstrap", "gui/$getuid())", plistPath.path])
        // Unload the existing agent (if loaded)
        _ = runShellCommand(
            "/bin/launchctl",
            arguments: ["bootout", "gui/\(getuid())", plistPath.path]
        )

        // Load the new agent
        _ = runShellCommand(
            "/bin/launchctl",
            arguments: ["bootstrap", "gui/\(getuid())", plistPath.path]
        )
    }

    public func uninstallLaunchAgent() throws {

        print("Uninstalling launch agent...\n")

        let plistPath = getPlistPath()

        if FileManager.default.fileExists(atPath: plistPath.path) {
            _ = runShellCommand(
                "/bin/launchctl",
                arguments: ["unload", plistPath.path]
            )

            do {
                try FileManager.default.removeItem(at: plistPath)
            } catch {
                throw NSError(
                    domain: "LaunchAgentManager",
                    code: 3,
                    userInfo: [
                        NSLocalizedDescriptionKey:
                            "Failed to remove plist file: $error.localizedDescription)"
                    ]
                )
            }
        }
    }

    @discardableResult
    public func runShellCommand(_ command: String, arguments: [String])
        -> String?
    {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: command)
        task.arguments = arguments

        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe

        do {
            try task.run()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            return String(data: data, encoding: .utf8)?.trimmingCharacters(
                in: .whitespacesAndNewlines
            )
        } catch {
            print(
                "Failed to execute shell command: $error.localizedDescription)"
            )
            return nil
        }
    }
}
