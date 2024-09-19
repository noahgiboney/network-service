//
//  NetworkError.swift
//  
//
//  Created by Noah Giboney on 9/1/24.
//

import Foundation

public enum NetworkError: LocalizedError, Equatable {
    case invalidURL
    case decodingError
    case encodingError
    case serverResponse
    case badRequest
    case error(any Error)
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            "The endpoint provided was invalid."
        case .decodingError:
            "There was an error decoding the data."
        case .encodingError:
            "There was an error encoding the data."
        case .serverResponse:
            "The server responded with an error."
        case .badRequest:
            "Bad Request. Please try again later"
        case .error(let error):
            error.localizedDescription
        }
    }
    
    public static func ==(lhs: NetworkError, rhs: NetworkError) -> Bool {
            switch (lhs, rhs) {
            case (.invalidURL, .invalidURL),
                 (.decodingError, .decodingError),
                 (.encodingError, .encodingError),
                 (.serverResponse, .serverResponse):
                return true
            
            case (.error(let lhsError), .error(let rhsError)):
                return (lhsError as NSError) == (rhsError as NSError)
                
            default:
                return false
            }
        }
}
