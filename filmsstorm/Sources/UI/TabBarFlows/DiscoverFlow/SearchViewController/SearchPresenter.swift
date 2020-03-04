//
//  SearchPresenter.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 24.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

enum SearchEvent: EventProtocol {
    case mediaItem(ConfigureModel)
    case back
    case error(AppError)
}

protocol SearchPresenter: Presenter {
    var showActivity: Handler<ActivityState>? { get set }
    func onMediaItem(item: ConfigureModel)
    func onBack()
}

class SearchPresenterImpl: SearchPresenter {
    
    // MARK: - Private Properties
    
    let eventHandler: Handler<SearchEvent>?
    var showActivity: Handler<ActivityState>?
    private let networking: NetworkManager
    
    // MARK: - Init and deinit
    
    init(networking: NetworkManager, event: ((SearchEvent) -> Void)?) {
        self.networking = networking
        self.eventHandler = event
    }
    
    // MARK: - Methods
    
    func onMediaItem(item: ConfigureModel) {
        self.eventHandler?(.mediaItem(item))
    }
    
    func onBack() {
        self.eventHandler?(.back)
    }
}
