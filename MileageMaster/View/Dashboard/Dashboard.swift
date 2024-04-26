//
//  Dashboard.swift
//  MileageMaster
//
//  Created by Jesse Watson on 09/03/2024.
//

import SwiftUI

struct Dashboard: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var mileageMasterData: MileageMasterData
    
    @State private var showAddOptions = false
    @State private var showNewService = false
    @State private var showNewRefill = false
    
    var body: some View {
        
        NavigationView {
            
            if mileageMasterData.account == nil || mileageMasterData.cars == nil || mileageMasterData.entries == nil || mileageMasterData.services == nil {
                
                Loader("LOADING")
                
            } else {
                
                ScrollView {
                    
                    VStack {
                        
                        // --- Last 3 Entries
                        
                        LazyVStack(spacing: 0) {
                            ForEach(Array(mileageMasterData.entries!.reversed().prefix(3).enumerated()), id: \.element.id) { index, entry in
                                
                                EntryListItem(entry)
                                    .padding()
                                    .contextMenu { } preview: {
                                        EntryView(entry)
                                    }
                                
                                if index != mileageMasterData.entries!.reversed().prefix(3).count - 1 {
                                    Divider()
                                }
                                
                            }
                        }
                        .background(Colors.shared.backgroundSecondary)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: colorScheme == .light ? .gray.opacity(0.3) : .clear, radius: colorScheme == .light ? 5 : 0, x: 0, y: 0)
                        .padding()
                        
                        // --- Graphs
                        
                        if mileageMasterData.cars != nil && mileageMasterData.entries != nil {
                            ForEach(mileageMasterData.cars!, id: \.id) { car in
                                
                                EconomyGraph(car: car)
                                DollarPerKMGraph(car: car)
                                DollarPerLiterGraph(car: car)
                                
                            }
                        }
                        
                        Spacer()
                        
                    }
                    
                }
                .navigationTitle("Dashboard")
                .toolbar {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        AddButton(showSheet: $showAddOptions)
                    }
                }
                .padding([.leading, .trailing])
                .scrollIndicators(.hidden)
                
            }
            
        }
        .refreshable {
            let carController = CarController()
            carController.loadCars()
            
            let entryController = EntryController()
            entryController.loadEntries()
            
            let serviceController = ServiceController()
            serviceController.loadServices()
        }
        .confirmationDialog(
            "What would you like to add?",
            isPresented: $showAddOptions,
            titleVisibility: .visible
        ) {
            Button("New Refill") {
                showNewRefill = true
            }
            Button("New Service") {
                showNewService = true
            }
        }
        .sheet(isPresented: $showNewService) {
            Loader("Waiting for developer to do something here...")
                .onDisappear() {
                    showNewService = false
                }
        }
        .sheet(isPresented: $showNewRefill) {
            NewRefillLog()
                .onDisappear() {
                    showNewRefill = false
                }
        }
    }
}

struct EconomyGraph: View {
    
    let car: Car
    
    @EnvironmentObject var mileageMasterData: MileageMasterData
    
    @State var data: [(category: String, value: Double)] = []
    @State var entries: [Entry] = []
    @State var notLoaded: Bool = true
    
    func loadData() {
        data.removeAll()
        if mileageMasterData.entries != nil {
            for entry in mileageMasterData.entries! {
                if entry.car.id == car.id {
                    let value: Double = entry.liters * 100 / Double((entry.odoCurr - entry.odoPrev))
                    let datum: (category: String, value: Double) = (category: entry.createdAt, value: value)
                    data.append(datum)
                    entries.append(entry)
                }
            }
        }
    }
    
    var body: some View {
        if mileageMasterData.entries != nil {
            if entries.count > 0 || notLoaded == true {
                ChartContainer(header: "Economy for \(car.name)", graph: LineGraph(data: data))
                    .onAppear() {
                        loadData()
                        notLoaded = false
                    }
            }
        }
    }
    
}

struct DollarPerLiterGraph: View {
    
    let car: Car
    
    @EnvironmentObject var mileageMasterData: MileageMasterData
    
    @State var data: [(category: String, value: Double)] = []
    @State var entries: [Entry] = []
    @State var notLoaded: Bool = true
    
    func loadData() {
        data.removeAll()
        if mileageMasterData.entries != nil {
            for entry in mileageMasterData.entries! {
                if entry.car.id == car.id {
                    let value: Double = entry.totalPrice / entry.liters
                    let datum: (category: String, value: Double) = (category: entry.createdAt, value: value)
                    data.append(datum)
                    entries.append(entry)
                }
            }
        }
    }
    
    var body: some View {
        if mileageMasterData.entries != nil {
            if entries.count > 0 || notLoaded == true {
                ChartContainer(header: "Dollar Per Liter for \(car.name)", graph: LineGraph(data: data))
                    .onAppear() {
                        loadData()
                        notLoaded = false
                    }
            }
        }
    }
    
}

struct DollarPerKMGraph: View {
    
    let car: Car
    
    @EnvironmentObject var mileageMasterData: MileageMasterData
    
    @State var data: [(category: String, value: Double)] = []
    @State var entries: [Entry] = []
    @State var notLoaded: Bool = true
    
    func loadData() {
        data.removeAll()
        if mileageMasterData.entries != nil {
            for entry in mileageMasterData.entries! {
                if entry.car.id == car.id {
                    let value: Double = entry.totalPrice / Double(entry.odoCurr - entry.odoPrev)
                    let datum: (category: String, value: Double) = (category: entry.createdAt, value: value)
                    data.append(datum)
                    entries.append(entry)
                }
            }
        }
    }
    
    var body: some View {
        if mileageMasterData.entries != nil {
            if entries.count > 0 || notLoaded == true {
                ChartContainer(header: "Dollar Per KM for \(car.name)", graph: LineGraph(data: data))
                    .onAppear() {
                        loadData()
                        notLoaded = false
                    }
            }
        }
    }
    
}

#Preview {
    Dashboard()
}
