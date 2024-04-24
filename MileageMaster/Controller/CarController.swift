//
//  CarsController.swift
//  MileageMaster
//
//  Created by Jesse Watson on 15/04/2024.
//

import Foundation

class CarController {
    
    private let email = "jessewatson04@gmail.com"
    private let GET_CARS =
                        """
                        query GetCars($email: String) {
                          cars(where: {accounts_some: {email: $email}}) {
                            id
                            plate
                            name
                            fuel
                            accounts {
                              id
                              name
                              email
                            }
                            entries {
                              id
                              createdAt
                              odoPrev
                              odoCurr
                              liters
                              totalPrice
                              station
                              notes
                            }
                          }
                        }
                        """
    
    private func getCars() async -> [Car] {
        let graphQLRequest = GraphQLRequest<GraphQLResponse<Cars>>(query: GET_CARS, variables: [(key: "email", value: .string(email))])
        do {
            let response = try await graphQLRequest.run()
            return response.data.cars
        } catch {
            print("Failure getting cars: \(error.localizedDescription)\n\(error)")
            return []
        }
    }
    
    func loadCars() {
        Task {
            let cars: [Car] = await getCars()
            DispatchQueue.main.async {
                MileageMasterData.shared.cars = cars
            }
        }
    }
    
}
