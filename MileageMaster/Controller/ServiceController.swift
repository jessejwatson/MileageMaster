//
//  ServiceController.swift
//  MileageMaster
//
//  Created by Jesse Watson on 18/04/2024.
//

import Foundation

class ServiceController {
    
    private let email = "jessewatson04@gmail.com"
    private let GET_SERVICES =
                            """
                            query GetServices($email: String) {
                              services(where: {car: {accounts_some: {email: $email}}}) {
                                id
                                createdAt
                                date
                                totalPrice
                                oil
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
    
    private func getServices() async -> [Service] {
        let graphQLRequest = GraphQLRequest<GraphQLResponse<Services>>(query: GET_SERVICES, variables: [(key: "email", value: .string(email))])
        do {
            let response = try await graphQLRequest.run()
            return response.data.services
        } catch {
            print("Failure getting services: \(error.localizedDescription)\n\(error)")
            return []
        }
    }
    
    func loadServices() {
        Task {
            let services: [Service] = await getServices()
            DispatchQueue.main.async {
                MileageMasterData.shared.services = services
            }
        }
    }

    
}
