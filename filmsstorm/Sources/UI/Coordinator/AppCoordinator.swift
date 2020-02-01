//
//  AppCoordinator.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 31.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

enum AppCoordinatorEvent {
    case login
    case main
}

class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    
    var childCoordinators = [Coordinator]()
    let navigationController: UINavigationController
    private let networking = NetworkManager()
    var tabBar: UITabBarController?
    
    // MARK: - Init and deinit
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator
    
    func start() {
        
        
        
        if UserDefaultsContainer.session.isEmpty {
            let coordinator = LoginFlowCoordinator(navigationController: self.navigationController, eventHandler: appEvent(_:))
            self.addCoordinator(coordinator)
            coordinator.start()
        } else {
            createTabBarCoordinator()
        }
    }
    
    private func createLoginCoordinator() {
        let coordinator = LoginFlowCoordinator(navigationController: self.navigationController, eventHandler: appEvent(_:))
        self.addCoordinator(coordinator)
        coordinator.start()
    }
    
    private func appEvent(_ event: AppCoordinatorEvent) -> Void {
        switch event {
        case .login: createLoginCoordinator()
        case .main: createTabBarCoordinator()
        }
    }
    
    private func createTabBarCoordinator() {
        let coordinator = TabBarCoordinator(navigationController: self.navigationController, eventHandler: appEvent(_:))
        self.addCoordinator(coordinator)
        coordinator.start()
    }
}

class TabBarCoordinator: Coordinator {
    
    var eventHandler: ((AppCoordinatorEvent) -> Void)?
    var childCoordinators = [Coordinator]()
    let navigationController: UINavigationController
    private let networking = NetworkManager()
    var tabBar: UITabBarController?
    
    // MARK: - Init and deinit
    
    init(navigationController: UINavigationController, eventHandler: ((AppCoordinatorEvent) -> Void)?) {
        self.navigationController = navigationController
        self.eventHandler = eventHandler
    }
    
    // MARK: - Coordinator
    
    func start() {
        self.createTabBar()
    }
    
    private func createTabBar() {
        let tabBar = UITabBarController()
        let mainNavigation = UINavigationController()
        let main = MainFlowCoordinator(navigationController: mainNavigation, eventHandler: self.eventHandler)
        self.addCoordinator(main)
        main.start()
        
        let firstNavigation =  UINavigationController()
        let first = TabBarFirstCoordinator(navigationController: firstNavigation)
        self.addCoordinator(first)
        first.start()
        
        let controllers = self.childCoordinators.compactMap { $0.navigationController }
        tabBar.setViewControllers(controllers, animated: true)
        self.navigationController.setViewControllers([tabBar], animated: true)
        self.tabBar = tabBar
    }
}

