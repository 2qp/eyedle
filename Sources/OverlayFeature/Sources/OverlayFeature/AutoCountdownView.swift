//
//  AutoCountdownView.swift
//  OverlayFeature
//
//  Created by 2qp on 2025-04-27.
//

import Core
import Foundation
import SwiftUI

public struct AutoCountdownView: View {

    @Environment(\.preferencesService) private var preferencesService

    let dismissAction: (() -> Void)?

    @State private var targetDate: Date = {
        let fallbackDuration: TimeInterval = 5 * 60  // 5 minutes
        return Date().addingTimeInterval(fallbackDuration)
    }()

    public var body: some View {
        VStack {
            TimelineView(.periodic(from: .now, by: 1)) { context in
                let remaining = max(
                    0,
                    targetDate.timeIntervalSince(context.date)
                )

                if remaining == 0 {
                    // 
                    DispatchQueue.main.async {
                        dismissAction?()
                    }

                }

                return Text(formatTime(remaining))
                    .font(.system(size: 60, weight: .bold, design: .monospaced))
                    .monospacedDigit()
            }
        }
        .onAppear {
            setupTargetDate()
        }
    }

    private func setupTargetDate() {
        guard let preferencesService = preferencesService else { return }

        let prefInterval = preferencesService.getAllSettings().coolDown

        let cooldown = TimeInterval(prefInterval)
        targetDate = Date().addingTimeInterval(cooldown)
    }

    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let totalSeconds = Int(timeInterval)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60

        return hours > 0
            ? String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            : String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    AutoCountdownView(dismissAction: {})
        .frame(width: 300, height: 100)
}
