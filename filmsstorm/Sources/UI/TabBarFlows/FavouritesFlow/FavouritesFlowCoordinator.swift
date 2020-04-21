//
//  FavouritesFlowCoordinator.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 24.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation
import UIKit

class FavouritesFlowCoordinator: Coordinator {
    
    // MARK: - Properties
    
    var childCoordinators = [Coordinator]()
    let eventHandler: Handler<AppEvent>?
    let navigationController: UINavigationController
    private let networking: NetworkManager
    
    // MARK: - Init and deinit
    
    deinit {
        F.Log(F.toString(Self.self))
    }
    
    init(networking: NetworkManager,
         navigationController: UINavigationController,
         eventHandler: Handler<AppEvent>?) {
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
        let presenter = FavouritesPresenterImpl(networking: self.networking, event: self.favouritesEvent)
        let controller = FavouritesViewController(presenter)
        self.navigationController.pushViewController(controller, animated: true)
    }
    
    // MARK: - Favourites Screen Events
    
    private func favouritesEvent(_ event: FavouritesEvent) {
        switch event {
        case .onMedia(let model):
            self.createMediaItemViewController(from: model)
        case .error(let error):
            self.eventHandler?(.appError(error))
        }
    }
    
    // MARK: - Media Item VC
       
       private func createMediaItemViewController(from model: ConfigureModel) {
           let presenter = MediaItemPresenterImpl(networking: self.networking,
                                                  event: self.mediaItemEvent,
                                                  itemModel: model)
           let controller = MediaItemViewController(presenter)
           self.navigationController.pushViewController(controller, animated: true)
       }
       
       private func mediaItemEvent( _ event: MediaItemEvent) {
           switch event {
           case .back:
               self.navigationController.popViewController(animated: true)
           case .error(let errorMessage):
               self.eventHandler?(.appError(errorMessage))
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
        let presenter = VideoPlayerViewPresenterImpl(networking: self.networking, event: self.videoPlayerEvent, item: model)
        let controller = VideoPlayerViewController(presenter)
        self.navigationController.pushViewController(controller, animated: true)
    }
    
    private func videoPlayerEvent(_ event: VideoEvent) {
        switch event {
        case .back:
            self.navigationController.popViewController(animated: true)
        case .error(let errorMessage):
            self.eventHandler?(.appError(errorMessage))
        }
    }
    
    // MARK: - Actor VC
    
    private func createActorViewController(from model: ActorModel) {
        let presenter = ActorViewPresenterImpl(networking: self.networking, event: self.actorEvent, actorModel: model)
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
              self.eventHandler?(.appError(errorMessage))
        }
    }
}
