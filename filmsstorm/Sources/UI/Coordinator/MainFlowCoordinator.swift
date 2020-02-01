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
    var eventHandler:  ((AppCoordinatorEvent) -> Void)?
    var childCoordinators = [Coordinator]()
    let navigationController: UINavigationController
    private let networking = NetworkManager()
    
    // MARK: - Init and deinit
    
    init(navigationController: UINavigationController, eventHandler: ((AppCoordinatorEvent) -> Void)?) {
        self.navigationController = navigationController
        self.eventHandler = eventHandler
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
            self.eventHandler?(.login)
        case .showSessionId:
            print("Session ID")
        case .error(let errorMessage):
            self.showAppErrorAlert(with: errorMessage)
        }
    }
    
}


class TabBarFirstCoordinator: Coordinator {
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
        self.createEmptyViewComntroller()
    }
    
    func createEmptyViewComntroller() {
        let controller = EmptyViewComntroller(image: UIImage(named: "tmdbLogo"), title: "First")
        self.navigationController.viewControllers = [controller]
        
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
