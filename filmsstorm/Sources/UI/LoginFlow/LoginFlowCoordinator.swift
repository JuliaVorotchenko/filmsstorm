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
    let eventHandler: (AppEvent) -> Void
    let navigationController = UINavigationController()
    private let networking: NetworkManager
    
    // MARK: - Init and deinit
    deinit {
       F.Log(F.toString(Self.self))
    }
    
    init(networking: NetworkManager,
         eventHandler: @escaping (AppEvent) -> Void) {
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
        let presentater = AuthorizationPresenterImpl(networking: self.networking, event: {[weak self] in self?.authEvent($0) })
        let controller = AuthorizationViewController(presentater)
        self.navigationController.viewControllers = [controller]
    }
    
    private func authEvent(_ event: AuthEvent) {
        switch event {
        case .login:
            self.onLogin()
        case .error(let errorMessage):
            self.eventHandler(.appError(errorMessage))
        }
    }
    
    private func onLogin() {
        self.navigationController.viewControllers.removeAll()
        self.eventHandler(.mainFlow)
    }
}
