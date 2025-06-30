//
//  AppCoordinator.swift
//  Cricket Ledger
//
//  Created by Sai Voruganti on 6/4/25.
//

import Foundation
import UIKit
import SwiftUI

class AppCoordinator {
    var navigationController: UINavigationController

    init(navigation: UINavigationController) {
        self.navigationController = navigation
    }

    func showHome() {
        let homeView = HomeView(coordinator: self)
        let hostingVC = UIHostingController(rootView: homeView)
        navigationController.setViewControllers([hostingVC], animated: true)
    }

    func showRegister() {
        let registerVC = RegisterViewController()
        navigationController.pushViewController(registerVC, animated: true)
    }

    func logout() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
                fatalError("LoginViewController not found in storyboard.")
            }
            loginVC.coordinator = self
            navigationController.setViewControllers([loginVC], animated: true)
        
    }

    func selectPlayers() {
        let selectPlayerVC = SelectPlayers(selectPlayersVM: SelectPlayersViewModel())
        let hostingVC = UIHostingController(rootView: selectPlayerVC)
        navigationController.setViewControllers([hostingVC], animated: true)
    }
}
