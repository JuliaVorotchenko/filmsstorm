//
//  AppConfigurator.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 29.12.2019.
//  Copyright © 2019 Alexander Andriushchenko. All rights reserved.
//

import UIKit
import KeychainSwift

enum AppEvent {
    case mainFlow
    case authorizationFlow
    case appError(AppError)
}

final class AppConfigurator {

    // MARK: - Private properties

    private let window: UIWindow
    private let networking = NetworkManager()
    private let loginNavigation = UINavigationController()
    private var tabBarContainer: TabBarContainer?
    private var keyChain = KeychainSwift()
    
    // MARK: - Init
    
    init(window: UIWindow) {
        self.window = window
        self.configure()
    }
    
    // MARK: - Private methods
    
    private func configure() {
//
//        if UserDefaultsContainer.session.isEmpty {
//            self.createLoginCoordinator()
//        } else {
//            self.createTabBarCoordinator()
//        }
//
//        self.window.makeKeyAndVisible()
       // self.keyChain.set(false, forKey: AppKeys.isLoggedIn, withAccess: .accessibleWhenUnlocked)
        guard let loggedIn = self.keyChain.getBool(AppKeyChain.isLoggedIn) else { fatalError("Ololo")}
        if loggedIn {
            self.createTabBarCoordinator()
        } else {
            self.createLoginCoordinator()
        }
        
        self.window.makeKeyAndVisible()
        
        
    }
    
    private func createLoginCoordinator() {
        self.tabBarContainer = nil
        let coordinator = LoginFlowCoordinator(navigationController: self.loginNavigation,
                                               networking: self.networking,
                                               eventHandler: self.appEvent)
        
        self.window.rootViewController = coordinator.navigationController
        coordinator.start()
    }
    
    private func createTabBarCoordinator() {
        self.loginNavigation.viewControllers = []
        let container = TabBarContainer(networking: self.networking,
                                        eventHandler: self.appEvent)
        self.tabBarContainer = container
        self.window.rootViewController = container.tabBarController
    }
    
    private func appEvent(_ event: AppEvent) {
        switch event {
        case .mainFlow:
            self.createTabBarCoordinator()
        case .authorizationFlow:
            self.createLoginCoordinator()
        case .appError(let error):
            self.handleAppError(error)
        }
    }

    private func handleAppError(_ event: AppError) {
        switch event {
        case .networkingError(let error):
            self.showAlert(with: error)
        case .unowned(let error):
            self.window.rootViewController?.showAlert(title: TextConstants.appError,
                                                      message: error.debugDescription)
        }
    }

    private func networkError(_ error: NetworkError) {
        switch error {
        case .networkingResponse(let nError):
            if case .authenticationError = nError {
                self.appEvent(.authorizationFlow)
            }
            self.showAlert(with: error)
        default:
            self.showAlert(with: error)
        }
    }

    private func showAlert(with error: NetworkError) {
        self.window.rootViewController?.showAlert(title: TextConstants.serverError,
                                                  message: error.stringDescription)
    }
}
