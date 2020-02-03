//
//  AppConfigurator.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 29.12.2019.
//  Copyright © 2019 Alexander Andriushchenko. All rights reserved.
//

import UIKit


enum AppConfiguratorEvent {
    case mainFlow
    case authorizationFlow
}

final class AppConfigurator {
    // MARK: - Private properties
    
    private var coordinator: Coordinator?
    private let navigationController = UINavigationController()
    
    // MARK: - Init
    
    init(window: UIWindow) {
        self.configure(window: window)
    }
    
    // MARK: - Private methods
    
    private func configure(window: UIWindow) {
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        navigationController.navigationBar.isHidden = true
        if UserDefaultsContainer.session.isEmpty {
            createLoginCoordinator()
        } else {
           createMainFlowCoordinator()
        }
        self.coordinator?.start()
        window.makeKeyAndVisible()
    }
    
    private func createLoginCoordinator() {
        let coordinator = LoginFlowCoordinator(navigationController: self.navigationController, eventHandler: appEvent(_:))
        self.coordinator?.addCoordinator(coordinator)
        coordinator.start()
    }
    
    private func createTabBarCoordinator() {
        let coordinator = TabBarCoordinator(navigationController: self.navigationController, eventHandler: appEvent(_:))
        coordinator.start()
    }
    
    private func createMainFlowCoordinator() {
        let coordinator = MainFlowCoordinator(navigationController: self.navigationController, eventHandler: appEvent(_:))
        coordinator.start()
    }
    
    private func appEvent(_ event: AppConfiguratorEvent) -> Void {
        switch event {
        case .mainFlow: createLoginCoordinator()
        case .authorizationFlow: createTabBarCoordinator()
        }
    }
}
