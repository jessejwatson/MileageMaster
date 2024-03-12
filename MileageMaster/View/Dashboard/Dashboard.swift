//
//  Dashboard.swift
//  MileageMaster
//
//  Created by Jesse Watson on 09/03/2024.
//

import SwiftUI

struct Dashboard: View
{
    
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
            } catch {
                print(error)
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
    
    let mockData1: [(category: String, value: Double)] = [
        ("Test", 2.0),
        ("Test2", 5.0),
        ("Test3", 4.0)
    ]
    
    let mockData2: [(category: String, value: Double)] = [
        ("Test", 2.0),
        ("Test2", 0.5),
        ("Test3", 6.0)
    ]
    
    let mockData3: [(category: String, value: Double)] = [
        ("Test", 5.0),
        ("Test2", 8.0),
        ("Test3", 10.0)
    ]
    
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
                        ChartContainer(header: "Economy (L/100km)", graph: LineGraph(data: mockData1))
                        ChartContainer(header: "Fuel Price ($/L)", graph: LineGraph(data: dollarPerLiterData))
                        ChartContainer(header: "KM Cost ($/km)", graph: LineGraph(data: mockData3))
                        ForEach(cars)
                        {
                            car in
                            
                            Text(car.name)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.large)
            .onAppear()
            {
                loadCars()
                loadEntries()
                
                for entry in entries {
                    let category: String = String(format: "%f", entry.liters)
                    let dollarPerLiter = entry.totalPrice / entry.liters
                    dollarPerLiterData.append((category, dollarPerLiter))
                }
            }
        }
    }
}

#Preview {
    Dashboard()
}
