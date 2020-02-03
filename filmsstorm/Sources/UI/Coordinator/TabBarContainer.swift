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
    private(set) var tabBarController = UITabBarController()
    private let networking: NetworkManager
    
    // MARK: - Init and deinit

    init(networking: NetworkManager, eventHandler: ((AppEvent) -> Void)?) {
        self.networking = networking
        self.eventHandler = eventHandler
    }

    // MARK: - Coordinator
    
    func start() {
        self.createTabBar()
    }
    
    private func createTabBar() {
        self.createMainFlow()

        let controllers = self.childCoordinators.compactMap { $0.navigationController }
        self.tabBarController.setViewControllers(controllers, animated: true)
    }

    private func createMainFlow() {

        let mainNavigation = UINavigationController()
        mainNavigation.navigationBar.isHidden = true
        let main = MainFlowCoordinator(networking: self.networking,
                                       navigationController: mainNavigation,
                                       eventHandler: self.eventHandler)
        self.childCoordinators.append(main)
        main.start()
    }
}
