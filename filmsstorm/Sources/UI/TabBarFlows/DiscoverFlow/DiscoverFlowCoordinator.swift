//
//  MainCoordinator.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 30.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation
import UIKit

class DiscoverFlowCoordinator: Coordinator {

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
        self.navigationController.tabBarItem = .init(title: "Discover", image: UIImage(named: "discover"), selectedImage: nil)
    }
    
    // MARK: - Coordinator
    
    func start() {
        self.createDiscoverViewController()
    }
    
    private func createDiscoverViewController() {
        let presentation = DiscoverPresentationServiceImpl(networking: self.networking, event: self.discoverEvent(_:))
        let controller = DiscoverViewController(presentation)
        self.navigationController.viewControllers = [controller]
    }
    
    private func discoverEvent(_ event: DiscoverEvent) {
        switch event {
        case .logout:
            self.eventHandler?(.authorizationFlow)
        case .error(let errorMessage):
            self.eventHandler?(.appError(errorMessage))
        }
    }
}
