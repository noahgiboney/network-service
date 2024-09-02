//
//  File.swift
//
//
//  Created by Noah Giboney on 9/1/24.
//

import Foundation

extension URLSession {
    
    func fetch<T: Codable>(path: String,
                           decoder: JSONDecoder = JSONDecoder()) async -> Result<T, NetworkError> {
        
        /// validate url
        guard let url = URL(string: path) else {
            return .failure(.badUrl)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            /// check server response
            guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                return .failure(.serverResponse)
            }
            
            /// decode data
            do {
                let result = try decoder.decode(T.self, from: data)
                return .success(result)
            } catch {
                return .failure(.decodingError)
            }
        } catch {
            return .failure(.decodingError)
        }
    }
}

