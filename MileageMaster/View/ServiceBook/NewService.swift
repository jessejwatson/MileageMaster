//
//  NewRefillLog.swift
//  MileageMaster
//
//  Created by Jesse Watson on 19/04/2024.
//

import SwiftUI

struct NewService: View {
    
    @EnvironmentObject var mileageMasterData: MileageMasterData
    @Environment(\.presentationMode) var presentationMode
    
    private var preferedCarID: String?
    
    init() {
        self.preferedCarID = nil
    }
    
    init(preferedCarID: String?) {
        self.preferedCarID = preferedCarID
    }
    
    @State private var carID: String? = nil
    @State private var date: Date = Date()
    @State private var odo: Int? = nil
    @State private var totalPrice: Double? = nil
    @State private var oil: String = ""
    @State private var notes: String = ""
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var showSuccess = false
    
    @State private var successOpacity = 0.0
    
    public struct TextArea: TextFieldStyle {
        public func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
                .padding([.top, .bottom], 50)
                .padding([.leading, .trailing], 5)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .strokeBorder(Color.primary.opacity(0.1))
                )
        }
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
    
    private func getLastOdo() -> Int? {
        if let lastService = mileageMasterData.services?.filter({ $0.car.id == carID }).last {
            return lastService.odo
        } else {
            return nil
        }
    }
    
    private func createService() {
        let serviceController = ServiceController()
        Task {
            let createdService: Service? = await serviceController.createService(date: date, odo: odo!, totalPrice: totalPrice!, oil: oil, notes: notes, carID: carID!)
            if createdService == nil {
                showAlert(title: "Unknown Error", message: "There was an error. Please try again.")
            } else {
                serviceController.loadServices()
                showSuccess = true
            }
        }
    }
    
    var body: some View {
        
        VStack {
            
            if showSuccess == false {
                
                if mileageMasterData.cars != nil ||
                    mileageMasterData.cars?.count != 0 {
                    
                    Text("New Service")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Form {
                        
                        Section(header: Text("Car")) {
                            
                            Picker("Select Car", selection: $carID) {
                                Text("None").tag(String?.none)
                                ForEach(mileageMasterData.cars!, id: \.id) { car in
                                    Text(car.name).tag(car.id as String?)
                                }
                            }
                            .pickerStyle(.menu)
                            
                            HStack {
                                
                                if let car = mileageMasterData.cars!.filter({ $0.id == carID }).first {
                                    
                                    Spacer()
                                    
                                    VStack {
                                        
                                        Text("Plate")
                                            .font(.subheadline)
                                            .foregroundStyle(.gray)
                                            .fontWeight(.bold)
                                        
                                        Text(car.plate)
                                            .font(.subheadline)
                                            .foregroundStyle(.gray)
                                        
                                    }
                                    
                                    Spacer()
                                    
                                    VStack {
                                        
                                        Text("Fuel")
                                            .font(.subheadline)
                                            .foregroundStyle(.gray)
                                            .fontWeight(.bold)
                                        
                                        Text(car.fuel)
                                            .font(.subheadline)
                                            .foregroundStyle(.gray)
                                        
                                    }
                                    
                                    Spacer()
                                    
                                }
                                
                            }
                            
                        }
                        
                        
                        Section(header: Text("Date")) {
                            
                            DatePicker("Date", selection: $date, displayedComponents: .date)
                            
                        }
                        
                        Section(header: Text("Data")) {
                            
                            TextField("Odo", value: $odo, format: .number)
                                .padding()
                                .keyboardType(.decimalPad)
                                .frame(width: 300)
                            
                            TextField("Total Price", value: $totalPrice, format: .currency(code: "$"))
                                .padding()
                                .keyboardType(.decimalPad)
                                .frame(width: 300)
                            
                            TextField("Oil", text: $oil)
                                .padding()
                                .frame(width: 300)
                            
                        }
                        
                        Section(header: Text("Notes")) {
                            
                            TextEditor(text: $notes)
                                .padding()
                                .frame(width: 300)
                            
                        }
                        
                    }
                    .scrollIndicators(.hidden)
                    .scrollContentBackground(.hidden)
                    .background(Colors.shared.background)
                    
                    FullWidthButton("Create") {
                        if  odo != nil &&
                                totalPrice != nil &&
                                carID != nil
                        {
                            
                            if let odoPrev = getLastOdo() {
                                
                                if odo! < odoPrev {
                                    showAlert(title: "That Odometer Isn't Right!", message: "The current odometer reading cannot be less than the previous odometer reading.")
                                } else {
                                   createService()
                                }
                                
                            } else {
                                createService()
                            }

                        } else {
                            showAlert(title: "You're Not Done!", message: "Please fill out the required fields.")
                        }
                        
                    }
                    
                    Spacer()
                    
                } else {
                    Text("No cars. Please add a car in settings first.")
                }
                
            } else {
                VStack {
                    
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(Colors.shared.accent)
                        .padding(.bottom)
                    
                    Text("Refill Log Creation Successful!")
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
        .background(Colors.shared.background)
        .onAppear() {
            carID = preferedCarID
            
            if carID == nil {
                if let firstCarID = mileageMasterData.cars?.first?.id {
                    carID = firstCarID
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .default(Text("Dismiss"))
            )
        }
        
    }
}
