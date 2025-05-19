//
//  eyedle.swift
//  eyedle
//
//  Created by 2qp on 2025-05-17.
//

import Foundation
import OSLog

//
if CommandLine.arguments.count < 5 {
    Logger(subsystem: "la.kuku.eyedle", category: "core").error(": Missing arguments")
    exit(1)
}

let execPath = CommandLine.arguments[0]
let bundlePath = CommandLine.arguments[1]
let bundleID = CommandLine.arguments[2]
let scriptPath = CommandLine.arguments[3]
let notifyTime = CommandLine.arguments[4]

//
let task = Process()
task.executableURL = URL(fileURLWithPath: "/bin/bash")
task.arguments = [scriptPath, bundlePath, bundleID, notifyTime]

do {
    try task.run()
    task.waitUntilExit()
} catch {
    exit(1)
}

exit(0)

// otherwise in background items [settings] eyedle shows as `sh`
