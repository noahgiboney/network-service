//
//  FetchTests.swift
//
//
//  Created by Noah Giboney on 9/6/24.
//

import XCTest
@testable import NetworkService

final class FetchTests: XCTestCase {
    
    func testSuccessfulFetch() async {
        
        let expectedUser = User(id: 1, name: "Test User", email: "test@gmail.com")
        
        let mockSession = MockSession()
        mockSession.data = try! JSONEncoder().encode(expectedUser)
        
        do {
            let user: User = try await mockSession.fetch(path: "some/api")
            XCTAssertEqual(user, expectedUser)
        } catch {
            XCTFail()
        }
    }
    
    func testFetchThrowsDecodingError() async {
        
        let mockSession = MockSession()
        mockSession.data = Data()
        
        do {
            let _: User = try await mockSession.fetch(path: "some/api")
            XCTFail("mockSession should have thrown an error")
        } catch let error as NetworkError {
            XCTAssertEqual(error, NetworkError.decodingError)
        } catch {
            XCTFail("A different error was thrown")
        }
    }
    
    func testFetchThrowsServerError() async {
        
        let mockSession = MockSession()
        
        do {
            let _: User = try await mockSession.fetch(path: "some/api")
            XCTFail("mockSession should have thrown an error")
        } catch let error as NetworkError {
            XCTAssertEqual(error, NetworkError.serverResponse)
        } catch {
            XCTFail("A different error was thrown")
        }
    }
}
