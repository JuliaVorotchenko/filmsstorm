//
//  AppCoordinator.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 31.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class TabBarContainer: AppEventSource {
    
    // MARK: - Properties
    
    var childCoordinators = [Coordinator]()
    let eventHandler: (AppEvent) -> Void?
    private(set) var tabBarController = UITabBarController()
    private let networking: NetworkManager
    
    // MARK: - Init and deinit
    deinit {
        F.Log(F.toString(Self.self))
    }
    
    init(networking: NetworkManager,
         eventHandler: @escaping (AppEvent) -> Void) {
        self.networking = networking
        self.eventHandler = eventHandler
        self.createTabBar()
    }
    
    private func createTabBar() {
        self.createDiscoverFlowCoordinator()
        self.createFavouritesFlowCoordinator()
        self.createProfileFlowCoordinator()
        let controllers = self.childCoordinators.compactMap { $0.navigationController }
        self.tabBarController.setViewControllers(controllers, animated: true)
        
        self.tabBarController.tabBar.isTranslucent = false
        self.tabBarController.tabBar.barTintColor = UIColor(named: .background)
        self.tabBarController.tabBar.tintColor = UIColor(named: .primary)
    }
    
    private func createDiscoverFlowCoordinator() {
        let mainFlowNav = UINavigationController()
        let coordinator = DiscoverFlowCoordinator(networking: self.networking,
                                                  navigationController: mainFlowNav,
                                                  eventHandler: { [weak self] in self?.eventHandler($0) })
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    private func createProfileFlowCoordinator() {
        let profileFlow = UINavigationController()
        let coordinator = ProfileFlowCoordinator(networking: self.networking, navigationController: profileFlow,
                                                 eventHandler: { [weak self] in self?.eventHandler($0) })
        
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    private func createFavouritesFlowCoordinator() {
        let favoritesFlow = UINavigationController()
        let coordinator = FavouritesFlowCoordinator(networking: self.networking, navigationController: favoritesFlow,
                                                    eventHandler: { [weak self] in self?.eventHandler($0) })
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
    
}
