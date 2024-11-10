//
//  HomeViewController.swift
//  MedBook
//
//  Created by Aditya Raj on 10/11/24.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let viewModel = HomeViewModel()
    var books: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.onBooksUpdated = { [weak self] books in
            self?.books = books
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        searchBar.delegate = self
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchBooks(query: searchText)
    }
}



