//
//  Resourse.swift
//  NetworkService
//
//  Created by Noah Giboney on 9/17/24.
//

import Foundation

/// Resource to create a URL Request with
public struct Resource {
    let endpoint: String
    let method: HTTPMethod
    var decoder: JSONDecoder = JSONDecoder()
    var encoder: JSONEncoder = JSONEncoder()
    var headers: [String:String]?
    
    public init(endpoint: String, method: HTTPMethod, decoder: JSONDecoder, encoder: JSONEncoder, headers: [String : String]? = nil) {
        self.endpoint = endpoint
        self.method = method
        self.decoder = decoder
        self.encoder = encoder
        self.headers = headers
    }
}
