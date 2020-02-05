//
//  AppCoordinator.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 29.12.2019.
//  Copyright © 2019 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class LoginFlowCoordinator: Coordinator, AppEventSource {
    
    // MARK: - Properties
    var eventHandler: ((AppEvent) -> Void)?
    var childCoordinators = [Coordinator]()
    let navigationController = UINavigationController()
    private var networking = NetworkManager()
    
    // MARK: - Init and deinit
    
    init(networking: NetworkManager, eventHandler: ((AppEvent) -> Void)?) {
        self.networking = networking
        self.eventHandler = eventHandler
        self.navigationController.navigationBar.isHidden = true
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
            self.eventHandler?(.mainFlow)
        case .error(let errorMessage):
            self.showAppErrorAlert(with: errorMessage)
        }
    }
}
