//
//  Dashboard.swift
//  MileageMaster
//
//  Created by Jesse Watson on 09/03/2024.
//

import SwiftUI

struct Dashboard: View {
    
    @EnvironmentObject var mileageMasterData: MileageMasterData
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                HStack {
                    
                    Spacer()
                    
                    OpenViewBtn(icon: "plus.circle.fill", text: "New Service") {
                        Loader("testing...")
                    }
                    
                    Spacer()
                    
                    OpenViewBtn(icon: "fuelpump.fill", text: "New Refill", color: Color.orange) {
                        NewRefillLog()
                    }
                    
                    Spacer()
                    
                }
                .padding(.bottom)
                
                ScrollView {
                    VStack {
                        
                        Text("Upcoming")
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Temporary data for upcoming reminders
                        let mockReminderData: [String] = ["Service Due!", "You must be gettin low on fuel."]
                        
                        LazyVStack(spacing: 0) {
                            ForEach(mockReminderData, id: \.self) { reminder in
                                HStack {
                                    Image(systemName: "bell.fill")
                                        .foregroundStyle(.yellow)
                                    Text(reminder)
                                    Spacer()
                                }
                                .padding()
                                Divider()
                            }
                        }
                        .background(Color(UIColor.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 0)
                        .padding()
                        
                        Spacer()
                        
                        Text("Recent")
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        LazyVStack(spacing: 0) {
                            ForEach(Array(mileageMasterData.entries!.reversed().prefix(3).enumerated()), id: \.element.id) { index, entry in
                                
                                EntryListItem(entry)
                                    .padding()
                                
                                if index != mileageMasterData.entries!.reversed().prefix(3).count - 1 {
                                    Divider()
                                }
                                
                            }
                        }
                        .background(Color(UIColor.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 0)
                        .padding()
                        
                        // graphs here...
                        // -- Liters Per 100km
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
                
            }
            .padding(.leading)
            .padding(.trailing)
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
