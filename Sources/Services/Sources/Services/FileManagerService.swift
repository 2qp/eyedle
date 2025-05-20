//
//  FileManagerService.swift
//  Services
//
//  Created by 2qp on 2025-05-20.
//

import Core
import Foundation
import OSLog

public struct FileManagerService: FileManagerServiceProtocol {

    private let fileManager: FileManager
    private let homeDirectory: URL

    public init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
        self.homeDirectory = fileManager.homeDirectoryForCurrentUser
    }

    // Create a directory if it doesn't exist
    public func createDirectoryIfNeeded(at path: String) -> Bool {
        let directoryURL = homeDirectory.appendingPathComponent(path)

        if !fileManager.fileExists(atPath: directoryURL.path) {
            do {
                try fileManager.createDirectory(
                    at: directoryURL,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
                // print("Created directory: \(directoryURL.path)")
                return true
            } catch {

                Logger.core.error(
                    "Error creating directory \(directoryURL.path): \(error)"
                )

                return false
            }
        } else {
            // print("Directory already exists: \(directoryURL.path)")
            return true
        }
    }
}
