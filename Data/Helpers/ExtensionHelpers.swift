//
//  ExtensionHelpers.swift
//  Data
//
//  Created by Ian Fagundes on 08/04/23.
//

import Foundation

public extension Data {
    func toModel<T: Decodable>() -> T? {
        return try? JSONDecoder().decode(T.self, from: self)
    }
}
