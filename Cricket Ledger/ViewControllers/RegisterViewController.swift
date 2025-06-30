//
//  RegisterViewController.swift
//  Cricket Ledger
//
//  Created by Sai Voruganti on 6/4/25.
//

import UIKit

class RegisterViewController: UIViewController {
    var viewModel = RegisterViewModel()

    let nameField = UITextField()
    let emailField = UITextField()
    let passwordField = UITextField()
    let registerButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    func setupUI() {
        nameField.placeholder = "Name"
        nameField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        nameField.borderStyle = .roundedRect
        emailField.placeholder = "Email"
        emailField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        emailField.borderStyle = .roundedRect
        passwordField.placeholder = "Password"
        passwordField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        passwordField.borderStyle = .roundedRect
        passwordField.isSecureTextEntry = true
        registerButton.setTitle("Register", for: .normal)
        registerButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        registerButton.backgroundColor = .systemBlue
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [nameField, emailField, passwordField, registerButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    @objc func registerTapped() {
        guard let name = nameField.text,
              let email = emailField.text,
              let password = passwordField.text else { return }

        if viewModel.register(name: name, email: email, password: password) {
            navigationController?.popViewController(animated: true)
        } else {
            showAlert("Registration Failed", "Try again.")
        }
    }

    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
