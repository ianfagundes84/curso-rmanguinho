//
//  Model.swift
//  Domain
//
//  Created by Ian Fagundes on 07/04/23.
//

import Foundation

public protocol Model: Codable, Equatable {}

public extension Model {
    func toData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
