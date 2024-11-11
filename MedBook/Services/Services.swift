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
                    let response = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(Array(response.data.values)))
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
                    // Decode the response into the correct structure
                    let response = try JSONDecoder().decode(SearchResponse.self, from: data)
                    completion(.success(response.docs))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

