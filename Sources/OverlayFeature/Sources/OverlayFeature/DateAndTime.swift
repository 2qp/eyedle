//
//  DateAndTime.swift
//  OverlayFeature
//
//  Created by 2qp on 2025-05-18.
//

import SwiftUI

public struct DateTimeView: View {
    // 
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM"  // "Sun, 18 May"
        return formatter
    }

    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"  // "23:33"
        return formatter
    }

    public var body: some View {
        TimelineView(.everyMinute) { context in
            VStack(spacing: 10) {
                Text(dateFormatter.string(from: context.date))
                    .font(
                        .system(size: 48, weight: .bold, design: .rounded)
                    )  // Date part: "Sun, 18 May"
                    .foregroundColor(.white)

                Text(timeFormatter.string(from: context.date))
                    .font(
                        .system(size: 90, weight: .bold, design: .rounded)
                    )  // Time part: "23:33"
                    .foregroundColor(.white)
            }
        }

    }
}

struct DateTimeView_Previews: PreviewProvider {
    static var previews: some View {
        DateTimeView()
            .previewDevice("Mac")
            .frame(width: 400, height: 200)
    }
}
