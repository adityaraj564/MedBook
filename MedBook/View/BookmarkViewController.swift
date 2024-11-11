//
//  BookmarkViewController.swift
//  MedBook
//
//  Created by Aditya Raj on 11/11/24.
//

import Foundation
import UIKit

class BookmarkCell: UITableViewCell {
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var ratingCount: UILabel!
}
class BookmarkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultFound: UILabel!
    
    var bookmarks: [Bookmark] = []
    var emailID = ""

       override func viewDidLoad() {
           super.viewDidLoad()
           title = "Bookmarks"
           tableView.delegate = self
           tableView.dataSource = self
           fetchBookmarks(forEmail: emailID)
           
       }

       private func fetchBookmarks(forEmail emailID: String) {
           bookmarks = CoreDataManager.shared.fetchBookmarks(forEmail: emailID)
           if !bookmarks.isEmpty {
               noResultFound.isHidden = false
           }
           tableView.reloadData()
       }

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return bookmarks.count
       }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkCell", for: indexPath) as! BookmarkCell
           let bookmark = bookmarks[indexPath.row]
           noResultFound.isHidden = !bookmarks.isEmpty
           cell.bookName.text = bookmark.title
           cell.authorName.text = bookmark.authorName
           cell.rating.text = "\(bookmark.ratingsAverage)/5"
           cell.ratingCount.text = "\(bookmark.ratingsCount)"

           if let urlString = bookmark.coverImageURL, let url = URL(string: urlString) {
               URLSession.shared.dataTask(with: url) { data, _, _ in
                   if let data = data, let image = UIImage(data: data) {
                       DispatchQueue.main.async {
                           cell.coverImage.image = image
                       }
                   }
               }.resume()
           }

           return cell
       }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Define the delete action
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            
            // Get the bookmark to delete
            let bookmarkToDelete = self.bookmarks[indexPath.row]
            
            // Delete from Core Data using email ID
            CoreDataManager.shared.deleteBookmark(bookmark: bookmarkToDelete, emailID: emailID)
            
            // Update the local bookmarks array and table view
            self.bookmarks.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // Complete the action
            completionHandler(true)
        }
        
        // Create a swipe configuration with the delete action
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfig
    }
}
