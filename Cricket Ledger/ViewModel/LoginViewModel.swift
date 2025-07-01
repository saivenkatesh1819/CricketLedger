////
////  LoginViewModel.swift
////  Cricket Ledger
////
////  Created by Sai Voruganti on 6/4/25.
////


struct AppUser {
    let uid: String
    let email: String?
}
import Foundation
import GoogleSignIn
import FirebaseAuth
import FirebaseCore
import UIKit

class LoginViewModel {

    func login(email: String, password: String) -> Bool {
        return UserRepository.shared.validateUser(email: email, password: password)
    }

    func signInWithGoogle(presentingViewController: UIViewController, completion: @escaping (Result<AppUser, Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(.failure(NSError(domain: "MissingClientID", code: -1, userInfo: nil)))
            return
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard
                let user = result?.user,
                let idToken = user.idToken?.tokenString
            else {
                completion(.failure(NSError(domain: "MissingGoogleCredentials", code: -1, userInfo: nil)))
                return
            }

            let accessToken = user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let firebaseUser: FirebaseAuth.User = authResult?.user else {
                    completion(.failure(NSError(domain: "NoFirebaseUser", code: -1, userInfo: nil)))
                    return
                }

                let appUser = AppUser(uid: firebaseUser.uid, email: firebaseUser.email)
                completion(.success(appUser))
            }
        }
    }
}

