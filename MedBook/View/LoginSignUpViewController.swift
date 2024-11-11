//
//  LoginSignUpViewController.swift
//  MedBook
//
//  Created by Aditya Raj on 10/11/24.
//

import Foundation
import UIKit

class LoginSignUpViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var characterCheckBox: UIImageView!
    @IBOutlet weak var upperCaseCheckBox: UIImageView!
    @IBOutlet weak var specialCharacterCheckBox: UIImageView!
    @IBOutlet weak var countrySelection: UIPickerView!
    @IBOutlet weak var letsGoButton: UIButton!
    
    @IBOutlet weak var mainViewForLogin: UIView!
    @IBOutlet weak var errorMessage: UILabel!
    
    var fromSignup = false
    var signupViewModel = SignupViewModel()
    var loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainViewForLogin.isHidden = !fromSignup
        setupViews()
        setupUI()
        signupViewModel.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        countrySelection.delegate = self
        countrySelection.dataSource = self
        signupViewModel.fetchAndLoadCountries()
    }
    
    func setupUI() {
        // Email field bottom border
        let emailBorder = CALayer()
        emailBorder.frame = CGRect(x: 0, y: emailField.frame.height - 1, width: emailField.frame.width, height: 1)
        emailBorder.backgroundColor = UIColor.lightGray.cgColor
        emailField.layer.addSublayer(emailBorder)
        
        // Password field bottom border
        let passwordBorder = CALayer()
        passwordBorder.frame = CGRect(x: 0, y: passwordField.frame.height - 1, width: passwordField.frame.width, height: 1)
        passwordBorder.backgroundColor = UIColor.lightGray.cgColor
        passwordField.layer.addSublayer(passwordBorder)
        
        setCheckboxImage(for: [characterCheckBox, upperCaseCheckBox, specialCharacterCheckBox])
    }
    
    func setCheckboxImage(for checkboxes: [UIImageView]) {
        checkboxes.forEach { checkbox in
            checkbox.image = UIImage(systemName: "square")
        }
    }
    
    func setupViews() {
        letsGoButton.isEnabled = false
        passwordField.addTarget(self, action: #selector(passwordDidChange), for: .editingChanged)
        emailField.addTarget(self, action: #selector(emailDidChange), for: .editingChanged)
    }

    @objc func passwordDidChange(_ textField: UITextField) {
        signupViewModel.password = textField.text ?? ""
//        validatePasswordCriteria()
        updateLetsGoButtonState()
    }
    
    @objc func emailDidChange(_ textField: UITextField) {
        signupViewModel.email = textField.text ?? ""
        updateLetsGoButtonState()
    }
    
    func validatePasswordCriteria() {
        let password = signupViewModel.password
        
        // Check if password meets each criterion and update the image accordingly
        characterCheckBox.image = password.count >= 8 ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square")
        upperCaseCheckBox.image = password.rangeOfCharacter(from: .uppercaseLetters) != nil ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square")
        let specialCharacters = CharacterSet.symbols.union(.punctuationCharacters)
        specialCharacterCheckBox.image = password.rangeOfCharacter(from: specialCharacters) != nil ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square")
    }
    
    func updateLetsGoButtonState() {
        // Enable button only if both fields are filled, password meets criteria, and a country is selected
        let isPasswordValid = characterCheckBox.image == UIImage(systemName: "checkmark.square.fill") &&
                              upperCaseCheckBox.image == UIImage(systemName: "checkmark.square.fill") &&
                              specialCharacterCheckBox.image == UIImage(systemName: "checkmark.square.fill")
        
        let isEmailFilled = !(signupViewModel.email.isEmpty)
        DispatchQueue.main.async {
            self.letsGoButton.isEnabled = isEmailFilled && isPasswordValid
        }
    }
    
    func errorMsg(flag: Bool, message: String, textColor: UIColor) {
        errorMessage.isHidden = flag
        errorMessage.text = message
        errorMessage.textColor = textColor
    }
    
    @IBAction func letsGoButtonTapped(_ sender: UIButton) {
        if fromSignup {
            signupViewModel.signup { success in
                if success {
                    self.errorMsg(flag: false, message: "Signup successful!", textColor: .green)
                    print("Signup successful!")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    self.errorMsg(flag: false, message: "Signup failed. Please check your details.", textColor: .red)
                    print("Signup failed. Please check your details.")
                }
            }
        } else {
            print("Proceeding with login...")
            loginViewModel.email = signupViewModel.email
            loginViewModel.password = signupViewModel.password
            loginViewModel.validateCredentials { success in
                if success {
                    self.errorMsg(flag: false, message: "Login successful!", textColor: .green)
                    print("Login successful!")
                    // Proceed to next screen or home screen
                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "BooksViewController") as? BooksViewController {
                        vc.emailID = self.loginViewModel.email
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    self.errorMsg(flag: false, message: "Login failed. Invalid email or password.", textColor: .red)
                    print("Login failed. Invalid email or password.")
                }
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
       
       func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }

       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return signupViewModel.countries.count
       }

       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           return signupViewModel.countries[row].country
       }

       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           signupViewModel.selectedCountry = signupViewModel.countries[row]
       }
}

extension LoginSignUpViewController: SignupViewModelDelegate {
    func validatePassword(isValidCharacterCount: Bool, isUpperCase: Bool, isSpecialCharacter: Bool) {
        characterCheckBox.image = isValidCharacterCount ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square")
        upperCaseCheckBox.image = isUpperCase ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square")
        specialCharacterCheckBox.image = isSpecialCharacter ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square")
    }
    
    
    func reloadcountrySelection() {
        DispatchQueue.main.async {
            self.countrySelection.reloadAllComponents()
        }
    }
}
