//
//  FavouritesFlowCoordinator.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 24.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation
import UIKit

class FavoritesFlowCoordinator: Coordinator {
    
    // MARK: - Properties
    
    var childCoordinators = [Coordinator]()
    let eventHandler: ((AppEvent) -> Void)?
    let navigationController: UINavigationController
    private let networking: NetworkManager
    
    // MARK: - Init and deinit
    
    deinit {
        F.Log(F.toString(Self.self))
    }
    
    init(networking: NetworkManager,
         navigationController: UINavigationController,
         eventHandler: ((AppEvent) -> Void)?) {
        self.networking = networking
        self.eventHandler = eventHandler
        self.navigationController = navigationController
        self.navigationController.navigationBar.isHidden = true
        self.navigationController.tabBarItem = .init(title: "Favourites", image: UIImage(named: "favorite"), selectedImage: nil)
    }
    
    // MARK: - Coordinator
    
    func start() {
        self.createFavouritesViewController()
    }
    
    private func createFavouritesViewController() {
        let presenter = FavoritesPresenterImpl(networking: self.networking, event: self.favoritesEvent(_:))
        let controller = FavoritesViewController(presenter)
        self.navigationController.pushViewController(controller, animated: true)
    }
    
    // MARK: - Favourites Screen Events
    
    private func favoritesEvent(_ event: FavoritesEvent) {
        switch event {
        case .onMedia:
            F.Log("some fav event")
        case .onList:
            print("list")
        }
    }
}
