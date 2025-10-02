//
//  NoNetworkView.swift
//  MileageMaster
//
//  Created by Jesse Watson on 5/7/2024.
//

import SwiftUI

struct NoNetworkView: View {
    var body: some View {
        Text("Offline (updates will not be saved)")
            .foregroundColor(.white)
            .padding()
            .background(BlurView(style: .systemThinMaterial).opacity(0.8))
            .cornerRadius(8)
            .shadow(radius: 10)
            .onAppear() {
                let haptics = Haptics()
                haptics.error()
            }
    }
}
