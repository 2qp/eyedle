//
//  OverlayProtocols.swift
//  Core
//
//  Created by 2qp on 2025-05-03.
//

import AppKit
import SwiftUI

@MainActor
public protocol OverlayWindowServiceProtocol {
    //

    func createOverlayWindow<Content: View>(content: @escaping () -> Content)
        -> NSWindow

    func configureOverlayWindow(window: NSWindow)
}
