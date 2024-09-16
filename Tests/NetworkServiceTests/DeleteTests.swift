//
//  DeleteTests.swift
//
//
//  Created by Noah Giboney on 9/15/24.
//

import NetworkService
import XCTest

final class DeleteTests: XCTestCase {
    
    func testSuccesfulDelete() async {
        
        let mockSession = MockSession()
        let expectedData = "Succesfully Deleted".data(using: .utf8)
        mockSession.data = expectedData
        
        do {
            let responseData: Data? = try await mockSession.delete(path: "some/api")
            XCTAssertEqual(expectedData, responseData)
        }  catch {
            XCTFail()
        }
    }
}
