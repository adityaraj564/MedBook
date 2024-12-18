//
//  LocalStorage.swift
//  MedBook
//
//  Created by Aditya Raj on 10/11/24.
//

import Foundation

struct LocalStorage {
    private static let userKey = "savedUser"
    
    // Method to save the user data
    static func save(user: User) {
        let encoder = JSONEncoder()
        if let encodedUser = try? encoder.encode(user) {
            UserDefaults.standard.set(encodedUser, forKey: userKey)
        }
    }
    
    // Method to retrieve the user data
    static func retrieveUser(completion: @escaping (User?) -> Void) {
        if let savedUserData = UserDefaults.standard.data(forKey: userKey) {
            let decoder = JSONDecoder()
            if let user = try? decoder.decode(User.self, from: savedUserData) {
                completion(user) 
                return
            }
        }
        completion(nil)
    }

    
    static func clearUser() {
        UserDefaults.standard.removeObject(forKey: userKey)
    }
}
