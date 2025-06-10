import SwiftUI
//
//  ThemeButton.swift
//  hello-test
//
//  Created by Mehmet Fatih Durdu on 10.06.2025.
//


struct ThemeButton: View {
    var theme: String
    var isSelected: Bool
    var onSelect: () -> Void

    var body: some View {
        Button(action: {
            withAnimation { onSelect() }
        }) {
            HStack(spacing: 14) {
                Image(systemName: themeIcon(for: theme))
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : .blue)
                Text(theme)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(isSelected ? .white : .blue)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                }
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 18)
            .background(isSelected ? Color.blue.opacity(0.95) : Color.gray.opacity(0.13))
            .cornerRadius(18)
            .shadow(color: isSelected ? Color.blue.opacity(0.18) : .clear, radius: 6, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
