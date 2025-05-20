//
//  GlassButton.swift
//  OverlayFeature
//
//  Created by 2qp on 2025-05-03.
//

import SwiftUI

public struct GlassButton: View {
    let dismissAction: (() -> Void)?

    public var body: some View {
        Button(action: {

            dismissAction?()

        }) {

            HStack(spacing: 6) {
                Text("Skip")
                    .fontWeight(.semibold)

                Image(systemName: "chevron.right.2")
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
            .foregroundColor(.white)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(
            PlainButtonStyle()
        )
    }
}
