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
    let navigationController: UINavigationController = .init()
    private let networking: NetworkManager
    
    // MARK: - Init and deinit
    deinit {
       F.Log(F.toString(Self.self))
    }
    
    init(networking: NetworkManager,
         eventHandler: ((AppEvent) -> Void)?) {
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
        let presentater = AuthorizationPresenterImpl(networking: self.networking, event: self.authEvent(_:))
        let controller = AuthorizationViewController(presentater)
        self.navigationController.viewControllers = [controller]
    }
    
    private func authEvent(_ event: AuthEvent) {
        switch event {
        case .login:
            self.onLogin()
        case .error(let errorMessage):
            self.eventHandler?(.appError(errorMessage))
        case .signUp:
            self.createRegistrationViewController()
        }
    }
    
    private func onLogin() {
        self.navigationController.viewControllers.removeAll()
        self.eventHandler?(.mainFlow)
    }
    
    // MARK: - Registration VC
    
    private func createRegistrationViewController() {
        let presenter = RegistrationPresenterImpl(networking: self.networking, event: self.registrationEvent)
        let controller = RegistrationViewController(presenter)
        self.navigationController.pushViewController(controller, animated: true)
    }
    
    private func registrationEvent(_ event: RegistrationEvent) {
        switch event {
        case .back:
            self.createAuthController()
        case .error(let errorMessage):
             self.eventHandler?(.appError(errorMessage))
        }
    }
}
