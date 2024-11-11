//
//  CountryModel.swift
//  MedBook
//
//  Created by Aditya Raj on 10/11/24.
//

import Foundation

struct Country: Codable {
    let country: String  // This matches the "country" key in the JSON response
    
    enum CodingKeys: String, CodingKey {
        case country
    }
}
