//
//  OverlayWindowService.swift
//  OverlayFeature
//
//  Created by 2qp on 2025-05-03.
//

import Core
import SwiftUI

final class OverlayWindow: NSWindow {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
}

@MainActor
public class OverlayWindowService: OverlayWindowServiceProtocol {

    public init() {}

    public func configureOverlayWindow(window: NSWindow) {
        window.level = .screenSaver
        window.isOpaque = false
        window.backgroundColor = .clear
        window.collectionBehavior = [
            .canJoinAllSpaces,
            .fullScreenPrimary,
            .fullScreenAuxiliary,
            .stationary,
            .ignoresCycle,
            .transient,
        ].reduce([], { $0.union($1) })
        window.ignoresMouseEvents = false
        window.isReleasedWhenClosed = false

        NSApp.presentationOptions = [
            .hideDock,
            .hideMenuBar,
            .disableForceQuit,
            .disableProcessSwitching,
            .disableSessionTermination,
            .disableHideApplication,
        ]

    }

    public func createOverlayWindow<Content>(content: @escaping () -> Content)
        -> NSWindow where Content: View
    {
        guard let screen = NSScreen.main else {
            fatalError("No main screen found")
        }
        let screenFrame = screen.frame

        // 
        let window = OverlayWindow(
            contentRect: screenFrame,
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )

        // 
        let hostingView = NSHostingView(rootView: content())
        hostingView.frame = screenFrame
        window.contentView = hostingView

        // 
        configureOverlayWindow(window: window)
        return window
    }

}
