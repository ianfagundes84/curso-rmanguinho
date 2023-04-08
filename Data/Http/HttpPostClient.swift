//
//  HttpPostClient.swift
//  Data
//
//  Created by Ian Fagundes on 07/04/23.
//

import Foundation

public protocol HttpPostClient {
    func post(to url: URL, with data: Data?, completion: @escaping (HttpError) -> Void)
}
