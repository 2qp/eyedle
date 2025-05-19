//
//  OverlayView.swift
//  OverlayFeature
//
//  Created by 2qp on 2025-05-03.
//

import AppKit
import Core
import SwiftUI

public struct OverlayView: ActionableProtocol {
    public var action: (() -> Void)?

    public init(action: (() -> Void)? = nil) {
        self.action = action
    }

    public var body: some View {
        ZStack {
            // Background
            DesktopWallpaperView()
                .ignoresSafeArea()

            //
            VStack {
                //
                DateTimeView()
                    .padding(.top, 40)

                Spacer()

                VStack(spacing: 24) {
                    Text("⏳ Look Away!")
                        .font(.largeTitle)
                        .foregroundColor(.white)

                    GlassButton(dismissAction: action)
                }

                Spacer()

                //
                AutoCountdownView(dismissAction: action)
                    .padding(.bottom, 40)
            }
            .padding()
        }
        .focusable(true)
        .focusEffectDisabled()
        .onKeyPress(
            .escape,
            phases: .repeat,
            action: { keyPress in
                action?()
                return .handled
            }
        )

    }
}

struct OverlayView_Previews: PreviewProvider {
    static var previews: some View {
        OverlayView()
            .previewDevice("Mac")
            .frame(width: 800, height: 500)
    }
}
