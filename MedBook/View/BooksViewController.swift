//
//  LoginViewController.swift
//  MedBook
//
//  Created by Aditya Raj on 10/11/24.
//

import UIKit

class CustomCell: UITableViewCell {
    @IBOutlet weak var booksImage: UIImageView!
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var totalSale: UILabel!
}

class BooksViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sortBy: UISegmentedControl!
    @IBOutlet weak var noResultFound: UILabel!
    
    let viewModel = HomeViewModel()
    var books: [Book] = []
    var emailID = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.onBooksUpdated = { [weak self] books in
            self?.books = books
            DispatchQueue.main.async {
                self?.sortBooks()
            }
        }
        
        searchBar.delegate = self
        setupNavigationBar()
    }
    
    @IBAction func sortByChanged(_ sender: UISegmentedControl) {
        sortBooks()
    }
    
    private func sortBooks() {
        switch sortBy.selectedSegmentIndex {
        case 0: // Sort by Title
            books.sort { $0.title < $1.title }
        case 1: // Sort by Average (ratingsAverage)
            books.sort { ($0.ratingsAverage ?? 0) > ($1.ratingsAverage ?? 0) }
        case 2: // Sort by Hits (ratingsCount)
            books.sort { ($0.ratingsCount ?? 0) > ($1.ratingsCount ?? 0) }
        default:
            break
        }
        tableView.reloadData()
    }
    
    private func setupNavigationBar() {
        // Set title to "MedBook" in bold, left aligned
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 30)
        ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        navigationItem.title = "MedBook"
        
        // Hide the back button
        navigationItem.hidesBackButton = true
        
        // Set up bookmark button on the left side
        let bookmarkButton = UIBarButtonItem(image: UIImage(systemName: "bookmark.fill"), style: .plain, target: self, action: #selector(bookmarkButtonTapped))
        
        // Set up logout button on the right side
        let logoutButton = UIBarButtonItem(image: UIImage(systemName: "xmark.circle.fill"), style: .plain, target: self, action: #selector(logoutButtonTapped))
        bookmarkButton.tintColor = .black
        logoutButton.tintColor = .red
        // Add both buttons to the right side of the navigation bar
        navigationItem.rightBarButtonItems = [logoutButton, bookmarkButton]
    }
    
    // Action for bookmark button
    @objc private func bookmarkButtonTapped() {
        if let bookmarkVC = storyboard?.instantiateViewController(withIdentifier: "BookmarkViewController") as? BookmarkViewController {
            bookmarkVC.emailID = emailID
            self.navigationController?.pushViewController(bookmarkVC, animated: true)
        }
    }
    
    // Action for logout button
    @objc private func logoutButtonTapped() {
        // Handle logout action
        print("Logout button tapped")
        // Clear user data on logout
        LocalStorage.clearUser()
        
        // Navigate back to the Landing screen
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
        // Instantiate the view controller with the identifier
        let landingVC = storyboard.instantiateViewController(withIdentifier: "HomeView") as! HomeViewController
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UINavigationController(rootViewController: landingVC)
            window.makeKeyAndVisible()
        }
    }
}

extension BooksViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count  // Return the number of books
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue cell using the identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        // Get the book for the current row
        noResultFound.isHidden = !books.isEmpty
        if !books.isEmpty {
            let book = books[indexPath.row]
            // Assign the book's properties to the cell
            cell.bookName.text = book.title
            cell.authorName.text = book.authorName
            cell.rating.text = "\(book.ratingsAverage ?? 0)/5"
            cell.totalSale.text = "\(book.ratingsCount ?? 0)"
            
            // If the book has an image, set it to the UIImageView
            if let imageUrl = book.coverImageURL {
                // Fetch the image from the URL asynchronously
                URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.booksImage.image = image
                        }
                    }
                }.resume()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let saveAction = UIContextualAction(style: .normal, title: "Save") { [weak self] (action, view, completionHandler) in
                guard let self = self else { return }
                let book = self.books[indexPath.row]
                
                CoreDataManager.shared.saveBookToBookmarks(book: book, emailID: emailID)
                completionHandler(true)
            }
            saveAction.backgroundColor = .systemGreen
            return UISwipeActionsConfiguration(actions: [saveAction])
        }
}

extension BooksViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchBooks(query: searchText)
        books.count
    }
}



