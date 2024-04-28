//
//  FullWidthButton.swift
//  MileageMaster
//
//  Created by Jesse Watson on 26/04/2024.
//

import SwiftUI

struct FullWidthButton: View {
    
    let text: String
    let action: () -> Void
    let color: Color
    
    init(_ text: String, action: @escaping () -> Void) {
        self.text = text
        self.action = action
        self.color = Colors.shared.accent
    }
    
    init(_ text: String, color: Color, action: @escaping () -> Void) {
        self.text = text
        self.action = action
        self.color = color
    }
    
    @State private var isPressed = false
    
    var body: some View {
        Text(text)
            .frame(maxWidth: .infinity)
            .padding()
            .background(isPressed ? color.opacity(0.8) : color)
            .foregroundStyle(.white)
            .cornerRadius(8)
            .scaleEffect(isPressed ? 0.95 : 1)
            .onTapGesture {
                self.action()
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ _ in self.isPressed = true })
                    .onEnded({ _ in self.isPressed = false })
            )
    }
}
