//
//  OverlayWindowController.swift
//  Controllers
//
//  Created by 2qp on 2025-05-03.
//

import AppKit
import Core
import SwiftUI

final class OverlayWindow: NSWindow {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
}

public final class OverlayWindowController: NSWindowController, NSWindowDelegate
{

    override init(window: NSWindow?) {
        super.init(window: window)
        self.window?.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public convenience init<Content>(content: @escaping () -> Content)
    where Content: View {
        let screen = NSScreen.main?.frame ?? .zero

        let screenFrame = screen.frame

        let window = OverlayWindow(
            contentRect: screen,
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )

        // Configure the window
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
        window.isReleasedWhenClosed = true

        // Setup SwiftUI Hosting View
        let hostingView = NSHostingView(rootView: content())

        hostingView.autoresizingMask = [.width, .height]
        hostingView.frame = screen

        window.contentView = hostingView

        // test this
        NSApp.presentationOptions = [
            .hideDock,
            .hideMenuBar,
            .disableForceQuit,
            .disableProcessSwitching,
            .disableSessionTermination,
            .disableHideApplication,
        ]

        self.init(window: window)
    }

    public func show() {
        window?.makeKeyAndOrderFront(nil)
        window?.orderFrontRegardless()
        NSApp.activate(ignoringOtherApps: true)
    }

    public func closeWindow() {
        // Close the window without quitting the app
        self.window?.close()
    }

    // MARK: - NSWindowDelegate

    public func windowWillClose(_ notification: Notification) {
        // Handle cleanup if needed

        #if DEBUG
            print("Window '$windowTitle)' is closing – cleaning up resources.")
        #endif

    }

    // MARK: - Deinit

    deinit {
        #if DEBUG
            print("OverlayWindowController deinitialized")
        #endif
    }
}
