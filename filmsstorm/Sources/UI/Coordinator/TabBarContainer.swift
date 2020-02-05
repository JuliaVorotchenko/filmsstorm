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
    let eventHandler: ((AppEvent) -> Void)?
    private(set) var tabBarControllers = UITabBarController()
    private let mainFlowNav = UINavigationController()
    private let networking: NetworkManager
    
    // MARK: - Init and deinit
    deinit {
        self.mainFlowNav.viewControllers = []
        print(TabBarContainer.self)
    }

    init(networking: NetworkManager,
         eventHandler: ((AppEvent) -> Void)?) {
        self.networking = networking
        self.eventHandler = eventHandler
        self.createTabBar()
    }
    
    private func createTabBar() {
        self.createMainFlowCoordinator()

        let controllers = self.childCoordinators.compactMap { $0.navigationController }
        
        self.tabBarControllers.viewControllers = controllers
    }
    
    private func createMainFlowCoordinator() {
        
        let coordinator = DiscoverFlowCoordinator(networking: self.networking, navigationController: mainFlowNav,
                                              eventHandler: self.eventHandler)
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
}
