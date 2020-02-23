//
//  AboutPresentationService.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 23.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

enum AboutEvent: EventProtocol {
    case profile
}

protocol AboutPresentationService: PresentationService {
     var showActivity: ((ActivityState) -> Void)? { get set }
    func onBackEvent()
}

class AboutPresentationServiceImpl: AboutPresentationService {
    
    // MARK: - Private properties

    var showActivity: ((ActivityState) -> Void)?
     let eventHandler: ((AboutEvent) -> Void)?
    
    // MARK: - Init and deinit
    init(event: ((AboutEvent) -> Void)?) {
          self.eventHandler = event
    }
    
// MARK: - Methods
    func onBackEvent() {
           self.eventHandler?(.profile)
       }
       
}
