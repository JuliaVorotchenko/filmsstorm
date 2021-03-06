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
    let eventHandler: (AppEvent) -> Void
    let navigationController: UINavigationController
    private let networking: NetworkManager
    
    // MARK: - Init and deinit
    
    deinit {
        F.Log(F.toString(Self.self))
    }
    
    init(networking: NetworkManager,
         navigationController: UINavigationController,
         eventHandler: @escaping (AppEvent) -> Void) {
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
        let presenter = DiscoverPresenterImpl(networking: self.networking, event: { [weak self] in self?.discoverEvent($0) })
        let controller = DiscoverViewController(presenter)
        self.navigationController.viewControllers = [controller]
    }
    
    private func discoverEvent(_ event: DiscoverEvent) {
        switch event {
        case .error(let errorMessage):
            self.eventHandler(.appError(errorMessage))
        case .onMediaItem(let model):
            self.createMediaItemViewController(from: model)
        case .onHeaderEvent(let event):
            self.discoverHeaderEvents(event)
        }
    }
    
    private func discoverHeaderEvents(_ event: DiscoverHeaderEvent) {
        switch event {
        case .onMovies:
            self.createMoviesViewController()
        case .onShows:
            self.createShowsViewController()
        case .onSearch:
            self.createSearchViewController()
        }
    }
    
    // MARK: - Movies VC
    
    private func createMoviesViewController() {
        let presenter = MoviesPresenterImpl(networking: self.networking, event: { [weak self] in self?.moviesEvent($0) })
        let controller = ItemsViewController(presenter)
        self.navigationController.pushViewController(controller, animated: true)
    }
    
    private func moviesEvent(_ event: MoviesEvent) {
        switch event {
        case .movie(let model):
            self.createMediaItemViewController(from: model)
        case .error(let errorMessage):
            self.eventHandler(.appError(errorMessage))
        case .back:
            self.createDiscoverViewController()
        }
    }
    
    // MARK: - Shows VC
    
    private func createShowsViewController() {
        let presenter = ShowPresenterImpl(networking: self.networking, event: { [weak self] in self?.showsEvent($0) })
        let controller = ItemsViewController(presenter)
        self.navigationController.pushViewController(controller, animated: true)
    }
    
    private func showsEvent(_ event: ShowsEvent) {
        switch event {
        case .mediaItem(let model):
            self.createMediaItemViewController(from: model)
        case .back:
            self.createDiscoverViewController()
        case .error(let errorMessage):
            self.eventHandler(.appError(errorMessage))
        }
    }
    
    // MARK: - Search VC
    
    private func createSearchViewController() {
        let presenter = SearchPresenterImpl(networking: self.networking, event: { [weak self] in self?.searchEvents($0) })
        let controller = SearchViewController(presenter)
        self.navigationController.pushViewController(controller, animated: true)
    }
    
    private func searchEvents(_ event: SearchEvent) {
        switch event {
        case .mediaItem(let model):
            self.createMediaItemViewController(from: model)
        case .back:
            self.navigationController.popViewController(animated: true)
        case .error(let errorMessage):
            self.eventHandler(.appError(errorMessage))
        }
    }
    
    // MARK: - Media Item VC
    
    private func createMediaItemViewController(from model: ConfigureModel) {
        let presenter = MediaItemPresenterImpl(networking: self.networking,
                                               event: { [weak self] in self?.mediaItemEvent($0) },
                                               itemModel: model)
        let controller = MediaItemViewController(presenter)
        self.navigationController.pushViewController(controller, animated: true)
    }
    
    private func mediaItemEvent( _ event: MediaItemEvent) {
        switch event {
        case .back:
            self.navigationController.popViewController(animated: true)
        case .error(let errorMessage):
            self.eventHandler(.appError(errorMessage))
        case .onMediaItem(let model):
            self.createMediaItemViewController(from: model)
        case .onPlay(let model):
            self.createVideoPlayerViewController(from: model)
        case .onActor(let model):
            self.createActorViewController(from: model)
        }
    }
    
    // MARK: - Video Player VC
    
    private func createVideoPlayerViewController(from model: MediaItemModel) {
        let presenter = VideoPlayerViewPresenterImpl(networking: self.networking, event: { [weak self] in self?.videoPlayerEvent($0) }, item: model)
        let controller = VideoPlayerViewController(presenter)
        self.navigationController.pushViewController(controller, animated: true)
    }
    
    private func videoPlayerEvent(_ event: VideoEvent) {
        switch event {
        case .back:
            self.navigationController.popViewController(animated: true)
        case .error(let errorMessage):
            self.eventHandler(.appError(errorMessage))
        }
    }
    
    // MARK: - Actor VC
    
    private func createActorViewController(from model: ActorModel) {
        let presenter = ActorViewPresenterImpl(networking: self.networking, event: { [weak self] in self?.actorEvent($0) }, actorModel: model)
        let controller = ActorViewController(presenter)
        self.navigationController.pushViewController(controller, animated: true)
    }
    
    private func actorEvent(_ event: ActorViewEvent) {
        switch event {
        case .onMediaItem(let model):
            self.createMediaItemViewController(from: model)
        case .back:
            self.navigationController.popViewController(animated: true)
        case .error(let errorMessage):
            self.eventHandler(.appError(errorMessage))
        }
    }

}
