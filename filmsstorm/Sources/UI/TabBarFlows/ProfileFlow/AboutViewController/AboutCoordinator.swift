//
//  AboutFlowCoordinator.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 09.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation
import UIKit

class AboutCoordinator: Coordinator {
    
    // MARK: - Properties
       
       var childCoordinators = [Coordinator]()
       let eventHandler: ((AppEvent) -> Void)?
       let navigationController: UINavigationController
       private let networking: NetworkManager
    
    // MARK: - Init and deinit
       
       deinit {
           print(Self.self)
       }
    
    init(networking: NetworkManager,
            navigationController: UINavigationController,
            eventHandler: ((AppEvent) -> Void)?) {
           self.networking = networking
           self.eventHandler = eventHandler
           self.navigationController = navigationController
           self.navigationController.navigationBar.isHidden = false
       }
    
     // MARK: - Coordinator
    
    func start() {
        self.createAboutViewController()
    }
    
    private func createAboutViewController() {
        let controller = AboutViewController(networking: self.networking)
        self.navigationController.viewControllers = [controller]
    }
        
}

