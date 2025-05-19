//
//  LaunchAgentManagerProcotol.swift
//  Core
//
//  Created by 2qp on 2025-05-02.
//

import Foundation

public protocol LaunchAgentServiceProtocol {
    /// The label used for the launch agent (typically the app's bundle identifier)
    func getAgentLabel() -> String

    /// The file URL where the launch agent's `.plist` file should be stored
    func getPlistPath() -> URL

    /// Creates the dictionary representation of the launch agent `.plist`
    /// - Parameter interval: Interval in seconds between executions
    /// - Returns: A property list dictionary
    func createLaunchAgentPlist(interval: Int, notifyTime : Int) -> [String: Any]

    /// Installs the launch agent with the given interval
    /// - Parameter interval: Interval in seconds between executions
    /// - Throws: An error if installation fails
    func installLaunchAgent(interval: Int, notifyTime : Int) throws

    /// Uninstalls the launch agent if it exists
    /// - Throws: An error if uninstallation fails
    func uninstallLaunchAgent() throws

    /// Runs a shell command and returns its output
    /// - Parameters:
    ///   - command: Path to the executable
    ///   - arguments: Array of command-line arguments
    /// - Returns: Output of the command as a string, or nil if execution failed
    @discardableResult
    func runShellCommand(_ command: String, arguments: [String]) -> String?
}
