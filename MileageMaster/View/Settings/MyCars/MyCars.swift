//
//  MyCars.swift
//  MileageMaster
//
//  Created by Jesse Watson on 14/03/2024.
//

import SwiftUI

struct MyCars: View {
    
    @EnvironmentObject var mileageMasterData: MileageMasterData
    
    // Show
    @State private var showNewCarSheet = false
    @State private var showConfirmationDialog = false
    
    // Alert
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    
    // Data
    @State private var selectedCar: Car? = nil
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
    
    func deleteCar(id: String) {
        Task{
            
            let carController = CarController()
            let deletedCar = await carController.deleteCar(id: id)
            
            if deletedCar != nil {
                let entryController = EntryController()
                await entryController.deleteManyEntries(id: id)
                let serviceContoller = ServiceController()
                await serviceContoller.deleteManyServices(id: id)
            } else {
                showAlert(title: "Error", message: "There was an error. Please try again.")
            }
            
        }
    }
    
    var body: some View {
        VStack {
            if mileageMasterData.cars != nil && mileageMasterData.cars!.count > 0 {
                
                // --- List of Cars
                
                List {
                    ForEach(mileageMasterData.cars!, id: \.id) { car in
                        
                        HStack {
                            VStack {
                                
                                Text(car.name)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.headline)
                                    .foregroundStyle(.gray)
                                    .fontWeight(.bold)
                                
                                HStack {
                                    Image(systemName: "licenseplate.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 15, height: 15)
                                        .foregroundStyle(.orange)
                                        .padding([.leading, .trailing], 4)
                                        .frame(alignment: .leading)
                                    Text(car.plate)
                                        .font(.subheadline)
                                        .foregroundStyle(.gray)
                                    Spacer()
                                }
                                
                                HStack {
                                    Image(systemName: "fuelpump.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 15, height: 15)
                                        .foregroundStyle(.blue)
                                        .padding([.leading, .trailing], 4)
                                        .frame(alignment: .leading)
                                    Text(car.fuel)
                                        .font(.subheadline)
                                        .foregroundStyle(.gray)
                                    Spacer()
                                }
                                
                            }
                            .frame(maxWidth: .infinity)
                            
                            Spacer()
                            
                            Button {
                                selectedCar = car
                            } label: {
                                Text("Edit")
                            }
                            
                        }
                        .swipeActions(edge: .trailing) {
                            
                            // --- Delete Car
                            
                            Button {
                                
                                selectedCar = car
                                showConfirmationDialog = true
                                
                            } label: {
                                
                                Image(systemName: "trash.fill")
                                
                            }
                            .tint(.red)
                            
                        }
                        
                    }
                }
                .navigationTitle("My Cars")
                .sheet(item: $selectedCar) { car in
                    CarView(car: car)
                }
                
            } else {
                
                // --- No Cars, Add a Car
                
                Text("Please add a car first.")
                    .font(.headline)
                    .fontWeight(.bold)
                    .navigationTitle("My Cars")
                    .onAppear() {
                        showNewCarSheet = true
                    }
                
            }
        }
        .toolbar {
            ToolbarItemGroup {
                AddButton(showSheet: $showNewCarSheet)
            }
        }
        .refreshable {
            let carController = CarController()
            carController.loadCars()
        }
        .sheet(isPresented: $showNewCarSheet) {
            NewCar()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .default(Text("Dismiss"))
            )
        }
        .confirmationDialog(
            "Are you sure you want to delete this car?\nAll refill logs and services associated with it will be lost.",
            isPresented: $showConfirmationDialog,
            titleVisibility: .visible
        ) {
            
            Button("Yes, delete the car and its logs and services", role: .destructive) {
                if selectedCar != nil {
                    deleteCar(id: String(selectedCar!.id))
                    let carController = CarController()
                    carController.loadCars()
                } else {
                    showAlert(title: "Error", message: "There was an error. Please try again.")
                }
            }
            
            Button("Cancel", role: .cancel) {}
            
        }
    }
}

//#Preview {
//    MyCars()
//}
