//
//  NetworkLayer.swift
//
//
//  Created by Noah Giboney on 9/1/24.
//

import Foundation

extension URLSession {
    
    public func fetch<T: Codable>(path: String,
                           decoder: JSONDecoder = JSONDecoder()) async -> Result<T, NetworkError> {
        
        /// validate url
        guard let url = URL(string: path) else {
            return .failure(.badUrl)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            /// check server response
            guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                return .failure(NetworkError.serverResponse)
            }
            
            return decodeData(data, with: decoder)
        } catch {
            return .failure(.error(error))
        }
    }
    
    public func post<T: Codable>(path: String,
                          object: T,
                          encoder: JSONEncoder = JSONEncoder(),
                          decoder: JSONDecoder = JSONDecoder()) async -> Result<T, NetworkError> {
        
        /// validate url
        guard let url = URL(string: path) else {
            return .failure(NetworkError.badUrl)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        var data: Data
        
        do {
            data = try encoder.encode(object)
        } catch {
            return .failure(.codingError)
        }
        
        request.httpBody = data
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            /// check server response
            guard let http = response as? HTTPURLResponse, http.statusCode == 201 else {
                return .failure(NetworkError.serverResponse)
            }
            
            return decodeData(data, with: decoder)
        } catch {
            return .failure(.error(error))
        }
    }
    
    public func delete(path: String) async -> Result<Data?, NetworkError> {
        
        /// validate url
        guard let url = URL(string: path) else {
            return .failure(NetworkError.badUrl)
        }
        
        /// configure request
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.delete.method
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            /// check server response
            guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                return .failure(NetworkError.serverResponse)
            }
            
            return .success(data)
        } catch {
            return .failure(.error(error))
        }
    }
}

// MARK: - Helpers
extension URLSession {
    
    private func decodeData<T:Codable>(_ data: Data, with decoder: JSONDecoder) -> Result<T, NetworkError> {
        do {
            let result = try decoder.decode(T.self, from: data)
            return .success(result)
        } catch {
            return .failure(.codingError)
        }
    }
}

