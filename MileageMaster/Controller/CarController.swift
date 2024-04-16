//
//  CarsController.swift
//  MileageMaster
//
//  Created by Jesse Watson on 15/04/2024.
//

import Foundation

class CarController {
    
    private let email = "jessewatson04@gmail.com"
    
    enum CarError: Error {
        case graphQLError
    }
    
    private func getCars() async throws -> [Car] {
        do {
            let operation = GraphQLOperation("{ cars (where: { accounts_some: { email: \"\(email)\" } }) { id plate name fuel accounts { id name email } entries { id createdAt odoPrev odoCurr liters totalPrice station notes } } }")
            let cars: [Car] = try await GraphQLAPI().performOperation(operation)
            
            return cars
        } catch {
            print("Error in CarController > getCars: \(error)")
            throw CarError.graphQLError
        }
    }
    
    func loadCars() {
        Task {
            do {
                let cars: [Car] = try await getCars()
                DispatchQueue.main.async {
                    MileageMasterData.shared.cars = cars
                }
            } catch {
                print("Error loading cars: \(error)")
            }
        }
    }
    
}
