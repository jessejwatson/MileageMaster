//
//  EntryController.swift
//  MileageMaster
//
//  Created by Jesse Watson on 15/04/2024.
//

import Foundation

class EntryController {
    
    private let email = "jessewatson04@gmail.com"
    
    enum EntryError: Error {
        case graphQLError
    }
    
    private func getEntries() async throws -> [Entry] {
        do {
            let operation = GraphQLOperation("{ entries (where: { car: { accounts_some: { email: \"\(email)\" } } }) { id createdAt odoCurr odoPrev liters totalPrice station notes car { id plate name fuel } } }")
            let entries: [Entry] = try await GraphQLAPI().performOperation(operation)
            
            return entries
        } catch {
            print("Error in EntryController > getEntries: \(error)")
            throw EntryError.graphQLError
        }
    }
    
    func loadEntries() {
        Task {
            do {
                let entries: [Entry] = try await getEntries()
                DispatchQueue.main.async {
                    MileageMasterData.shared.entries = entries
                }
            } catch {
                print("Error loading entries: \(error)")
            }
        }
    }

    
}
