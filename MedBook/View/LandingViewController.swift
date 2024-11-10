//
//  LandingViewController.swift
//  MedBook
//
//  Created by Aditya Raj on 10/11/24.
//

import UIKit

class LandingViewController: UIViewController {
    
    // UI Elements
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to the App!"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(welcomeLabel)
        view.addSubview(loginButton)
        
        // Set up Auto Layout
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20)
        ])
    }
    
    @objc private func loginButtonTapped() {
        // Perform login actions here, e.g., navigate to the login screen or show login form
        print("Login button tapped")
    }
}

