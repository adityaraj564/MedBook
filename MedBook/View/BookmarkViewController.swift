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
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            
            let bookmarkToDelete = self.bookmarks[indexPath.row]
            
            CoreDataManager.shared.deleteBookmark(bookmark: bookmarkToDelete, emailID: emailID)
            
            self.bookmarks.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = UIColor.red

        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeConfig.performsFirstActionWithFullSwipe = true

        return swipeConfig
    }

}
