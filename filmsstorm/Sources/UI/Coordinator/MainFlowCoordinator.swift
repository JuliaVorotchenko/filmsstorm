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
    let eventHandler: ((AppEvent) -> Void)?
    let navigationController: UINavigationController
    private let networking: NetworkManager
    
    // MARK: - Init and deinit

    deinit {
        print(Self.self)
    }

    init(networking: NetworkManager,
         eventHandler: ((AppEvent) -> Void)?) {
        self.networking = networking
        self.eventHandler = eventHandler
        self.navigationController = UINavigationController()
        self.navigationController.navigationBar.isHidden = true
    }
    
    // MARK: - Coordinator
    
    func start() {
        self.createSessionIDViewController()
    }
    private func createSessionIDViewController() {
        let controller = DiscoverViewController(networking: self.networking, event: self.sessionEvent)
        self.navigationController.viewControllers = [controller]
    }
    
    private func sessionEvent(_ event: DiscoverEvent) {
        switch event {
        case .logout:
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
