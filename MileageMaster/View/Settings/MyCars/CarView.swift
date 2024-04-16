//
//  CarView.swift
//  MileageMaster
//
//  Created by Jesse Watson on 14/03/2024.
//

import SwiftUI

struct CarView: View {
    
    let car: Car
    
    var body: some View {
        Text(car.name)
            .font(.title)
            .padding(.top, 20)
        Text(car.plate)
            .font(.subheadline)
        Text(car.fuel)
            .font(.subheadline)
            .foregroundStyle(.secondary)
        Spacer()
    }
}

//#Preview {
//    CarView()
//}
