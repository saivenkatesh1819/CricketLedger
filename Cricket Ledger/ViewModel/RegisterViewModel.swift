//
//  RegisterViewModel.swift
//  Cricket Ledger
//
//  Created by Sai Voruganti on 6/4/25.
//

import Foundation

class RegisterViewModel {
    func register(name: String, email: String, password: String) -> Bool {
        return UserRepository.shared.registerUser(name: name, email: email, password: password)
    }
}
