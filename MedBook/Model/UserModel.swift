//
//  UserModel.swift
//  MedBook
//
//  Created by Aditya Raj on 10/11/24.
//

import Foundation

struct User: Codable {
    let id: String
    let email: String?
    let password: String
    
    
    // You can add custom encoding and decoding if needed
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case password
    }
}


