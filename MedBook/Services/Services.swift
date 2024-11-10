//
//  Services.swift
//  MedBook
//
//  Created by Aditya Raj on 10/11/24.
//

import Foundation

class APIService {
    static let shared = APIService()
    
    func fetchCountries(completion: @escaping (Result<[Country], Error>) -> Void) {
        let url = URL(string: "https://api.first.org/data/v1/countries")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let response = try JSONDecoder().decode([String: Country].self, from: data)
                    completion(.success(Array(response.values)))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func fetchBooks(query: String, completion: @escaping (Result<[Book], Error>) -> Void) {
        let url = URL(string: "https://openlibrary.org/search.json?title=\(query)&limit=10")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let response = try JSONDecoder().decode([String: [Book]].self, from: data)
                    if let books = response["docs"] {
                        completion(.success(books))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

