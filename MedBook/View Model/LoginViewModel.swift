//
//  LoginViewModel.swift
//  MedBook
//
//  Created by Aditya Raj on 11/11/24.
//

import Foundation

class LoginViewModel {
    var email: String = ""
    var password: String = ""

    func validateCredentials(completion: @escaping (Bool) -> Void) {
        LocalStorage.retrieveUser { user in
            let savedEmail = user?.email
            let savedPassword = user?.password
            completion(self.email == savedEmail && self.password == savedPassword)
        }
    }
}
