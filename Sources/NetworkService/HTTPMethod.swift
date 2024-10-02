//
//  HTTPMethod.swift
//
//
//  Created by Noah Giboney on 9/1/24.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
    case patch = "PATCH"

    var responseCodes: [Int] {
        switch self {
        case .get:
            // 200 (OK)
            return [200]
        case .post:
            // 201 (Created) or 200 (OK)
            return [200, 201]
        case .delete:
            // 200 (OK), 202 (Accepted), or 204 (No Content)
            return [200, 202, 204]
        case .put:
            // 200 (OK) and 204 (No Content)
            return [200, 204]
        case .patch:
            // 200 (OK) or 204 (No Content)
            return [200, 204]
        }
    }
}
