//
//  Resourse.swift
//  NetworkService
//
//  Created by Noah Giboney on 9/17/24.
//

import Foundation

struct Resource {
    let url: String
    let method: HTTPMethod
    let decoder: JSONDecoder
    var httpBody: Data?
}
