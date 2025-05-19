//
//  ActionableProtocol.swift
//  Core
//
//  Created by 2qp on 2025-05-03.
//

import AppKit
import SwiftUI

public protocol ActionableProtocol: View {
    var action: (() -> Void)? { get set }
}
