//
//  CarView.swift
//  MileageMaster
//
//  Created by Jesse Watson on 14/03/2024.
//

import SwiftUI

struct CarView: View {
    
    let car: Car
    
    init(car: Car) {
        self.car = car
    }
    
    // Focus
    private enum Field: Int, Hashable {
        case name, plate, fuel
    }
    @FocusState private var focusedField: Field?
    
    // Data
    @State private var plate = ""
    @State private var name = ""
    @State private var fuel = ""
    
    // Edit Mode
    @State private var editMode = EditMode()
    private struct EditMode {
        var plate = false
        var name = false
        var fuel = false
    }
    
    // Alert
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
    
    var body: some View {
        VStack {
            
            Text(car.name)
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            // --- Name
            
            HStack {
                
                Icon(systemName: "car.fill", iconColor: Color.accentColor)
                
                Spacer()
                
                if editMode.name == false {
                    
                    // --- View Mode
                    VStack {
                        
                        Text("Name")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(car.name)
                            .font(.title2)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    
                } else {
                    
                    // --- Edit Mode
                    
                    TextField("Name", text: $name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .focused($focusedField, equals: .name)
                        .onAppear() {
                            name = car.name
                        }
                    
                    Spacer()
                    
                    Button {
                        editMode.name = false
                    } label: {
                        Text("Cancel")
                            .padding(4)
                            .background(Color.gray.opacity(0.15))
                            .cornerRadius(8)
                    }
                    
                    Button {
                        let carController = CarController()
                        Task {
                            let updateCar = await carController.updateCar(id: car.id, key: "name", value: .string(name.trimmingCharacters(in: .whitespacesAndNewlines)))
                            if updateCar != nil {
                                carController.loadCars()
                                editMode.name = false
                            } else {
                                showAlert(title: "Something went wrong!", message: "There was an error editing your car. Please try again.")
                            }
                        }
                    } label: {
                        Text("Save")
                            .padding(4)
                            .foregroundStyle(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    
                }
            }
            .padding()
            .background(Color.gray.opacity(0.15))
            .cornerRadius(12)
            .padding([.leading, .trailing])
            .onTapGesture {
                editMode.name = true
                focusedField = .name
            }
            
            // --- Plate
            
            HStack {
                
                Icon(systemName: "licenseplate.fill", iconColor: Color.orange)
                
                Spacer()
                
                if editMode.plate == false {
                    
                    // --- View Mode
                    VStack {
                        
                        Text("Plate")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(car.plate)
                            .font(.title2)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    
                } else {
                    
                    // --- Edit Mode
                    
                    TextField("Plate", text: $plate)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .focused($focusedField, equals: .plate)
                        .onAppear() {
                            plate = car.plate
                        }
                    
                    Spacer()
                    
                    Button {
                        editMode.plate = false
                    } label: {
                        Text("Cancel")
                            .padding(4)
                            .background(Color.gray.opacity(0.15))
                            .cornerRadius(8)
                    }
                    
                    Button {
                        let carController = CarController()
                        Task {
                            let updateCar = await carController.updateCar(id: car.id, key: "plate", value: .string(plate.trimmingCharacters(in: .whitespacesAndNewlines)))
                            if updateCar != nil {
                                carController.loadCars()
                                editMode.plate = false
                            } else {
                                showAlert(title: "Something went wrong!", message: "There was an error editing your car. Please try again.")
                            }
                        }
                    } label: {
                        Text("Save")
                            .padding(4)
                            .foregroundStyle(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    
                }
            }
            .padding()
            .background(Color.gray.opacity(0.15))
            .cornerRadius(12)
            .padding([.leading, .trailing])
            .onTapGesture {
                editMode.plate = true
                focusedField = .plate
            }
            
            // --- Fuel
            
            HStack {
                
                Icon(systemName: "fuelpump.circle.fill", iconColor: Color.blue)
                
                Spacer()
                
                if editMode.fuel == false {
                    
                    // --- View Mode
                    VStack {
                        
                        Text("Fuel")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(car.fuel)
                            .font(.title2)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    
                } else {
                    
                    // --- Edit Mode
                    
                    TextField("Fuel", text: $fuel)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .focused($focusedField, equals: .fuel)
                        .onAppear() {
                            fuel = car.fuel
                        }
                    
                    Spacer()
                    
                    Button {
                        editMode.fuel = false
                    } label: {
                        Text("Cancel")
                            .padding(4)
                            .background(Color.gray.opacity(0.15))
                            .cornerRadius(8)
                    }
                    
                    Button {
                        let carController = CarController()
                        Task {
                            let updateCar = await carController.updateCar(id: car.id, key: "fuel", value: .string(fuel.trimmingCharacters(in: .whitespacesAndNewlines)))
                            if updateCar != nil {
                                carController.loadCars()
                                editMode.fuel = false
                            } else {
                                showAlert(title: "Something went wrong!", message: "There was an error editing your car. Please try again.")
                            }
                        }
                    } label: {
                        Text("Save")
                            .padding(4)
                            .foregroundStyle(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    
                }
            }
            .padding()
            .background(Color.gray.opacity(0.15))
            .cornerRadius(12)
            .padding([.leading, .trailing])
            .onTapGesture {
                editMode.fuel = true
                focusedField = .fuel
            }
            
            Spacer()
            
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .default(Text("Dismiss"))
            )
        }
    }
    
    private struct Icon: View {
        
        let systemName: String
        let iconColor: Color
        
        var body: some View {
            Image(systemName: systemName)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundStyle(iconColor)
                .padding([.leading, .trailing], 4)
                .frame(alignment: .leading)
        }
        
    }
}
