//
//  DiscoverFlowCoordinator.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 06.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation
import UIKit

class ProfileFlowCoordinator: Coordinator {
    
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
        self.navigationController.navigationBar.isHidden = true
    }
    
    // MARK: - Coordinator
    func start() {
        self.createProfileViewController()
    }
    
    private func createProfileViewController() {
        let controller = ProfileViewController(networking: self.networking, event: self.profileEvent)
        self.navigationController.viewControllers = [controller]
    }
        
    private func profileEvent(_ event: ProfileEvent) {
        switch event {
        case .logout:
            self.eventHandler?(.authorizationFlow)
        case .close:
            self.eventHandler?(.mainFlow)
        case .error(let errorMessage):
            self.eventHandler?(.appError(errorMessage))
        }
    }
    
}
