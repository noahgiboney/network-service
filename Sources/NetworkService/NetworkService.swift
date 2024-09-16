//
//  NetworkLayer.swift
//
//
//  Created by Noah Giboney on 9/1/24.
//

import Foundation

public protocol NetworkSession {
    func fetch<T: Codable>(path: String, decoder: JSONDecoder) async throws -> T
    
    func post<T: Codable>(path: String, object: T, encoder: JSONEncoder, decoder: JSONDecoder) async throws -> T
    
    func delete(path: String) async throws -> Data?
}

extension URLSession: NetworkSession {
    
    /// Performs a GET request from an API
    /// - Parameters:
    ///   - path: URL string to an API
    ///   - decoder: Optional JSON decoder for custom decoding
    /// - Returns: Codable Type
    public func fetch<T: Codable>(path: String,
                                  decoder: JSONDecoder = JSONDecoder()) async throws -> T {
        
        guard let url = URL(string: path) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let http = (response as? HTTPURLResponse), http.statusCode == 200 else {
            throw NetworkError.serverResponse
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    /// Performs a POST request to an API
    /// - Parameters:
    ///   - path: URL string to an API
    ///   - object: Codable object to POST to the API
    ///   - encoder: Optional JSON encoder for custom encoding
    ///   - decoder: Optional JSON decoder for custom decoding
    /// - Returns: Codable Type that was posted to API
    public func post<T: Codable>(path: String,
                                 object: T,
                                 encoder: JSONEncoder = JSONEncoder(),
                                 decoder: JSONDecoder = JSONDecoder()) async throws -> T {
        
        guard let url = URL(string: path) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        var data: Data
        
        do {
            data = try encoder.encode(object)
        } catch {
            throw NetworkError.encodingError
        }
        
        request.httpBody = data
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                throw NetworkError.serverResponse
            }
            
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingError
            }
            
        } catch {
            throw error
        }
    }
    
    /// Performs a DELETE request to an API
    /// - Parameter path: URL string to an API
    /// - Returns: Optional data depending on API response
    public func delete(path: String) async throws -> Data? {
        
        guard let url = URL(string: path) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.delete.method
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw NetworkError.serverResponse
        }
        
        return data
    }
}

