//
//  AppConfigurator.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 29.12.2019.
//  Copyright © 2019 Alexander Andriushchenko. All rights reserved.
//

import UIKit

final class AppConfigurator {
    
   // private var coordinator: Coordinator?
    
    init(window: UIWindow) {
        self.configure(window: window)
    }
    
    private func configure(window: UIWindow) {
        let navigationController = UINavigationController()
        let rootVC = AuthorizationViewController()
        window.rootViewController = navigationController
        navigationController.navigationBar.isHidden = true
        //self.coordinator = AppCoordinator(navigationController: navigationController)
        //self.coordinator?.start()
        navigationController.pushViewController(rootVC, animated: true)
        window.makeKeyAndVisible()
    }
}
