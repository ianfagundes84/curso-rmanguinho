//
//  TestFactories.swift
//  DataTests
//
//  Created by Ian Fagundes on 09/04/23.
//

import Foundation

func makeInvalidData() -> Data {
    return Data("invalid_data".utf8)
}

func makeUrl() -> URL {
    return URL(string: "http://any-url.com")!
}
