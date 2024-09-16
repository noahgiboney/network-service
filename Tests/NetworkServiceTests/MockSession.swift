//
//  File.swift
//  
//
//  Created by Noah Giboney on 9/15/24.
//

import Foundation
import NetworkService

class MockSession: NetworkSession {
    
    var data: Data?
    var error: NetworkError?
    
    func fetch<T: Codable>(path: String, decoder: JSONDecoder = JSONDecoder()) async throws -> T {
        if let error = error {
            throw error
        }
        
        guard let data = data else { throw NetworkError.serverResponse}
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func post<T>(path: String, object: T, encoder: JSONEncoder = JSONEncoder(), decoder: JSONDecoder = JSONDecoder()) async throws -> T where T : Decodable, T : Encodable {
        if let error = error {
            throw error
        }
        
        do {
            data = try encoder.encode(object)
        } catch {
            throw NetworkError.encodingError
        }
        
        guard let data = data else { throw NetworkError.serverResponse}
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func delete(path: String) async throws -> Data? {
        if let error = error {
            throw error
        }
        
        return data
    }
}
