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

extension URLSession {
    /// Performs a GET request from an API
    /// - Parameter resource: Resource for the request
    /// - Returns: Codable Type fetched from API
    public func fetch<T: Codable>(resource: Resource) async throws -> T {
        let response = try await makeRequest(for: resource)
        return try decodeData(response, decoder: resource.decoder)
    }
    
    /// Performs a POST request to an API
    /// - Parameters:
    ///   - resource: Resource for the request
    ///   - object: Codable object to POST to the API
    /// - Returns: Codable Type that was posted to API
    public func post<T: Codable>(resource: Resource, object: T) async throws -> T {
        let body = try encodeData(object, encoder: resource.encoder)
        let response = try await makeRequest(for: resource, httpBody: body)
        return try decodeData(response, decoder: resource.decoder)
    }
    
    /// Performs a DELETE request to an API
    /// - Parameter resource: Resource for the request
    /// - Returns: Optional data depending on API response
    public func delete(resource: Resource) async throws -> Data {
        return try await makeRequest(for: resource)
    }
    
    /// Performs a PUT request to an API
    /// - Parameters:
    ///   - resource: Resource for the request
    ///   - object: Codable object to POST to the API
    /// - Returns: Codable Type from API that was updated
    public func update<T: Codable>(resource: Resource, object: T) async throws -> T {
        let body = try encodeData(object, encoder: resource.encoder)
        let response = try await makeRequest(for: resource, httpBody: body)
        return try decodeData(response, decoder: resource.decoder)
    }
    
    /// Performs a PATCH request to an API
    /// - Parameters:
    ///   - resource: Resource for the request
    ///   - updatedFields: JSON Dictonary of updated fields to patch with
    /// - Returns: Codable Type patched from the API
    public func patch<T: Codable>(resource: Resource, updatedFields: [String : Any]) async throws -> T {
        var body: Data?
        
        do {
            body = try JSONSerialization.data(withJSONObject: updatedFields, options: [])
        } catch {
            throw NetworkError.badRequest
        }
        let response = try await makeRequest(for: resource, httpBody: body)
        return try decodeData(response, decoder: resource.decoder)
    }
}

// MARK: - Util

extension URLSession {
    
    /// Makes a URLRequest with the give resource
    /// - Parameter resource: Resource object with data needed to make request
    /// - Returns: Data from the request
    private func makeRequest(for resource: Resource, httpBody: Data? = nil) async throws -> Data {
        
        /// validate endpoint
        guard let endpoint = URL(string: resource.endpoint) else {
            throw NetworkError.invalidURL
        }
        
        /// prepare request
        var request = URLRequest(url: endpoint)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = resource.method.rawValue
        
        /// setup http body if needed
        if let body = httpBody {
            request.httpBody = body
        }
        
        if let headers = resource.headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
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

