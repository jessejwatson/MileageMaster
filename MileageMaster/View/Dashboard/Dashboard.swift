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
    
    private func getServiceDue(lastService: Service) -> String {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        guard let lastServiceDate = inputFormatter.date(from: lastService.date) else {
            print("There was an error getting the service date.")
            return "could not calculate next service"
        }
        
        let calendar = Calendar.current
        guard let nextServiceDate = calendar.date(byAdding: .month, value: lastService.car.serviceIntervalMonth, to: lastServiceDate) else {
            print("There was an error creating the next service date.")
            return "could not calculate next service"
        }
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMMM yyyy"
        let nextServiceDateFormatted = outputFormatter.string(from: nextServiceDate)
        
        let nextServiceKM = lastService.odo + lastService.car.serviceIntervalKM
        
        return "\(nextServiceDateFormatted) or at \(nextServiceKM) kilometers"
        
    }
    
    var body: some View {
        
        NavigationView {
            
            if mileageMasterData.account == nil || mileageMasterData.cars == nil || mileageMasterData.entries == nil || mileageMasterData.services == nil {
                
                Loader("LOADING")
                
            } else {
                
                ScrollView {
                    
                    VStack {
                        
                        // --- Last Service
                        
                        LazyVStack(spacing: 0) {
                            
                            Text("Last Service")
                                .font(.headline)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.leading, .top, .trailing])
                            
                            if mileageMasterData.services!.count > 0 {
                                
                                let lastService = mileageMasterData.services!.reversed()[0]
                                
                                ServiceListItem(lastService)
                                    .padding([.leading, .trailing])
                                    .padding([.top, .bottom], 4)
                                
                                Divider()
                                
                                HStack {
                                    Text("Next Service:")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundStyle(Colors.shared.textSecondary)
                                               
                                    
                                    Text(getServiceDue(lastService: lastService))
                                        .font(.caption)
                                        .foregroundStyle(Colors.shared.textSecondary)
                                    
                                    Spacer()
                                }
                                .padding([.leading, .top, .trailing])
                                
                            } else {
                                Text("You have no services yet.")
                                    .font(.subheadline)
                                    .foregroundStyle(Colors.shared.textSecondary)
                                    .padding()
                            }
                        }
                        .padding(.bottom)
                        .background(Colors.shared.backgroundSecondary)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: colorScheme == .light ? .gray.opacity(0.3) : .clear, radius: colorScheme == .light ? 5 : 0, x: 0, y: 0)
                        .padding([.leading, .trailing])
                        
                        // --- Last 2 Entries
                        
                        LazyVStack(spacing: 0) {
                            
                            Text("Recent Refill Logs")
                                .font(.headline)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.leading, .top, .trailing])
                            
                            ForEach(Array(mileageMasterData.entries!.reversed().prefix(2).enumerated()), id: \.element.id) { index, entry in
                                
                                EntryListItem(entry)
                                    .padding([.leading, .trailing])
                                    .padding([.top, .bottom], 4)
                                
                                /*if index != mileageMasterData.entries!.reversed().prefix(2).count - 1 {
                                    Divider()
                                }*/
                                
                            }
                            
                        }
                        .padding(.bottom)
                        .background(Colors.shared.backgroundSecondary)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: colorScheme == .light ? .gray.opacity(0.3) : .clear, radius: colorScheme == .light ? 5 : 0, x: 0, y: 0)
                        .padding([.leading, .trailing])
                        
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
            NewService()
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
