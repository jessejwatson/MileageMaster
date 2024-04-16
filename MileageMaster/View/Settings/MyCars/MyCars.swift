//
//  MyCars.swift
//  MileageMaster
//
//  Created by Jesse Watson on 14/03/2024.
//

import SwiftUI

struct MyCars: View {
    
    let cars: [Car]
    
    @State private var selectedCar: Car? = nil
    
    var body: some View {
        NavigationView
        {
            if cars.isEmpty == false
            {
                List
                {
                    ForEach(cars, id: \.id)
                    { car in
                        Button(car.name)
                        {
                            selectedCar = car
                        }
                    }
                }
                .navigationTitle("My Cars")
                .navigationBarTitleDisplayMode(.inline)
                .sheet(item: $selectedCar)
                { car in
                    CarView(car: car)
                }
            }
            else
            {
                Text("Loading...")
                    .navigationTitle("My Cars")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

//#Preview {
//    MyCars()
//}
