//
//  CardView.swift
//  BudgetTracker
//
//  Created by shah on 24.9.2024.
//
import SwiftUI

struct CardView<Content: View>: View {
    var onTap: () -> Void
    var onLongPress: (() -> Void)? = nil
    var content: Content
    @State private var isPressed = false

    init(onTap: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.onTap = onTap
        self.content = content()
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(isPressed ? Color(.systemGray5) : Color(.systemGray6))
                .shadow(color: Color.black.opacity(isPressed ? 0 : 0.2), radius: 5, x: 0, y: 5)
                .scaleEffect(isPressed ? 0.99 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isPressed)

            content
                .padding()
                .scaleEffect(isPressed ? 0.99 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isPressed)
        }
        .onTapGesture {
            onTap()
        }
        .onLongPressGesture(minimumDuration: 0.1, pressing: { pressing in
            withAnimation {
                isPressed = pressing
            }
        }, perform: {
            onLongPress?()
        })
    }
}
