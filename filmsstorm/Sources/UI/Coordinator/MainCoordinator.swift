//
//  MainCoordinator.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 30.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
   
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
         self.createAuthController()
     }
     
    
}
