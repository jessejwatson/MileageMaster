//
//  EntryController.swift
//  MileageMaster
//
//  Created by Jesse Watson on 15/04/2024.
//

import Foundation

class EntryController {
    
    private let email = "jessewatson04@gmail.com"
    private let GET_ENTRIES =
                        """
                        query GetEntries($email: String) {
                          entries(where: {car: {accounts_some: {email: $email}}}) {
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
            print("Failure getting entries: \(error.localizedDescription)\n\(error)")
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
