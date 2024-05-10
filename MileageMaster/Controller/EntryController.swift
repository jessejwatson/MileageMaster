//
//  EntryController.swift
//  MileageMaster
//
//  Created by Jesse Watson on 15/04/2024.
//

import Foundation

class EntryController {
    
    private let email = MileageMasterData.shared.account?.email ?? ""
    private let GET_ENTRIES =
                        """
                        query GetEntries($email: String) {
                          entries(first: 10000, where: {car: {accounts_some: {email: $email}}}) {
                            id
                            createdAt
                            odoCurr
                            odoPrev
                            liters
                            totalPrice
                            station
                            notes
                            car {
                              id
                              name
                              plate
                              fuel
                              year
                              serviceIntervalKM
                              serviceIntervalMonth
                            }
                          }
                        }
                        """
    
    private let CREATE_ENTRY =
                        """
                        mutation CreateEntry($odoCurr: Int!, $odoPrev: Int!, $liters: Float!, $totalPrice: Float!, $station: String, $notes: String, $carID: ID) {
                          createEntry(
                            data: {odoCurr: $odoCurr, odoPrev: $odoPrev, liters: $liters, totalPrice: $totalPrice, station: $station, notes: $notes, car: {connect: {id: $carID}}}
                          ) {
                            id
                            createdAt
                            odoCurr
                            odoPrev
                            liters
                            totalPrice
                            station
                            notes
                            car {
                              id
                              name
                              plate
                              fuel
                              year
                              serviceIntervalKM
                              serviceIntervalMonth
                            }
                          }
                        
                          publishManyEntriesConnection(
                            to: PUBLISHED
                            last: 100
                            where: {car: {id: $carID}}
                          ) {
                            edges {
                              node {
                                id
                              }
                            }
                          }
                        }
                        """
    
    private let DELETE_ENTRY =
                        """
                        mutation DeleteEntry($id: ID) {
                          deleteEntry(where: {id: $id}) {
                            id
                            createdAt
                            odoCurr
                            odoPrev
                            liters
                            totalPrice
                            station
                            notes
                            car {
                              id
                              name
                              plate
                              fuel
                              year
                              serviceIntervalKM
                              serviceIntervalMonth
                            }
                          }
                        }
                        """
    
    private let DELETE_MANY_ENTRIES =
                        """
                        mutation DeleteManyEntries($id: ID) {
                          deleteManyEntriesConnection(where: {car: {id: $id}}) {
                            edges {
                              node {
                                id
                                createdAt
                                odoCurr
                                liters
                                totalPrice
                                station
                                notes
                              }
                            }
                          }
                        }
                        """
    
    private func getEntries() async -> [Entry] {
        let graphQLRequest = GraphQLRequest<GraphQLResponse<Entries>>(query: GET_ENTRIES, variables: [(key: "email", value: .string(email))])
        do {
            let response = try await graphQLRequest.run()
            return response.data.entries
        } catch {
            print("Failure getting entries: \(error.localizedDescription)\n\(error)")
            return []
        }
    }
    
    func createEntry(odoCurr: Int, odoPrev: Int, liters: Double, totalPrice: Double, station: String, notes: String?, carID: String) async -> Entry? {
        let graphQLRequest = GraphQLRequest<GraphQLResponse<CreateEntry>>(query: CREATE_ENTRY, variables: [
            (key: "odoCurr", value: .int(odoCurr)),
            (key: "odoPrev", value: .int(odoPrev)),
            (key: "liters", value: .double(liters)),
            (key: "totalPrice", value: .double(totalPrice)),
            (key: "station", value: .string(station)),
            (key: "notes", value: .optionalString(notes)),
            (key: "carID", value: .string(carID)),
        ])
        do {
            let response = try await graphQLRequest.run()
            return response.data.createEntry
        } catch {
            print("Failure creating entry: \(error.localizedDescription)\n\(error)")
            return nil
        }
    }
    
    func deleteEntry(id: String) async -> Entry? {
        let graphQLRequest = GraphQLRequest<GraphQLResponse<DeleteEntry>>(query: DELETE_ENTRY, variables: [
            (key: "id", value: .string(id))
        ])
        do {
            let response = try await graphQLRequest.run()
            return response.data.deleteEntry
        } catch {
            print("Failure deleting entry: \(error.localizedDescription)\n\(error)")
            return nil
        }
    }
    
    @discardableResult
    func deleteManyEntries(id: String) async -> [Node<SmallEntry>] {
        let graphQLRequest = GraphQLRequest<GraphQLResponse<DeleteManyEntriesConnection>>(query: DELETE_MANY_ENTRIES, variables: [(key: "id", value: .string(id))])
        do {
            let response = try await graphQLRequest.run()
            return response.data.deleteManyEntriesConnection.edges
        } catch {
            print("Failure deleting entries: \(error.localizedDescription)\n\(error)")
            return []
        }
    }
    
    enum UpdateEntryValue {
        case string(String)
        case optionalString(String?)
        case bool(Bool)
        case int(Int)
        case double(Double)
    }
    
    func updateEntry(id: String, key: String, value: UpdateEntryValue) async -> Entry? {
        
        var formattedValue = ""
        
        switch value {
        case .string(let stringValue):
            formattedValue = "\"\(stringValue)\""
        case .optionalString(let stringOptionalValue):
            if stringOptionalValue != nil {
                formattedValue = "\"\(stringOptionalValue!)\""
            } else {
                formattedValue = "null"
            }
        case .bool(let boolValue):
            formattedValue = "\(boolValue)"
        case .int(let intValue):
            formattedValue = "\(intValue)"
        case .double(let doubleValue):
            formattedValue = "\(doubleValue)"
        }
        
        let UPDATE_ENTRY =
                        """
                        mutation UpdateEntry($id: ID) {
                          updateEntry(where: {id: $id}, data: {\(key): \(formattedValue)}) {
                            id
                            createdAt
                            odoCurr
                            odoPrev
                            liters
                            totalPrice
                            station
                            notes
                            car {
                              id
                              name
                              plate
                              fuel
                              year
                              serviceIntervalKM
                              serviceIntervalMonth
                            }
                          }
                        
                          publishManyEntriesConnection(
                            to: PUBLISHED
                            last: 100
                            where: {id: $id}
                          ) {
                            edges {
                              node {
                                id
                              }
                            }
                          }
                        }
                        """
        
        let graphQLRequest = GraphQLRequest<GraphQLResponse<UpdateEntry>>(query: UPDATE_ENTRY, variables: [
            (key: "id", value: .string(id))
        ])
        do {
            let response = try await graphQLRequest.run()
            return response.data.updateEntry
        } catch {
            print("Failure updating entry: \(error.localizedDescription)\n\(error)")
            return nil
        }
        
    }
    
    func loadEntries() {
        Task {
            let entries: [Entry] = await getEntries()
            DispatchQueue.main.async {
                MileageMasterData.shared.entries = entries
            }
        }
    }

    
}
