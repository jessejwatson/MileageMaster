//
//  GraphQLResponse.swift
//  MileageMaster
//
//  Created by Jesse Watson on 23/04/2024.
//

import Foundation

struct GraphQLResponse<T: Codable>: Codable {
    let data: T
}
