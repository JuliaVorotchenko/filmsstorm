//
//  ActorsViewPresenter.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 12.04.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

enum ActorViewEvent: EventProtocol {
    case back
    case onMediaItem(DiscoverCellModel)
}

protocol ActorViewPresenter: Presenter {
    var actorModel: ActorModel { get }
    func onBack() 
}

class ActorViewPresenterImpl: ActorViewPresenter {
    
  // MARK: - Properties
    
    let eventHandler: Handler<ActorViewEvent>?
    var showActivity: Handler<ActivityState>?
    let actorModel: ActorModel
    private let networking: NetworkManager
  
    // MARK: - Init and deinit
    
    init(networking: NetworkManager, event: Handler<ActorViewEvent>?, actorModel: ActorModel) {
        self.networking = networking
        self.eventHandler = event
        self.actorModel = actorModel
    }
    
    // MARK: - Private methods
    
   
    func onBack() {
        self.eventHandler?(.back)
    }
}
