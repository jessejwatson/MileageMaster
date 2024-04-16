//
//  GetCars.swift
//  MileageMaster
//
//  Created by Jesse Watson on 12/03/2024.
//

import Foundation

class APIService {
    let api: GraphQLAPI = GraphQLAPI()
    
    func listCars() async -> [Car] {
        return (
            try? await self.api.performOperation(GraphQLOperation.LIST_CARS)
        ) ?? []
    }
}

extension GraphQLOperation {
    static var LIST_CARS: Self {
        GraphQLOperation(
            """
                {
                    cars
                    {
                        id
                        plate
                        name
                        fuel
                        accounts
                        entries
                    }
                }
            """
        )
    }
}

/*func loadCars()
{
    Task {
        do {
            print("Fetching cars...")
            let operation = GraphQLOperation("{ cars { id plate name fuel accounts { id name email } entries { id createdAt odoPrev odoCurr liters totalPrice station notes } } }")
            let cars: [Car] = try await GraphQLAPI().performOperation(operation)
            print("Finished fetching cars...")
            mileageMasterData.cars = cars
        } catch {
            print(error)
        }
    }
}*/

