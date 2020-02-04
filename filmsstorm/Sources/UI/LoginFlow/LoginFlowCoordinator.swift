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

    var childCoordinators = [Coordinator]()
    let eventHandler: ((AppEvent) -> Void)?
    let navigationController: UINavigationController
    private let networking: NetworkManager
    
    // MARK: - Init and deinit
    deinit {
        self.navigationController.viewControllers = []
        print(F.toString(Self.self))
    }
    
    init(navigationController: UINavigationController,
         networking: NetworkManager,
         eventHandler: ((AppEvent) -> Void)?) {
        self.networking = networking
        self.eventHandler = eventHandler
        self.navigationController = navigationController
        self.navigationController.navigationBar.isHidden = true
    }
    
    // MARK: - Coordinator
    
    func start() {
        self.createAuthController()
    }
    
    // MARK: - Private methods
    
    private func createAuthController() {
        let controller = AuthorizationViewController(networking: self.networking,
                                                     event: self.authEvent)
        self.navigationController.viewControllers = [controller]
    }
    
    private func authEvent(_ event: AuthEvent) {
        switch event {
        case .login:
            self.eventHandler?(.mainFlow)
        case .error(let errorMessage):
            self.eventHandler?(.appError(errorMessage))
        }
    }
}
