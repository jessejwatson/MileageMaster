//
//  ServiceController.swift
//  MileageMaster
//
//  Created by Jesse Watson on 18/04/2024.
//

import Foundation

class ServiceController {
    
    private let email = MileageMasterData.shared.account?.email ?? ""
    private let GET_SERVICES =
                            """
                            query GetServices($email: String) {
                              services(first: 10000, where: {car: {accounts_some: {email: $email}}}) {
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
    
    private let DELETE_SERVICE =
                            """
                            mutation DeleteService($id: ID) {
                              deleteService(where: {id: $id}) {
                                id
                                createdAt
                                date
                                totalPrice
                                oil
                                notes
                              }
                            }
                            """
    
    private let DELETE_MANY_SERVICES =
                            """
                            mutation DeleteManyServices($id: ID) {
                              deleteManyServicesConnection(where: {car: $id}) {
                                edges {
                                  node {
                                    id
                                  }
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
    
    func deleteService(id: String) async -> SmallService? {
        let graphQLRequest = GraphQLRequest<GraphQLResponse<DeleteService>>(query: DELETE_SERVICE, variables: [(key: "id", value: .string(id))])
        do {
            let response = try await graphQLRequest.run()
            return response.data.deleteService
        } catch {
            print("Failure deleting service: \(error.localizedDescription)\n\(error)")
            return nil
        }
    }
    
    @discardableResult
    func deleteManyServices(id: String) async -> [SmallService] {
        let graphQLRequest = GraphQLRequest<GraphQLResponse<DeleteManyServicesConnection>>(query: DELETE_MANY_SERVICES, variables: [(key: "id", value: .string(id))])
        do {
            let response = try await graphQLRequest.run()
            return response.data.deleteManyServicesConnection.edges
        } catch {
            print("Failure deleting services: \(error.localizedDescription)\n\(error)")
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
