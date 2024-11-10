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
    static func retrieveUser() -> User? {
        if let savedUserData = UserDefaults.standard.data(forKey: userKey) {
            let decoder = JSONDecoder()
            if let user = try? decoder.decode(User.self, from: savedUserData) {
                return user
            }
        }
        return nil
    }
    
    // Method to clear the user data, for example, on logout
    static func clearUser() {
        UserDefaults.standard.removeObject(forKey: userKey)
    }
}
