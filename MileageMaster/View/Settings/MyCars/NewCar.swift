//
//  NewRefillLog.swift
//  MileageMaster
//
//  Created by Jesse Watson on 19/04/2024.
//

import SwiftUI

struct NewCar: View {
    
    @EnvironmentObject var mileageMasterData: MileageMasterData
    
    private var preferedCarID: String?
    
    init() {
        self.preferedCarID = nil
    }
    
    init(preferedCarID: String?) {
        self.preferedCarID = preferedCarID
    }
    
    // Data
    @State private var name: String = ""
    @State private var plate: String = ""
    @State private var fuel: String = ""
    
    // Alert
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    
    // Success
    @State private var showSuccess = false
    @State private var successOpacity = 0.0
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
    
    var body: some View {
        
        VStack {
            
            if showSuccess == false {
                
                
                Text("New Car")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Form {
                    
                    
                    TextField("Name", text: $name)
                        .padding()
                        .frame(width: 300)
                    
                    TextField("Plate", text: $plate)
                        .padding()
                        .frame(width: 300)
                    
                    TextField("Fuel", text: $fuel)
                        .padding()
                        .frame(width: 300)
                    
                    
                }
                .scrollContentBackground(.hidden)
                .background(Colors.shared.background)
                
                FullWidthButton("Create") {
                    if  name.count > 0 &&
                            plate.count > 0 &&
                            fuel.count > 0
                    {
                        
                        let carController = CarController()
                        Task {
                            let createdCar = await carController.createCar(name: name, plate: plate, fuel: fuel, year: 2000, serviceIntervalKM: 5000, serviceIntervalMonth: 12)
                            if createdCar == nil {
                                showAlert(title: "Unknown Error", message: "There was an error. Please try again.")
                            } else {
                                carController.loadCars()
                                showSuccess = true
                            }
                        }
                        
                    } else {
                        
                        showAlert(title: "You're Not Done!", message: "Please fill out the required fields.")
                        
                    }
                }
                
                Spacer()
                
            } else {
                VStack {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(Colors.shared.accent)
                        .padding(.bottom)
                    Text("Car Creation Successful!")
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .opacity(successOpacity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .onAppear() {
                    withAnimation(.easeIn(duration: 1)) {
                        successOpacity = 1.0
                    }
                }
            }
            
        }
        .padding()
        .background(Colors.shared.background)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .default(Text("Dismiss"))
            )
        }
        
    }
}
