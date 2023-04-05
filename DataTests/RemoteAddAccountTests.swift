//
//  DataTests.swift
//  DataTests
//
//  Created by Ian Fagundes on 04/04/23.
//

import XCTest

class RemoteAddAccount {
    private let url: URL
    private let httpClient: HTTPClient
    init(url: URL, httpClient: HTTPClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    func add() {
        httpClient.post(url: url)
    }
}

protocol HTTPClient {
    func post(url: URL)
}

final class RemoteAddAccountTests: XCTestCase {
    func test_() throws {
        let url = URL(string: "http://any-url.com")!
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        sut.add()
        XCTAssertEqual(httpClientSpy.url, url)
    }
    
    class HttpClientSpy: HTTPClient {
        var url: URL?
        func post(url: URL) {
            self.url = url
        }
    }
}
