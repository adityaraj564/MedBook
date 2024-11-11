//
//  BookModel.swift
//  MedBook
//
//  Created by Aditya Raj on 10/11/24.
//

import Foundation

struct Book: Codable {
    let title: String
    let ratingsAverage: Double?
    let ratingsCount: Int?
    let authorName: String?
    let coverId: Int?
    let userEmail: String?

    var coverImageURL: URL? {
        guard let coverId = coverId else { return nil }
        return URL(string: "https://covers.openlibrary.org/b/id/\(coverId)-M.jpg")
    }
}

