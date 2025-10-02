//
//  NewRefillLog.swift
//  MileageMaster
//
//  Created by Jesse Watson on 19/04/2024.
//

import SwiftUI

struct NewCar: View {
    
    @EnvironmentObject var mileageMasterData: MileageMasterData
    @Environment(\.presentationMode) var presentationMode
    
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
    @State private var year: Int? = nil
    @State private var serviceIntervalKM: Int? = nil
    @State private var serviceIntervalMonth: Int? = nil
    
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
                    
                    TextField("Year", value: $year, format: .number)
                        .keyboardType(.numberPad)
                        .padding()
                        .frame(width: 300)
                    
                    Section(header: Text("Service Interval")) {
                        
                        TextField("Months", value: $serviceIntervalMonth, format: .number)
                            .keyboardType(.numberPad)
                            .padding()
                            .frame(width: 300)
                        
                        TextField("Distance", value: $serviceIntervalKM, format: .number)
                            .keyboardType(.numberPad)
                            .padding()
                            .frame(width: 300)
                        
                    }
                    
                    
                }
                .scrollContentBackground(.hidden)
                .background(Colors.shared.popoverBackground)
                
                FullWidthButton("Create") {
                    if  name.count > 0 &&
                            plate.count > 0 &&
                            fuel.count > 0 &&
                            year != nil &&
                            serviceIntervalKM != nil &&
                            serviceIntervalMonth != nil
                    {
                        
                        let carController = CarController()
                        Task {
                            let createdCar = await carController.createCar(name: name, plate: plate, fuel: fuel, year: year!, serviceIntervalKM: serviceIntervalKM!, serviceIntervalMonth: serviceIntervalMonth!)
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
                    
                    FullWidthButton("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .padding()
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
        .background(Colors.shared.popoverBackground)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .default(Text("Dismiss"))
            )
        }
        
    }
}
