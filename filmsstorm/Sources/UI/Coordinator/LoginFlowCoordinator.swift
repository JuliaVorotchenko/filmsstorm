//
//  AppCoordinator.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 29.12.2019.
//  Copyright © 2019 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class LoginFlowCoordinator: Coordinator {
    
    // MARK: - Properties
    var eventHandler: ((AppCoordinatorEvent) -> Void)?
    var childCoordinators = [Coordinator]()
    let navigationController: UINavigationController
    private let networking = NetworkManager()
    
    // MARK: - Init and deinit
    
    init(navigationController: UINavigationController, eventHandler: ((AppCoordinatorEvent) -> Void)?) {
        self.navigationController = navigationController
        self.eventHandler = eventHandler
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
            self.eventHandler?(.main)
        case .error(let errorMessage):
            self.showAppErrorAlert(with: errorMessage)
        }
    }
}
