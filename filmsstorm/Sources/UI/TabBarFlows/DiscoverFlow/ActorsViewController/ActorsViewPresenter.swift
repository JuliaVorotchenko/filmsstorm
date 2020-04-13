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
    case error(AppError)
}

protocol ActorViewPresenter: Presenter {
    var actorModel: ActorModel { get }
    func getActorDetails(_ completion: ((ActorDetailsModel) -> Void)?)
     func getActorCredits(_ completion: ((ActorCombinedCreditsModel) -> Void)?)
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
    
    func getActorDetails(_ completion: ((ActorDetailsModel) -> Void)?) {
      
        self.networking.getPersonDetails(with: self.actorModel) { [weak self] result in
            switch result {
            case .success(let model):
                completion?(model)
            case .failure(let error):
                self?.eventHandler?(.error(.networkingError(error)))
            }
        }
    }
    
    func getActorCredits(_ completion: ((ActorCombinedCreditsModel) -> Void)?) {
        
        self.networking.getPersonCredit(with: self.actorModel) { [weak self] result in
            switch result {
            case .success(let model):
                completion?(model)
            case .failure(let error):
                self?.eventHandler?(.error(.networkingError(error)))
            }
        }
        
    }
   
    func onBack() {
        self.eventHandler?(.back)
    }
}
