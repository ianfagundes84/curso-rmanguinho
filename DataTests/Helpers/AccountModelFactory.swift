//
//  AccountModelFactory.swift
//  DataTests
//
//  Created by Ian Fagundes on 09/04/23.
//

import Foundation
import Domain

func makeAccountModel() -> AccountModel {
    return AccountModel(id: "any_id", name: "any_name", email: "any_email@mail.com", password: "any_password")
}
