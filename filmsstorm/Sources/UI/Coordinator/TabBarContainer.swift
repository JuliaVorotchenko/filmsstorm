//
//  AppCoordinator.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 31.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class TabBarContainer: AppEventSource {

    // MARK: - Properties

    var childCoordinators = [Coordinator]()
    let eventHandler: ((AppEvent) -> Void)?
    private(set) var tabBarController = UITabBarController()
    private let mainFlowNav = UINavigationController()
    private let networking: NetworkManager
    
    
    // MARK: - Init and deinit
    deinit {
        self.mainFlowNav.viewControllers = []
        print(TabBarContainer.self)
    }

    init(networking: NetworkManager,
         eventHandler: ((AppEvent) -> Void)?) {
        self.networking = networking
        self.eventHandler = eventHandler
        self.createTabBar()
    }
    
    private func createTabBar() {
        self.createMainFlowCoordinator()
        createPFCoordinator()
        let controllers = self.childCoordinators.compactMap { $0.navigationController }
        self.tabBarController.viewControllers = controllers
        //setTabBar()
    }
    
    private func createMainFlowCoordinator() {
        let coordinator = DiscoverFlowCoordinator(networking: self.networking, navigationController: self.mainFlowNav,
                                              eventHandler: self.eventHandler)
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    private func createPFCoordinator() {
        let coordinator = ProfileFlowCoordinator(networking: self.networking, navigationController: self.mainFlowNav,
                                                 eventHandler: self.eventHandler)
        
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    
    private func setTabBar() {

        let emptyVC = EmptyViewComntroller(image: nil, title: "Empty")
        


//        var profileTabBarItem = profileVC.tabBarItem
//        profileTabBarItem = UITabBarItem(title: "My Account", image: nil, tag: 1)

        
        var emptyTabBarItem = emptyVC.tabBarItem
        emptyTabBarItem = UITabBarItem(title: "Empty vc", image: nil, tag: 0)
        

        self.tabBarController.tabBar.setItems([emptyTabBarItem!], animated: true)
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
