//
//  Loader.swift
//  MileageMaster
//
//  Created by Jesse Watson on 15/04/2024.
//

import SwiftUI

struct Loader: View {
    
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        VStack() {
            ProgressView()
                .progressViewStyle(.circular)
                .padding(.bottom, 20)
            Text(text)
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    Loader("Loading data...")
}
