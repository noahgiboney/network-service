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
    
    func delete(path: String) async throws -> Data
}


// MARK: - HTTP Methods

extension URLSession: NetworkSession {
    
    /// Performs a GET request from an API
    /// - Parameters:
    ///   - path: URL string to an API
    ///   - decoder: Optional JSON decoder for custom decoding
    /// - Returns: Codable Type
    public func fetch<T: Codable>(path: String,
                                  decoder: JSONDecoder = JSONDecoder()) async throws -> T {
        
        let response = try await makeRequest(httpMethod: .get, endpoint: path, model: Optional<T>.none)
        return try decodeData(response, decoder: decoder)
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
        
        let response = try await makeRequest(httpMethod: .post, endpoint: path, model: object, encoder: encoder)
        return try decodeData(response, decoder: decoder)
    }
    
    /// Performs a DELETE request to an API
    /// - Parameter path: URL string to an API
    /// - Returns: Optional data depending on API response
    public func delete(path: String) async throws -> Data {
        return try await makeRequest(httpMethod: .delete, endpoint: path, model: Optional<Data>.none)
    }
    
    /// Performs a PUT request to an API
    /// - Parameters:
    ///   - path: URL string to an API
    ///   - updatedObject: Codable object with update fields
    ///   - encoder: Optional JSON encoder for custom encoding
    ///   - decoder: Optional JSON decoder for custom decoding
    /// - Returns: Codable Type that was posted to API
    func update<T: Codable>(path: String,
                            updatedObject: T,
                            encoder: JSONEncoder = JSONEncoder(),
                            decoder: JSONDecoder = JSONDecoder()) async throws -> T {
        
        let response = try await makeRequest(httpMethod: .put, endpoint: path, model: updatedObject, encoder: encoder)
        return try decodeData(response, decoder: decoder)
    }
}

// MARK: - Util

extension URLSession {
    
    /// Makes a URLRequest for given httpMethod
    /// - Parameters:
    ///   - httpMethod: HTTPMethod to make
    ///   - endpoint: URL string to an API
    ///   - model: Optional codable object to make request with
    ///   - encoder: Optional JSON encoder for custom encoding
    /// - Returns: Data from URLRequest
    private func makeRequest<T: Codable>(httpMethod: HTTPMethod,
                             endpoint: String,
                             model: T? = nil,
                             encoder: JSONEncoder? = nil) async throws -> Data {
        
        /// validate endpoint
        guard let url = URL(string: endpoint) else {
            throw NetworkError.invalidURL
        }
        
        /// prepare request
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = httpMethod.method
        var requestBody: Data?
        
        /// setup http body if needed
        if let model = model, [.post, .put].contains(httpMethod) {
            
            guard let encoder = encoder else { throw NetworkError.badRequest }
            
            requestBody = try encodeData(model, encoder: encoder)
        }
        
        request.httpBody = requestBody
        
        /// make request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        /// validate server response
        guard let httpResponse = (response as? HTTPURLResponse), httpMethod.responseCodes.contains(httpResponse.statusCode) else {
            throw NetworkError.serverResponse
        }

        return data
    }
    
    private func decodeData<T: Codable>(_ data: Data, decoder: JSONDecoder) throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    private func encodeData<T: Codable>(_ model: T, encoder: JSONEncoder) throws -> Data {
        do {
            return try encoder.encode(model)
        } catch {
            throw NetworkError.decodingError
        }
    }
}

