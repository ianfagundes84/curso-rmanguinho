//
//  DataTests.swift
//  DataTests
//
//  Created by Ian Fagundes on 04/04/23.
//

import XCTest
import Domain
import Data

final class RemoteAddAccountTests: XCTestCase {
    func test_add_should_call_httpClient_with_correct_url() throws {
        let url = URL(string: "http://any-url.com")!
        let (sut, httpClientSpy) = makeSut(url: url)
        sut.add(addAccountModel: makeAddAccountModel()) { _ in }
        XCTAssertEqual(httpClientSpy.url, [url])
    }
    
    func test_add_should_call_httpClient_with_correct_data() throws {
        let (sut, httpClientSpy) = makeSut()
        let addAccountModel = makeAddAccountModel()
        sut.add(addAccountModel: addAccountModel) { _ in }
        XCTAssertEqual(httpClientSpy.data, addAccountModel.toData())
    }
    
    func test_add_should_complete_with_error_if_client_completes_with_error() throws {
        let (sut, httpClientSpy) = makeSut()
        expect(sut, completeWith: .failure(.unexpected), when: {
            httpClientSpy.completeWithError(.noConnectivity)
        })
    }
    
    func test_add_should_complete_with_account_if_client_completes_with_valid_data() throws {
        let (sut, httpClientSpy) = makeSut()
        let account = makeAccountModel()
        expect(sut, completeWith: .success(account), when: {
            httpClientSpy.completeWithData(account.toData()!)
        })
    }
    
    func test_add_should_complete_with_error_if_client_completes_with_invalid_data() throws {
        let (sut, httpClientSpy) = makeSut()
        expect(sut, completeWith: .failure(.unexpected), when: {
            httpClientSpy.completeWithData(Data("invalid_data".utf8))
        })
    }
}

extension RemoteAddAccountTests {
    func makeSut(url: URL = URL(string: "http://any-url.com")!) -> (sut: RemoteAddAccount, httpClientSpy: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        return (sut, httpClientSpy)
    }
    
    func expect(_ sut: RemoteAddAccount, completeWith expectedResult: Result<AccountModel, DomainError>, when action: () -> Void) {
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: makeAddAccountModel()) { receivedResult in
            switch (expectedResult, receivedResult) {
            case (.failure(let expectedError), .failure(let receivedError)): XCTAssertEqual(expectedError, receivedError)
            case (.success(let expectedError), .success(let receivedAccount)): XCTAssertEqual(expectedError, receivedAccount)
            default: XCTFail("Expected \(expectedResult) receive \(receivedResult) instead")
            }
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1)
    }
    
    func makeAddAccountModel() -> AddAccountModel {
        return AddAccountModel(name: "any_name", email: "any_email@mail.com", password: "any_password", passwordConfirmation: "any_password")
    }
    
    func makeAccountModel() -> AccountModel {
        return AccountModel(id: "any_id", name: "any_name", email: "any_email@mail.com", password: "any_password")
    }
    
    class HttpClientSpy: HttpPostClient {
        var url = [URL]()
        var data: Data?
        var completion: ((Result<Data, HttpError>) -> Void)?
        
        func post(to url: URL, with data: Data?, completion: @escaping (Result<Data, HttpError>) -> Void) {
            self.url.append(url)
            self.data = data
            self.completion = completion
        }
        
        func completeWithError(_ error: HttpError) {
            completion?(.failure(error))
        }
        
        func completeWithData(_ data: Data) {
            completion?(.success(data))
        }
    }
}
