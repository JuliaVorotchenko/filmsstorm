//
//  AppCoordinator.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 31.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    
    var childCoordinators = [Coordinator]()
    let navigationController: UINavigationController
    private let networking = NetworkManager()
    
    // MARK: - Init and deinit
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator
    
    func start() {
        if UserDefaultsContainer.session.isEmpty {
            self.addCoordinator(LoginFlowCoordinator(navigationController: navigationController))
            self.childCoordinators.first?.start()
        } else {
            self.addCoordinator(MainFlowCoordinator(navigationController: navigationController))
            self.childCoordinators.first?.start()
        }
    }
}

