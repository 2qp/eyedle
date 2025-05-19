//
//  Logger.swift
//  Core
//
//  Created by 2qp on 2025-05-19.
//


import OSLog

public extension Logger {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    private static let subsystem = Bundle.main.bundleIdentifier!
    
    /// Core
    static let core = Logger(subsystem: subsystem, category: "core")

    /// Logs the view cycles like a view that appeared.
    static let viewCycle = Logger(subsystem: subsystem, category: "viewcycle")

    /// All logs related to tracking and analytics.
    static let statistics = Logger(subsystem: subsystem, category: "statistics")
}
