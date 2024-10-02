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
    var decoder: JSONDecoder
    var encoder: JSONEncoder
    var headers: [String:String]?
    
    public init(
        endpoint: String,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder(),
        headers: [String : String]? = nil
    ) {
        self.endpoint = endpoint
        self.decoder = decoder
        self.encoder = encoder
        self.headers = headers
    }
}
