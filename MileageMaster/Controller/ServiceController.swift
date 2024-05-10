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
                                odo
                                totalPrice
                                oil
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
    
    private let DELETE_SERVICE =
                            """
                            mutation DeleteService($id: ID) {
                              deleteService(where: {id: $id}) {
                                id
                                createdAt
                                date
                                odo
                                totalPrice
                                oil
                                notes
                              }
                            }
                            """
    
    private let DELETE_MANY_SERVICES =
                            """
                            mutation DeleteManyServices($id: ID) {
                              deleteManyServicesConnection(where: {car: {id: $id}}) {
                                edges {
                                  node {
                                    id
                                    createdAt
                                    date
                                    odo
                                    totalPrice
                                    oil
                                    notes
                                  }
                                }
                              }
                            }
                            """
    
    private let CREATE_SERVICE =
                            """
                            mutation CreateService($date: Date!, $odo: Int!, $totalPrice: Float, $oil: String, $notes: String, $carID: ID) {
                              createService(
                                data: {date: $date, odo: $odo, totalPrice: $totalPrice, oil: $oil, notes: $notes, car: {connect: {id: $carID}}}
                              ) {
                                id
                                createdAt
                                date
                                odo
                                totalPrice
                                oil
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
                            
                              publishManyServicesConnection(
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
    func deleteManyServices(id: String) async -> [Node<SmallService>] {
        let graphQLRequest = GraphQLRequest<GraphQLResponse<DeleteManyServicesConnection>>(query: DELETE_MANY_SERVICES, variables: [(key: "id", value: .string(id))])
        do {
            let response = try await graphQLRequest.run()
            return response.data.deleteManyServicesConnection.edges
        } catch {
            print("Failure deleting services: \(error.localizedDescription)\n\(error)")
            return []
        }
    }
    
    func createService(date: Date, odo: Int, totalPrice: Double, oil: String, notes: String, carID: String) async -> Service? {
        let graphQLRequest = GraphQLRequest<GraphQLResponse<CreateService>>(query: CREATE_SERVICE, variables: [
            (key: "date", value: .date(date)),
            (key: "odo", value: .int(odo)),
            (key: "totalPrice", value: .double(totalPrice)),
            (key: "oil", value: .string(oil)),
            (key: "notes", value: .string(notes)),
            (key: "carID", value: .string(carID))
        ])
        do {
            let response = try await graphQLRequest.run()
            return response.data.createService
        } catch {
            print("Failure creating serice: \(error.localizedDescription)\n\(error)")
            return nil
        }
    }
    
    enum UpdateServiceValue {
        case string(String)
        case optionalString(String?)
        case bool(Bool)
        case int(Int)
        case double(Double)
        case date(Date)
    }
    
    func updateService(id: String, key: String, value: UpdateServiceValue) async -> Service? {
        
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
        case .date(let dateValue):
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = outputFormatter.string(from: dateValue)
            formattedValue = "\"\(dateString)\""
        }
        
        let UPDATE_SERVICE =
                        """
                        mutation UpdateService($id: ID) {
                          updateService(where: {id: $id}, data: {\(key): \(formattedValue)}) {
                            id
                            createdAt
                            date
                            odo
                            totalPrice
                            oil
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
                        
                          publishManyServicesConnection(
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
        
        let graphQLRequest = GraphQLRequest<GraphQLResponse<UpdateService>>(query: UPDATE_SERVICE, variables: [
            (key: "id", value: .string(id))
        ])
        do {
            let response = try await graphQLRequest.run()
            return response.data.updateService
        } catch {
            print("Failure updating service: \(error.localizedDescription)\n\(error)")
            return nil
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
