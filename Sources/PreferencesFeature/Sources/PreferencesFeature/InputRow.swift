//
//  InputRow.swift
//  PreferencesFeature
//
//  Created by 2qp on 2025-04-26.
//

import SwiftUI

public struct InputRow: View {
    let label: String
    @Binding var value: Int

    public init(label: String, value: Binding<Int>) {
        self.label = label
        self._value = value
    }

    public var body: some View {
        HStack {
            Text(label)
                .frame(width: 110, alignment: .leading)

            TextField("seconds", value: $value, format: .number)
                .textFieldStyle(.roundedBorder)

        }
    }
}
