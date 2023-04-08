//
//  RemoteAddAccount.swift
//  Data
//
//  Created by Ian Fagundes on 07/04/23.
//

import Foundation
import Domain

public class RemoteAddAccount {
    private let url: URL
    private let httpClient: HttpPostClient
   public init(url: URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    public func add(addAccountModel: AddAccountModel, completion: @escaping (DomainError) -> Void) {
        httpClient.post(to: url, with: addAccountModel.toData()) { error in
            completion(.unexpected)
        }
    }
}

