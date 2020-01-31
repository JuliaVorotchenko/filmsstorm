//
//  MainCoordinator.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 30.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation
import UIKit

class MainFlowCoordinator: Coordinator {
   
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
         self.createSessionIDViewController()
     }
     private func createSessionIDViewController() {
            let controller = SessionIDViewController(networking: self.networking, event: self.sessionEvent)
            self.navigationController.viewControllers = [controller]
        }
        
        private func sessionEvent(_ event: SessionIDEvent) {
            switch event {
            case .back:
                self.navigationController.popViewController(animated: true)
            case .showSessionId:
                print("Session ID")
            case .error(let errorMessage):
                self.showAppErrorAlert(with: errorMessage)
            }
        }
    
}
