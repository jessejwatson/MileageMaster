//
//  GetCars.swift
//  MileageMaster
//
//  Created by Jesse Watson on 12/03/2024.
//

import Foundation

class APIService
{
    let api: GraphQLAPI = GraphQLAPI()
    
    func listCars() async -> [Car]
    {
        return (
            try? await self.api.performOperation(GraphQLOperation.LIST_CARS)
        ) ?? []
    }
}

extension GraphQLOperation
{
    static var LIST_CARS: Self
    {
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
