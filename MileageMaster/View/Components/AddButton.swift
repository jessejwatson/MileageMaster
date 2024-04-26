//
//  AddButton.swift
//  MileageMaster
//
//  Created by Jesse Watson on 26/04/2024.
//

import SwiftUI

struct AddButton: View {
    
    @Binding var showSheet: Bool
    
    var body: some View {
        Image(systemName: "plus.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 30, height: 30)
            .foregroundColor(.accentColor)
            .onTapGesture {
                showSheet = true
            }
    }
}
