//
//  NetworkError.swift
//  
//
//  Created by Noah Giboney on 9/1/24.
//

import Foundation

public enum NetworkError: Error {
    case badUrl
    case decodingError
    case encodingError
    case serverResponse
    case error(Error)
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badUrl:
            "The URl was invalid."
        case .decodingError:
            "There was an error decoding the data."
        case .encodingError:
            "There was an error encoding the data."
        case .serverResponse:
            "The server responded with an error."
        case .error(let error):
            error.localizedDescription
        }
    }
}
