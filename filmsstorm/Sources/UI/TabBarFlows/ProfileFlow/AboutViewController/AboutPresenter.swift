//
//  AboutPresentationService.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 23.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//
import Foundation

enum AboutEvent: EventProtocol {
    case profile
}

protocol AboutPresenter: Presenter {
    var showActivity: ((ActivityState) -> Void)? { get set }
    func onBackEvent()
}

class AboutPresenterImpl: AboutPresenter {
    
    // MARK: - Private properties
    
    internal  var showActivity: ((ActivityState) -> Void)?
    internal let eventHandler: ((AboutEvent) -> Void)?
    
    // MARK: - Init and deinit
    init(event: ((AboutEvent) -> Void)?) {
        self.eventHandler = event
    }
    
    // MARK: - Methods
    func onBackEvent() {
        self.eventHandler?(.profile)
    }
}
