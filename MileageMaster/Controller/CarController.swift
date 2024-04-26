//
//  CarsController.swift
//  MileageMaster
//
//  Created by Jesse Watson on 15/04/2024.
//

import Foundation

class CarController {
    
    private let email = MileageMasterData.shared.account?.email ?? ""
    private let GET_CARS =
                        """
                        query GetCars($email: String) {
                          cars(first: 10000, where: {accounts_some: {email: $email}}) {
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
    
    private let CREATE_CAR =
                        """
                        mutation CreateCar($email: String!, $name: String!, $plate: String!, $fuel: String!) {
                          createCar(
                            data: {name: $name, plate: $plate, fuel: $fuel, accounts: {connect: {email: $email}}}
                          ) {
                            id
                            name
                            plate
                            fuel
                            accounts {
                              id
                              email
                              name
                            }
                          }
                        
                          publishManyCarsConnection(
                            to: PUBLISHED
                            last: 100
                            where: {accounts_some: {email: $email}}
                          ) {
                            edges {
                              node {
                                id
                              }
                            }
                          }
                        }
                        """
    
    private let DELETE_CAR =
                        """
                        mutation DeleteCar($id: ID) {
                          deleteCar(where: {id: $id}) {
                            id
                            plate
                            name
                            fuel
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
    
    func createCar(name: String, plate: String, fuel: String) async -> Car? {
        let graphQLRequest = GraphQLRequest<GraphQLResponse<CreateCar>>(query: CREATE_CAR, variables: [
            (key: "email", value: .string(email)),
            (key: "name", value: .string(name)),
            (key: "plate", value: .string(plate)),
            (key: "fuel", value: .string(fuel))
        ])
        do {
            let response = try await graphQLRequest.run()
            return response.data.createCar
        } catch {
            print("Failure creating car: \(error.localizedDescription)\n\(error)")
            return nil
        }
    }
    
    func deleteCar(id: String) async -> SmallCar? {
        let graphQLRequest = GraphQLRequest<GraphQLResponse<DeleteCar>>(query: DELETE_CAR, variables: [(key: "id", value: .string(id))])
        do {
            let response = try await graphQLRequest.run()
            return response.data.deleteCar
        } catch {
            print("Failure deleting car: \(error.localizedDescription)\n\(error)")
            return nil
        }
    }
    
    enum UpdateCarValue {
        case string(String)
        case optionalString(String?)
        case bool(Bool)
        case int(Int)
        case double(Double)
    }
    
    func updateCar(id: String, key: String, value: UpdateCarValue) async -> SmallCar? {
        
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
        
        let UPDATE_CAR =
                        """
                        mutation UpdateCar($id: ID) {
                          updateCar(where: {id: $id}, data: {
                            \(key): \(formattedValue)
                          }) {
                            id
                            plate
                            name
                            fuel
                          }
                        
                          publishManyCarsConnection(
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
        
        let graphQLRequest = GraphQLRequest<GraphQLResponse<UpdateCar>>(query: UPDATE_CAR, variables: [
            (key: "id", value: .string(id))
        ])
        do {
            let response = try await graphQLRequest.run()
            return response.data.updateCar
        } catch {
            print("Failure updating car: \(error.localizedDescription)\n\(error)")
            return nil
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
