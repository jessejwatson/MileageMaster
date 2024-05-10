//
//  Edges.swift
//  MileageMaster
//
//  Created by Jesse Watson on 26/04/2024.
//

import Foundation

struct Edges<T: Codable>: Codable {
    let edges: [Node<T>]
}

struct Node<T: Codable>: Codable {
    let node: T
}
