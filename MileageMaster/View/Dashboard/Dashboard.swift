//
//  Dashboard.swift
//  MileageMaster
//
//  Created by Jesse Watson on 09/03/2024.
//

import SwiftUI

struct Dashboard: View
{
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var cars: [Car] = []
    @State private var entries: [Entry] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    
    @State private var dollarPerLiterData: [(category: String, value: Double)] = []
    
    func loadCars()
    {
        isLoading = true
        Task {
            do {
                print("Fetching cars...")
                let operation = GraphQLOperation("{ cars { id plate name fuel } }")
                let cars: [Car] = try await GraphQLAPI().performOperation(operation)
                print("Finished fetching cars...")
                self.cars = cars
            } catch {
                print(error)
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
    
    func loadEntries()
    {
        isLoading = true
        Task {
            do {
                print("Fetching entries...")
                let operation = GraphQLOperation("{ entries { id odoPrev odoCurr liters totalPrice station notes } }")
                let entries: [Entry] = try await GraphQLAPI().performOperation(operation)
                print("Finished fetching entries...")
                self.entries = entries
                
                var num: Int = 0
                dollarPerLiterData.removeAll()
                
                for entry in entries {
                    let dollarPerLiter = entry.totalPrice / entry.liters
                    
                    print(num)
                    print(dollarPerLiter)
                    
                    dollarPerLiterData.append((String(num), dollarPerLiter))
                    
                    num = num + 1
                }
            } catch {
                print(error)
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
    
    var body: some View
    {
        
        NavigationView
        {
            ScrollView(showsIndicators: false)
            {
                VStack(spacing: 20)
                {
                    LazyVGrid(columns: [GridItem(.flexible())], spacing: 20)
                    {
//                        ChartContainer(header: "Economy (L/100km)", graph: LineGraph(data: mockData1))
                        ChartContainer(header: "Fuel Price ($/L)", graph: LineGraph(data: dollarPerLiterData))
//                        ChartContainer(header: "KM Cost ($/km)", graph: LineGraph(data: mockData3))
                        ForEach(cars)
                        {
                            car in
                            
                            Text(car.name + " - " + car.plate)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.large)
            .background(colorScheme == .light ? Color.secondary.opacity(0.15) : Color.black)
            .onAppear()
            {
                loadCars()
                loadEntries()
            }
        }
    }
}

#Preview {
    Dashboard()
}
