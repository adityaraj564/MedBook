//
//  HomeViewModel.swift
//  MedBook
//
//  Created by Aditya Raj on 10/11/24.
//

import Foundation
import UIKit

class HomeViewModel {
    private var books: [Book] = []
    private var sortedBooks: [Book] = []
    
    var onBooksUpdated: (([Book]) -> Void)?
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
            // Clear user data on logout
            LocalStorage.clearUser()
            
            // Navigate back to the Landing screen
            let landingVC = LandingViewController()
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = UINavigationController(rootViewController: landingVC)
                window.makeKeyAndVisible()
            }
        }
    
    func searchBooks(query: String) {
        guard query.count >= 3 else { return }
        APIService.shared.fetchBooks(query: query) { [weak self] result in
            switch result {
            case .success(let books):
                self?.books = books
                self?.onBooksUpdated?(books)
            case .failure(let error):
                print("Error fetching books: \(error)")
            }
        }
    }
    
    func sortBooks(by criteria: SortingCriteria) {
        switch criteria {
        case .title:
            sortedBooks = books.sorted(by: { $0.title < $1.title })
        case .averageRating:
            sortedBooks = books.sorted(by: { ($0.ratingsAverage ?? 0) > ($1.ratingsAverage ?? 0) })
        case .hits:
            sortedBooks = books.sorted(by: { ($0.ratingsCount ?? 0) > ($1.ratingsCount ?? 0) })
        }
        onBooksUpdated?(sortedBooks)
    }
    
    enum SortingCriteria {
        case title, averageRating, hits
    }
}

