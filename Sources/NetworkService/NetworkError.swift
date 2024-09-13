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
