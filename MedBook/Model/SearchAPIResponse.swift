//
//  SearchAPIResponse.swift
//  MedBook
//
//  Created by Aditya Raj on 11/11/24.
//

import Foundation

struct SearchResponse: Codable {
    let docs: [Book]
}
