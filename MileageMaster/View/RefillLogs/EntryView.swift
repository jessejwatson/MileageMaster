//
//  EntryView.swift
//  MileageMaster
//
//  Created by Jesse Watson on 15/04/2024.
//

import SwiftUI

struct EntryView: View {
    
    let entry: Entry
    var date: Date?
    var createdAt: String?
    @State private var navigationTitle: String
    
    @discardableResult
    init(_ entry: Entry) {
        self.entry = entry
        self.date = nil
        self.createdAt = nil
        
        let inputFormatter_date = DateFormatter()
        inputFormatter_date.dateFormat = "yyyy-MM-dd"
        inputFormatter_date.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter_date.timeZone = TimeZone(secondsFromGMT: 0)
        if let date = inputFormatter_date.date(from: entry.date) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "EEEE dd/MM/yyyy"
            
            self.date = date
            self.navigationTitle = outputFormatter.string(from: date)
        } else {
            print("Error parsing date string")
            self.navigationTitle = "Log"
        }
        
        let inputFormatter_createdAt = DateFormatter()
        inputFormatter_createdAt.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSX"
        inputFormatter_createdAt.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter_createdAt.timeZone = TimeZone(secondsFromGMT: 0)
        if let createdAt = inputFormatter_createdAt.date(from: entry.createdAt) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "EEEE dd/MM/yyyy"
            self.createdAt = outputFormatter.string(from: createdAt)
        } else {
            print("Error parsing createdAt string")
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    private struct EditMode {
        var odoPrev = false
        var odoCurr = false
        var totalPrice = false
        var liters = false
        var station = false
        var notes = false
    }
    
    @State private var editMode = EditMode()
    
    @State private var odoPrev: Int = 0
    @State private var odoCurr: Int = 0
    @State private var totalPrice: Double = 0.0
    @State private var liters: Double = 0.0
    @State private var station: String = ""
    @State private var notes: String = ""
    
    // Alert
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    
    // Show
    @State private var showDeleteConfirmation = false
    
    // Focus
    private enum Field: Int, Hashable {
        case odoPrev, odoCurr, liters, totalPrice, station, notes
    }
    @FocusState private var focusedField: Field?
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
    
    // Date picker
    @State private var showDatePicker: Bool = false
    @State private var selectedDate: Date = Date()
    
    var body: some View {
        
        ScrollView {
            
            // --- OdoPrev
            
            HStack {
                
                Icon(systemName: "gauge.with.dots.needle.bottom.0percent", iconColor: Color.accentColor)
                
                Spacer()
                
                if editMode.odoPrev == false {
                    
                    // --- View Mode
                    
                    VStack {
                        
                        Text("Previous Odometer")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(String(entry.odoPrev))
                            .font(.title2)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    
                } else {
                    
                    // --- Edit Mode
                    
                    TextField("Odo Prev", value: $odoPrev, format: .number)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .odoPrev)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onAppear() {
                            odoPrev = entry.odoPrev
                        }
                    
                    Spacer()
                    
                    Button {
                        editMode.odoPrev = false
                    } label: {
                        Text("Cancel")
                            .padding(4)
                            .cornerRadius(8)
                    }
                    
                    Button {
                        if odoPrev > entry.odoCurr {
                            showAlert(title: "That Odometer Isn't Right!", message: "The current odometer reading cannot be less than the previous odometer reading.")
                            
                            return
                        }
                        
                        let entryController = EntryController()
                        Task {
                            let updatedEntry = await entryController.updateEntry(id: entry.id, key: "odoPrev", value: .int(odoPrev))
                            if updatedEntry != nil {
                                entryController.loadEntries()
                                editMode.odoPrev = false
                            } else {
                                showAlert(title: "Something went wrong!", message: "There was an error editing your refill log. Please try again.")
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
                editMode.odoPrev = true
                focusedField = .odoPrev
            }
            
            // --- OdoCurr
            
            HStack {
                
                Icon(systemName: "gauge.with.dots.needle.bottom.100percent", iconColor: Color.accentColor)
                
                Spacer()
                
                if editMode.odoCurr == false {
                    
                    // --- View Mode
                    VStack {
                        
                        Text("Current Odometer")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(String(entry.odoCurr))
                            .font(.title2)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    
                } else {
                    
                    // --- Edit Mode
                    
                    TextField("Odo Curr", value: $odoCurr, format: .number)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .odoCurr)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onAppear() {
                            odoCurr = entry.odoCurr
                        }
                    
                    Spacer()
                    
                    Button {
                        editMode.odoCurr = false
                    } label: {
                        Text("Cancel")
                            .padding(4)
                            .cornerRadius(8)
                    }
                    
                    Button {
                        if entry.odoPrev > odoCurr {
                            showAlert(title: "That Odometer Isn't Right!", message: "The current odometer reading cannot be less than the previous odometer reading.")
                            
                            return
                        }
                        
                        let entryController = EntryController()
                        Task {
                            let updatedEntry = await entryController.updateEntry(id: entry.id, key: "odoCurr", value: .int(odoCurr))
                            if updatedEntry != nil {
                                entryController.loadEntries()
                                editMode.odoCurr = false
                            } else {
                                showAlert(title: "Something went wrong!", message: "There was an error editing your refill log. Please try again.")
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
                editMode.odoCurr = true
                focusedField = .odoCurr
            }
            
            Spacer()
            
            // --- Liters
            
            HStack {
                
                Icon(systemName: "drop.fill", iconColor: Color.blue)
                
                Spacer()
                
                if editMode.liters == false {
                    
                    // --- View Mode
                    VStack {
                        
                        Text("Liters")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(String(entry.liters))
                            .font(.title2)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    
                } else {
                    
                    // --- Edit Mode
                    
                    TextField("Odo Prev", value: $liters, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .liters)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onAppear() {
                            liters = entry.liters
                        }
                    
                    Spacer()
                    
                    Button {
                        editMode.liters = false
                    } label: {
                        Text("Cancel")
                            .padding(4)
                            .cornerRadius(8)
                    }
                    
                    Button {
                        let entryController = EntryController()
                        Task {
                            let updatedEntry = await entryController.updateEntry(id: entry.id, key: "liters", value: .double(liters))
                            if updatedEntry != nil {
                                entryController.loadEntries()
                                editMode.liters = false
                            } else {
                                showAlert(title: "Something went wrong!", message: "There was an error editing your refill log. Please try again.")
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
                editMode.liters = true
                focusedField = .liters
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
                        
                        Text(String(entry.totalPrice))
                            .font(.title2)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    
                } else {
                    
                    // --- Edit Mode
                    
                    TextField("Odo Prev", value: $totalPrice, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .totalPrice)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onAppear() {
                            totalPrice = entry.totalPrice
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
                        let entryController = EntryController()
                        Task {
                            let updatedEntry = await entryController.updateEntry(id: entry.id, key: "totalPrice", value: .double(totalPrice))
                            if updatedEntry != nil {
                                entryController.loadEntries()
                                editMode.totalPrice = false
                            } else {
                                showAlert(title: "Something went wrong!", message: "There was an error editing your refill log. Please try again.")
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
            
            // --- Station
            
            HStack {
                
                Icon(systemName: "mappin.circle.fill", iconColor: Color.red)
                
                Spacer()
                
                if editMode.station == false {
                    
                    // --- View Mode
                    VStack {
                        
                        Text("Station")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(String(entry.station))
                            .font(.title2)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    
                } else {
                    
                    // --- Edit Mode
                    
                    TextField("Station", text: $station)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .focused($focusedField, equals: .station)
                        .onAppear() {
                            station = entry.station
                        }
                    
                    Spacer()
                    
                    Button {
                        editMode.station = false
                    } label: {
                        Text("Cancel")
                            .padding(4)
                            .cornerRadius(8)
                    }
                    
                    Button {
                        let entryController = EntryController()
                        Task {
                            let updatedEntry = await entryController.updateEntry(id: entry.id, key: "station", value: .string(station.trimmingCharacters(in: .whitespacesAndNewlines)))
                            if updatedEntry != nil {
                                entryController.loadEntries()
                                editMode.station = false
                            } else {
                                showAlert(title: "Something went wrong!", message: "There was an error editing your refill log. Please try again.")
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
                editMode.station = true
                focusedField = .station
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
                        
                        Text(String(entry.notes ?? "No notes..."))
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
                            notes = entry.notes ?? ""
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
                        let entryController = EntryController()
                        Task {
                            let updatedEntry = await entryController.updateEntry(id: entry.id, key: "notes", value: .optionalString(notes.trimmingCharacters(in: .whitespacesAndNewlines)))
                            if updatedEntry != nil {
                                entryController.loadEntries()
                                editMode.notes = false
                            } else {
                                showAlert(title: "Something went wrong!", message: "There was an error editing your refill log. Please try again.")
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
            
            // --- Created At Date
            if self.createdAt != nil {
                Text("Created On: \(self.createdAt!)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .background(Colors.shared.background)
        .navigationTitle(navigationTitle)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                    
                // --- Edit Date Button
                
                Button {
                    showDatePicker.toggle()
                } label: {
                    Image(systemName: "calendar")
                        .foregroundStyle(.primary)
                }
                
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
                let entryController = EntryController()
                Task {
                    let deletedEntry: Entry? = await entryController.deleteEntry(id: entry.id)
                    if deletedEntry == nil {
                        showAlert(title: "Unknown Error", message: "There was an error deleting the log. Please try again.")
                    } else {
                        let entryController = EntryController()
                        entryController.loadEntries()
                    }
                }
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Delete")
                    .foregroundStyle(.red)
            }
            
            Button("Cancel", role: .cancel) {}
            
        }
        .sheet(isPresented: $showDatePicker) {
            
            // --- Edit Date
            
            DatePickerView(selectedDate: $selectedDate, entryId: entry.id)
                .onAppear() {
                    if self.date != nil {
                        selectedDate = self.date!
                    }
                }
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
    
    private struct DatePickerView: View {
        
        @Environment(\.presentationMode) var presentationMode
        @Binding var selectedDate: Date
        var entryId: String
        
        // Loader
        @State private var isLoading = false
        
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
                
                HStack {
                    
                    Text("Edit the Date")
                        .font(.title.bold())
                        .padding([.leading])
                    
                    Spacer()
                    
                }
                
                DatePicker(
                    "Select a date:",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                
                HStack {
                    
                    Spacer()
                    
                    // --- Cancel Button
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                            .frame(maxWidth: .infinity)
                            .padding([.top, .bottom], 4)
                    }
                    .buttonStyle(.bordered)
                    
                    Spacer()
                    
                    // --- Done Button

                    Button(action: {
                        isLoading = true
                        
                        let entryController = EntryController()
                        Task {
                            let updatedEntry = await entryController.updateEntry(id: entryId, key: "date", value: .date(selectedDate))
                            if updatedEntry != nil {
                                entryController.loadEntries()
                                presentationMode.wrappedValue.dismiss()
                            } else {
                                showAlert(title: "Something went wrong!", message: "There was an error editing your refill log. Please try again.")
                            }
                            isLoading = false
                        }
                    }) {
                        ZStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .tint(.white)
                                    .frame(width: 20, height: 20)
                            } else {
                                Text("Done")
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding([.top, .bottom], 4)
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Spacer()
                    
                }
                .padding()
            }
            .alert(isPresented: $showAlert) {
                
                // --- Alert Popup
                
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("Dismiss"))
                )
            }
            
        }
        
    }
    
}

