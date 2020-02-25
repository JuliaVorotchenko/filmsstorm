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
        let presentation = DiscoverPresenterImpl(networking: self.networking, event: self.discoverEvent(_:), headerEvent: self.discoverHeaderEvents(_:))
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
    
    // MARK: - Discover Header Events
    
    private func createMoviesViewController() {
        let presenter = MoviesPresenterImpl(networking: self.networking, event: self.moviesEvent(_:))
        let controller = MoviesViewController(presenter)
        self.navigationController.pushViewController(controller, animated: true)
    }
    
    private func createShowsViewController() {
        let presenter = ShowPresenterImpl(networking: self.networking, event: self.showsEvent(_:))
        let controller = ShowsViewController(presenter)
        self.navigationController.pushViewController(controller, animated: true)
    }
    
    private func createSearchViewController() {
        let presenter = SearchPresenterImpl(networking: self.networking, event: self.searchEvents(_:))
        let controller = SearchViewController(presenter)
        self.navigationController.pushViewController(controller, animated: true)
    }
    
    private func discoverHeaderEvents(_ event: DiscoverHeaderEvent) {
        switch event {
        case .onMovies:
            print("MoviesVC")
            self.createMoviesViewController()
        case .onShows:
            print("showsVC")
            self.createShowsViewController()
        case .onSearch:
            print("searchVC")
            self.createSearchViewController()
        }
    }
    
    // MARK: - Movies, Shows, Search Screen Events
    
    private func moviesEvent(_ event: MoviesEvent) {
        switch event {
        case .movie:
            print("media item view controller has to appear")
        case .error(let errorMessage):
            self.eventHandler?(.appError(errorMessage))
        }
    }
    
    private func showsEvent(_ event: ShowsEvent) {
        switch event {
        case .show:
            print("media item view controller has to appear")
        case .error(let errorMessage):
            self.eventHandler?(.appError(errorMessage))
        }
    }
    
    private func searchEvents(_ event: SearchEvent) {
        switch event {
        case .mediaItem:
            print("media item view controller has to appear")
        case .error(let errorMessage):
            self.eventHandler?(.appError(errorMessage))
        }
    }
}
