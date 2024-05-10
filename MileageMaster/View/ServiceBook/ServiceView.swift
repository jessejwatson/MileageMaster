//
//  ServiceView.swift
//  MileageMaster
//
//  Created by Jesse Watson on 02/04/2024.
//

import SwiftUI

struct ServiceView: View {
    
    let service: Service
    @State private var navigationTitle: String
    
    @discardableResult
    init(_ service: Service) {
        self.service = service
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let date = inputFormatter.date(from: service.date) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "EEEE dd/MM/yyyy"
            
            self.navigationTitle = outputFormatter.string(from: date)
        } else {
            print("Error parsing date string")
            self.navigationTitle = "Log"
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    private let serviceController = ServiceController()
    
    private struct EditMode {
        var odo = false
        var totalPrice = false
        var oil = false
        var notes = false
    }
    
    @State private var editMode = EditMode()
    
    @State private var date: Date = Date()
    @State private var odo: Int = 0
    @State private var totalPrice: Double = 0.0
    @State private var oil: String = ""
    @State private var notes: String = ""
    
    // Alert
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    
    // Show
    @State private var showDeleteConfirmation = false
    
    // Focus
    private enum Field: Int, Hashable {
        case odo, totalPrice, oil, notes
    }
    @FocusState private var focusedField: Field?
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
    
    var body: some View {
        
        ScrollView {
            
            // --- Date
            
            HStack {
                
                Icon(systemName: "calendar.circle.fill", iconColor: Color.red)
                
                Spacer()
                
                // --- Dual (View & Edit) Mode
                
                                        
                DatePicker("", selection: $date, displayedComponents: .date)
                    .onChange(of: date) { value, inital in
                        Task {
                            let updatedService = await serviceController.updateService(id: service.id, key: "date", value: .date(date))
                            if updatedService != nil {
                                serviceController.loadServices()
                            } else {
                                showAlert(title: "Something went wrong!", message: "There was an error editing your service. Please try again.")
                            }
                        }
                    }
                
            }
            .padding()
            .background(Colors.shared.backgroundSecondary)
            .cornerRadius(12)
            .padding([.leading, .trailing])
            .onAppear() {
                let inputFormatter = DateFormatter()
                inputFormatter.dateFormat = "yyyy-MM-dd"
                inputFormatter.locale = Locale(identifier: "en_US_POSIX")
                inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                if let parsedDate = inputFormatter.date(from: service.date) {
                    date = parsedDate
                }
            }
            
            // --- Odo
            
            HStack {
                
                Icon(systemName: "gauge.with.dots.needle.bottom.50percent", iconColor: Color.accentColor)
                
                Spacer()
                
                if editMode.odo == false {
                    
                    // --- View Mode
            
                    VStack {
                        
                        Text("Odometer")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(String(service.odo))
                            .font(.title2)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    
                } else {
                    
                    // --- Edit Mode
                    
                    TextField("Odometer", value: $odo, format: .number)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .odo)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onAppear() {
                            odo = service.odo
                        }
                    
                    Spacer()
                    
                    Button {
                        editMode.odo = false
                    } label: {
                        Text("Cancel")
                            .padding(4)
                            .cornerRadius(8)
                    }
                    
                    Button {
                        Task {
                            let updateService = await serviceController.updateService(id: service.id, key: "odo", value: .int(odo))
                            if updateService != nil {
                                serviceController.loadServices()
                                editMode.odo = false
                            } else {
                                showAlert(title: "Something went wrong!", message: "There was an error editing your service. Please try again.")
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
            .background(Colors.shared.backgroundSecondary)
            .cornerRadius(12)
            .padding([.leading, .trailing])
            .onTapGesture {
                editMode.odo = true
                focusedField = .odo
            }
                        
            // --- Total Price
            
            HStack {
                
                Icon(systemName: "dollarsign.circle.fill", iconColor: Color.green)
                
                Spacer()
                
                if editMode.totalPrice == false {
                    
                    // --- View Mode
                    
                    VStack {
                        
                        Text("Total Price")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(String(service.totalPrice ?? 0.0))
                            .font(.title2)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    
                } else {
                    
                    // --- Edit Mode
                    
                    TextField("Total Price", value: $totalPrice, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .totalPrice)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onAppear() {
                            totalPrice = service.totalPrice ?? 0.0
                        }
                    
                    Spacer()
                    
                    Button {
                        editMode.totalPrice = false
                    } label: {
                        Text("Cancel")
                            .padding(4)
                            .cornerRadius(8)
                    }
                    
                    Button {
                        Task {
                            let updatedService = await serviceController.updateService(id: service.id, key: "totalPrice", value: .double(totalPrice))
                            if updatedService != nil {
                                serviceController.loadServices()
                                editMode.totalPrice = false
                            } else {
                                showAlert(title: "Something went wrong!", message: "There was an error editing your service. Please try again.")
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
            .background(Colors.shared.backgroundSecondary)
            .cornerRadius(12)
            .padding([.leading, .trailing])
            .onTapGesture {
                editMode.totalPrice = true
                focusedField = .totalPrice
            }
            
            // --- Oil
            
            HStack {
                
                Icon(systemName: "drop.fill", iconColor: Color.orange)
                
                Spacer()
                
                if editMode.oil == false {
                    
                    // --- View Mode
                    
                    VStack {
                        
                        Text("Oil")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(service.oil ?? "")
                            .font(.title2)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    
                } else {
                    
                    // --- Edit Mode
                    
                    TextField("Oil", text: $oil)
                        .focused($focusedField, equals: .oil)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onAppear() {
                            oil = service.oil ?? ""
                        }
                    
                    Spacer()
                    
                    Button {
                        editMode.oil = false
                    } label: {
                        Text("Cancel")
                            .padding(4)
                            .cornerRadius(8)
                    }
                    
                    Button {
                        Task {
                            let updatedService = await serviceController.updateService(id: service.id, key: "oil", value: .string(oil))
                            if updatedService != nil {
                                serviceController.loadServices()
                                editMode.oil = false
                            } else {
                                showAlert(title: "Something went wrong!", message: "There was an error editing your service. Please try again.")
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
            .background(Colors.shared.backgroundSecondary)
            .cornerRadius(12)
            .padding([.leading, .trailing])
            .onTapGesture {
                editMode.oil = true
                focusedField = .oil
            }
            
            // --- Notes
            
            HStack {
                
                Icon(systemName: "list.clipboard.fill", iconColor: Color.orange)
                
                Spacer()
                
                if editMode.notes == false {
                    
                    // --- View Mode
                    
                    VStack {
                        
                        Text("Notes")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(service.notes ?? "No notes...")
                            .font(.title2)
                            //.truncationMode(.tail)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    
                } else {
                    
                    // --- Edit Mode
                    
                    TextEditor(text: $notes)
                        .frame(maxWidth: .infinity, minHeight: 250, alignment: .leading)
                        .background(Colors.shared.backgroundSecondary)
                        .focused($focusedField, equals: .notes)
                        .onAppear() {
                            notes = service.notes ?? ""
                        }
                    
                    Spacer()
                    
                    Button {
                        editMode.notes = false
                    } label: {
                        Text("Cancel")
                            .padding(4)
                            .cornerRadius(8)
                    }
                    
                    Button {
                        Task {
                            let updatedService = await serviceController.updateService(id: service.id, key: "notes", value: .optionalString(notes.trimmingCharacters(in: .whitespacesAndNewlines)))
                            if updatedService != nil {
                                serviceController.loadServices()
                                editMode.notes = false
                            } else {
                                showAlert(title: "Something went wrong!", message: "There was an error editing your service. Please try again.")
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
            .frame(minHeight: 100, maxHeight: 300, alignment: .top)
            .background(Colors.shared.backgroundSecondary)
            .cornerRadius(12)
            .padding([.leading, .trailing])
            .onTapGesture {
                editMode.notes = true
                focusedField = .notes
            }
            
            Spacer()
            
        }
        .background(Colors.shared.background)
        .navigationTitle(navigationTitle)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                
                // --- Delete Button
                
                Button {
                    showDeleteConfirmation = true
                } label: {
                    Image(systemName: "trash")
                        .foregroundStyle(.red)
                }
                
            }
        }
        .alert(isPresented: $showAlert) {
            
            // --- Alert Popup
            
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .default(Text("Dismiss"))
            )
        }
        .confirmationDialog(
            "Are you sure you want to delete this log?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            
            // --- Confirmation Dialog
            
            Button(role: .destructive) {
                Task {
                    let deletedService: SmallService? = await serviceController.deleteService(id: service.id)
                    if deletedService == nil {
                        showAlert(title: "Unknown Error", message: "There was an error deleting the service. Please try again.")
                    } else {
                        serviceController.loadServices()
                    }
                }
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Delete")
                    .foregroundStyle(.red)
            }
            
            Button("Cancel", role: .cancel) {}
            
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
