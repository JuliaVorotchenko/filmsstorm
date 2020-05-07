//
//  RegistrationPresenter.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 07.05.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

enum RegistrationEvent: EventProtocol {
    case back
    case error(AppError)
}

protocol RegistrationPresenter: Presenter {
    var showActivity: Handler<ActivityState>? { get set }
    func onBack()
}

class RegistrationPresenterImpl: RegistrationPresenter {
    
    // MARK: - Private properties
     
     private let networking: NetworkManager
     let eventHandler: Handler<RegistrationEvent>?
     var showActivity: Handler<ActivityState>?
    
     // MARK: - Init and deinit
    
    init(networking: NetworkManager, event: Handler<RegistrationEvent>?) {
        self.networking = networking
        self.eventHandler = event
    }
    
    // MARK: - Public Methods
    
    func onBack() {
        self.eventHandler?(.back)
    }
}
