//
//  ViewModel.swift
//  MedBook
//
//  Created by Aditya Raj on 10/11/24.
//

import Foundation

@objc protocol SignupViewModelDelegate {
    func reloadcountrySelection()
    func validatePassword(isValidCharacterCount: Bool, isUpperCase: Bool, isSpecialCharacter: Bool)
    
}
class SignupViewModel {
    weak var delegate: SignupViewModelDelegate?
    var email: String = ""
    var password: String = "" {
        didSet { 
            verifyPasswordForCheckbox()
        }
    }
    var name: String = ""
    var selectedCountry: Country?
    private(set) var countries: [Country] = []
    
    func validateEmail() -> Bool {
        // Basic email validation regex
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func validatePassword() -> Bool {
        // Password validation criteria
        let specialCharacters = CharacterSet.symbols.union(.punctuationCharacters)
        return password.count >= 8 &&
               password.rangeOfCharacter(from: .uppercaseLetters) != nil &&
               password.rangeOfCharacter(from: .decimalDigits) != nil &&
               password.rangeOfCharacter(from: specialCharacters) != nil
    }
    
    private func verifyPasswordForCheckbox() {
        let specialCharacters = CharacterSet.symbols.union(.punctuationCharacters)
        let isValidCharacterCount = password.count >= 8
        let isUpperCase = password.rangeOfCharacter(from: .uppercaseLetters) != nil
        let isSpecialCharacter = password.rangeOfCharacter(from: specialCharacters) != nil
        delegate?.validatePassword(isValidCharacterCount: isValidCharacterCount, isUpperCase: isUpperCase, isSpecialCharacter: isSpecialCharacter)
    }
    
    func signup(completion: @escaping (Bool) -> Void) {
        if validateEmail() && validatePassword() && selectedCountry != nil {
            // Save user data locally
            let user = User(id: UUID().uuidString, email: email, password: password)
        
            LocalStorage.save(user: user)
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func fetchAndLoadCountries() {
        APIService.shared.fetchCountries { [weak self] result in
            switch result {
            case .success(let countries):
                self?.countries = countries
                self?.delegate?.reloadcountrySelection()
            case .failure(let error):
                print("Error fetching countries: \(error)")
            }
        }
    }
}

