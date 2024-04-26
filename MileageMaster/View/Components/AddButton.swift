//
//  AddButton.swift
//  MileageMaster
//
//  Created by Jesse Watson on 26/04/2024.
//

import SwiftUI

struct AddButton: View {
    
    @Binding var showSheet: Bool
    @State private var isPressed = false
    
    var body: some View {
        Image(systemName: "plus.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 30, height: 30)
            .foregroundColor(.accentColor)
            .scaleEffect(isPressed ? 0.95 : 1)
            .onTapGesture {
                showSheet = true
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ _ in self.isPressed = true })
                    .onEnded({ _ in self.isPressed = false })
            )
    }
}
