//
//  AppConfigurator.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 29.12.2019.
//  Copyright © 2019 Alexander Andriushchenko. All rights reserved.
//

import UIKit

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
        self.coordinator = AppCoordinator(navigationController: navigationController)
        self.coordinator?.start()
        window.makeKeyAndVisible()
    }
}
