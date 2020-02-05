//
//  MainCoordinator.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 30.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class MainFlowCoordinator: Coordinator, AppEventSource {
    
    // MARK: - Properties
    var eventHandler: ((AppEvent) -> Void)?
    var childCoordinators = [Coordinator]()
    let navigationController: UINavigationController
    private var networking = NetworkManager()
    
    // MARK: - Init and deinit
    
    init(networking: NetworkManager, navigationController: UINavigationController, eventHandler: ((AppEvent) -> Void)?) {
        self.networking = networking
        self.navigationController = navigationController
        self.eventHandler = eventHandler
    }
    
    // MARK: - Coordinator
    
    func start() {
        self.createSessionIDViewController()
    }
    
    // MARK: - Private methods

    private func createSessionIDViewController() {
        let controller = MainViewController(networking: self.networking, event: self.sessionEvent)
        self.navigationController.viewControllers = [controller]
    }
    
    private func sessionEvent(_ event: DiscoverEvent) {
        switch event {
        case .back:
            self.eventHandler?(.authorizationFlow)
        case .error(let errorMessage):
            self.eventHandler?(.appError(errorMessage))
        }
    }
    
}

class EmptyViewComntroller: UIViewController {
    
    init(image: UIImage?, title: String) {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem = .init(title: title, image: image, selectedImage: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
