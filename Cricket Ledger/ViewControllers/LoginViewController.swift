//
//  LoginViewController.swift
//  Cricket Ledger
//
//  Created by Sai Voruganti on 6/4/25.
//
//
import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
 
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    

    var viewModel = LoginViewModel()
    var coordinator: AppCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
                    googleSignInButton.style = .wide
    }

   
    @IBAction func googleSignInTapped(_ sender: Any) {
        viewModel.signInWithGoogle(presentingViewController: self) { result in
            switch result {
            case .success(let user):
                self.coordinator?.showHome()
                print("Logged in user: \(user.uid), \(user.email ?? "")")
            case .failure(let error):
                print("Login failed: \(error.localizedDescription)")
            }
        }

    }


    @IBAction func loginTapped(_ sender: Any) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else { return }

        if viewModel.login(email: email, password: password) {
            coordinator?.showHome()
        } else {
            showAlert("Login Failed", "Invalid credentials")
        }
    }

    @IBAction func registerTapped(_ sender: Any) {
        coordinator?.showRegister()
    }

    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
