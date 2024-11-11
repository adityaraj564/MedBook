//
//  HomeViewController.swift
//  MedBook
//
//  Created by Aditya Raj on 10/11/24.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.titleLabel?.text = "Signup"
        loginButton.titleLabel?.text = "Login"
        signUpButton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }
    
    @objc func signupTapped() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "LoginSignUpViewController") as? LoginSignUpViewController {
            vc.fromSignup = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func loginTapped() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "LoginSignUpViewController") as? LoginSignUpViewController {
            vc.fromSignup = false
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
