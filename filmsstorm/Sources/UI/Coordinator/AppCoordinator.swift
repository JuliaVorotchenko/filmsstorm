//
//  AppCoordinator.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 29.12.2019.
//  Copyright © 2019 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    
    var childCoordinators = [Coordinator]()
    let navigationController: UINavigationController
    private let networking = NetworkManager()
    
    // MARK: - Init and deinit
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator
    
    func start() {
        self.createAuthController()
    }
    
    // MARK: - Private methods
    
    private func createAuthController() {
        let controller = AuthorizationViewController(networking: self.networking, event: self.authEvent)
        self.navigationController.viewControllers = [controller]
    }
    private func authEvent(_ event: AuthEvent) {
        switch event {
        case .login:
            self.createMianViewController()
        case .error(let errorMessage):
            self.showAppErrorAlert(with: errorMessage)
        }
    }
    
    private func createMianViewController() {
        let controller = MainViewController(networking: self.networking, event: self.sessionEvent)
        self.navigationController.viewControllers = [controller]
    }
    
    private func sessionEvent(_ event: SessionIDEvent) {
        switch event {
        case .back:
            self.createAuthController()
        case .showSessionId:
            print("Session ID")
        case .error(let errorMessage):
            self.showAppErrorAlert(with: errorMessage)
        }
    }
}
