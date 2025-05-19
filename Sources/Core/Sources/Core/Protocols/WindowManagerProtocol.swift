//
//  WindowManagerProtocol.swift
//  Core
//
//  Created by 2qp on 2025-05-01.
//

import AppKit
import Foundation
import SwiftUI

@MainActor
public protocol WindowManagerProtocol: ObservableObject {

//    func showPrefferencesWindow<Content: View>(content: @escaping () -> Content)

    func showOverlayWindow<Content: View>(content: @escaping () -> Content)
    
    func dismissAllWidows() -> Void

}
