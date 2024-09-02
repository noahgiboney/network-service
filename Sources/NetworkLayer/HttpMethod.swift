//
//  File.swift
//
//
//  Created by Noah Giboney on 9/1/24.
//

import Foundation

enum HTTPMethod {
    case delete
    case post
    
    var method: String {
        switch self {
        case .delete:
            "DELETE"
        case .post:
            "POST"
        }
    }
}
