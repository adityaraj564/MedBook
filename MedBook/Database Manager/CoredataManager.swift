//
//  CoredataManager.swift
//  MedBook
//
//  Created by Aditya Raj on 11/11/24.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {} // Prevents accidental instances
    
    private var persistentContainer: NSPersistentContainer {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func saveBookToBookmarks(book: Book, emailID: String) {
        let bookmark = Bookmark(context: context)
        bookmark.title = book.title
        bookmark.authorName = book.authorName
        bookmark.ratingsAverage = book.ratingsAverage ?? 0
        bookmark.ratingsCount = Int64(book.ratingsCount ?? 0)
        bookmark.coverImageURL = book.coverImageURL?.absoluteString
        bookmark.userEmail = emailID

        do {
            try context.save()
            print("Book saved to bookmarks")
        } catch {
            print("Failed to save book: \(error)")
        }
    }

    func fetchBookmarks(forEmail emailID: String) -> [Bookmark] {
        let fetchRequest: NSFetchRequest<Bookmark> = Bookmark.fetchRequest()

        // Add a predicate to filter bookmarks by the given email ID
        fetchRequest.predicate = NSPredicate(format: "userEmail == %@", emailID)

        do {
            // Perform the fetch and return the filtered results
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch bookmarks: \(error)")
            return []
        }
    }

    
    func deleteBookmark(bookmark: Bookmark, emailID: String) {
         // Ensure that only delete the bookmark if it matches the user's email ID
         if bookmark.userEmail == emailID {
             context.delete(bookmark)
             
             do {
                 try context.save()
                 print("Bookmark deleted for user: \(emailID)")
             } catch {
                 print("Failed to delete bookmark: \(error)")
             }
         } else {
             print("This bookmark does not belong to the current user.")
         }
     }

}

