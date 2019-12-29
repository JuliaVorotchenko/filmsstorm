//
//  AppCoordinator.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 29.12.2019.
//  Copyright © 2019 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var authorizationViewController: AuthorizationViewController?
    var sessionIDViewController: SessionIDViewController?
    private let networking = Networking()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        self.createAuthController()
    }
    private func createAuthController() {
        let controller = AuthorizationViewController(networking: self.networking, event: self.authEvent)
        self.authorizationViewController = controller
        self.navigationController.viewControllers = [controller]
    }
    private func authEvent(_ event: AuthEvent) {
        switch event {
        case .login:
            self.createSessionIDViewController()
            self.authorizationViewController = nil
        case .error(let errorMessage):
            //self.showAlertError(with: errorMessage)
            print(errorMessage.debugDescription)
        }
    }
    
    private func createSessionIDViewController() {
        let controller = SessionIDViewController(networking: self.networking, event: self.sessionEvent)
        self.sessionIDViewController = controller
        self.navigationController.viewControllers = [controller]
    }
    private func sessionEvent(_ event: SessionIDEvent) {
        switch event {
        case .back:
            self.createAuthController()
            self.sessionIDViewController = nil
        case .showSessionId:
            print("Session ID")

        }
    }
}
