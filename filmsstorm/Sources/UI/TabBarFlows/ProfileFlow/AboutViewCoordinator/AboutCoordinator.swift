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
    var eventHandler: ((AppEvent) -> Void)?
    
    
    // MARK: - Properties
       
       var childCoordinators = [Coordinator]()
       let eventProfile: ((ProfileEvent) -> Void)?
       let navigationController: UINavigationController
       private let networking: NetworkManager
    
    // MARK: - Init and deinit
       
       deinit {
           print(Self.self)
       }
    
    init(networking: NetworkManager,
            navigationController: UINavigationController,
            eventProfile: ((ProfileEvent) -> Void)?) {
           self.networking = networking
           self.eventProfile = eventProfile
           self.navigationController = navigationController
       }
    
     // MARK: - Coordinator
    
    func start() {
        self.createAboutViewController()
    }
    
    private func createAboutViewController() {
        let controller = AboutViewController(networking: self.networking, event: self.eventProfile)
        self.navigationController.present(controller, animated: true, completion: nil)
    }
}
