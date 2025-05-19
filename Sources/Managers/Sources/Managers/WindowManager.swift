//
//  WindowManager.swift
//  Managers
//
//  Created by 2qp on 2025-05-01.
//

import AppKit
import Controllers
import Core
import SwiftUI

@MainActor
public final class WindowManager: WindowManagerProtocol {

    private var action: (() -> Void)?  // mmm any immutable ways ?

    public init() {}

    //    public func showPrefferencesWindow<Content>(
    //        content: @escaping () -> Content
    //    ) where Content: View {
    //
    //
    //        controller.show()
    //    }

    public func showOverlayWindow<Content>(content: @escaping () -> Content)
    where Content: View {

        let controller = OverlayWindowController(content: content)

        action = controller.closeWindow

        controller.show()

    }

    public func dismissAllWidows() {

        NSApp.presentationOptions = []

        action?()

        action = nil

    }

}
