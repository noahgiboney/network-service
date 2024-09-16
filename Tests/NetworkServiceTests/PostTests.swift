//
//  PostTests.swift
//  
//
//  Created by Noah Giboney on 9/15/24.
//

import NetworkService
import XCTest

final class PostTests: XCTestCase {

    func testSuccesfulPost() async {
        
        let mockSession = MockSession()
        let expectedUser = User(id: 2, name: "test", email: "test@gmail.com")
        
        mockSession.data = try! JSONEncoder().encode(expectedUser)
        
        do {
            let user: User = try await mockSession.post(path: "some/api", object: expectedUser)
            XCTAssertEqual(expectedUser, user)
        } catch {
            XCTFail()
        }
    }
}
