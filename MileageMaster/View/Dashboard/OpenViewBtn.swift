//
//  DashboardBtn.swift
//  MileageMaster
//
//  Created by Jesse Watson on 16/04/2024.
//

import SwiftUI

struct OpenViewBtn<Content: View>: View {
    
    let icon: String?
    let text: String
    let color: Color
    let view: Content
    
    @State var sheetIsOpen: Bool = false
    
    init (icon: String?, text: String, @ViewBuilder view: () -> Content) {
        self.icon = icon
        self.text = text
        self.color = Color.accentColor
        self.view = view()
    }
    
    init(icon: String?, text: String, color: Color, @ViewBuilder view: () -> Content) {
        self.icon = icon
        self.text = text
        self.color = color
        self.view = view()
    }
    
    var body: some View {
        
        Button() {
            print("clicked")
            sheetIsOpen = true
        } label: {
            HStack() {
                if icon != nil {
                    Image(systemName: icon!)
                        .padding(.leading)
                        .padding(.top)
                        .padding(.bottom)
                        .foregroundColor(color)
                    Text(text)
                        .padding(.trailing)
                        .padding(.top)
                        .padding(.bottom)
                        .foregroundColor(color)
                } else {
                    Text(text)
                        .padding()
                        .foregroundColor(color)
                }
            }
            .background(Color.secondary.opacity(0.3))
            .cornerRadius(12)
        }
        .sheet(isPresented: $sheetIsOpen) {
            view
                .onDisappear() {
                    sheetIsOpen = false
                }
        }
    
    }
}

//#Preview {
//    OpenViewBtn(icon: "plus.circle.fill", text: "New Entry")
//}
