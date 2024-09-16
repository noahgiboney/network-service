//
//  File.swift
//  
//
//  Created by Noah Giboney on 9/6/24.
//

import Foundation

struct User: Codable, Identifiable, Equatable {
    var id: Int
    let name: String
    let email: String
}

struct NonCodableUser: Identifiable {
    var id: Int
    var name: String
}
