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
    /// - Returns: Codable Type fetched from API
    public func fetch<T: Codable>(path: String,
                                  decoder: JSONDecoder = JSONDecoder()) async throws -> T {
        
        let resource = Resource(url: path, method: .get, decoder: decoder)
        let response = try await makeRequest(for: resource)
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
        
        let body = try encodeData(object, encoder: encoder)
        let resource = Resource(url: path, method: .post, decoder: decoder, httpBody: body)
        let response = try await makeRequest(for: resource)
        return try decodeData(response, decoder: decoder)
    }
    
    /// Performs a DELETE request to an API
    /// - Parameter path: URL string to an API
    /// - Returns: Optional data depending on API response
    public func delete(path: String) async throws -> Data {
        let resource = Resource(url: path, method: .delete, decoder: JSONDecoder())
        return try await makeRequest(for: resource)
    }
    
    /// Performs a PUT request to an API
    /// - Parameters:
    ///   - path: URL string to an API
    ///   - updatedObject: Codable object with update fields
    ///   - encoder: Optional JSON encoder for custom encoding
    ///   - decoder: Optional JSON decoder for custom decoding
    /// - Returns: Codable Type from API that was updated
    public func update<T: Codable>(path: String,
                                   updatedObject: T,
                                   encoder: JSONEncoder = JSONEncoder(),
                                   decoder: JSONDecoder = JSONDecoder()) async throws -> T {
        
        let body = try encodeData(updatedObject, encoder: encoder)
        let resource = Resource(url: path, method: .put, decoder: decoder, httpBody: body)
        let response = try await makeRequest(for: resource)
        return try decodeData(response, decoder: decoder)
    }
    
    /// Performs a PATCH request to an API
    /// - Parameters:
    ///   - path: URL string to an API
    ///   - updatedFields: JSON Dictonary of updated fields to patch with
    ///   - decoder: Optional JSON decoder for custom decoding
    /// - Returns: Codable Type patched from the API
    public func patch<T: Codable>(path: String, updatedFields: [String : Any], decoder: JSONDecoder = JSONDecoder()) async throws -> T {
        var body: Data?
        
        do {
            body = try JSONSerialization.data(withJSONObject: updatedFields, options: [])
        } catch {
            throw NetworkError.badRequest
        }
        
        let resource = Resource(url: path, method: .patch, decoder: decoder, httpBody: body)
        let response = try await makeRequest(for: resource)
        return try decodeData(response, decoder: decoder)
    }
}

// MARK: - Util

extension URLSession {
    
    /// Makes a URLRequest with the give resource
    /// - Parameter resource: Resource object with data needed to make request
    /// - Returns: Data from the request
    private func makeRequest(for resource: Resource) async throws -> Data {
        
        /// validate endpoint
        guard let url = URL(string: resource.url) else {
            throw NetworkError.invalidURL
        }
        
        /// prepare request
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = resource.method.description
        
        /// setup http body if needed
        if let httpBody = resource.httpBody {
            request.httpBody = httpBody
        }
        
        /// make request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        /// validate server response
        guard let httpResponse = (response as? HTTPURLResponse), resource.method.responseCodes.contains(httpResponse.statusCode) else {
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

