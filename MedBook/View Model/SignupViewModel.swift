//
//  ViewModel.swift
//  MedBook
//
//  Created by Aditya Raj on 10/11/24.
//

import Foundation

class SignupViewModel {
    var email: String = ""
    var password: String = ""
    var name: String = ""
    var selectedCountry: Country?
    
    func validateEmail() -> Bool {
        // Basic email validation regex
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func validatePassword() -> Bool {
        // Password validation criteria
        return password.count >= 8 &&
               password.rangeOfCharacter(from: .uppercaseLetters) != nil &&
               password.rangeOfCharacter(from: .decimalDigits) != nil &&
               password.rangeOfCharacter(from: .symbols) != nil
    }
    
    func signup(completion: @escaping (Bool) -> Void) {
        if validateEmail() && validatePassword() && selectedCountry != nil {
            // Save user data locally
            let user = User(id: UUID().uuidString, name: name, email: email)
        
            LocalStorage.save(user: user)
            completion(true)
        } else {
            completion(false)
        }
    }
}

