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
    var showActivity: ((ActivityState) -> Void)? { get set }
    func onMediaItem()
    func onBack()
}

class SearchPresenterImpl: Presenter {
    
    // MARK: - Private Properties
    
    let eventHandler: ((SearchEvent) -> Void)?
    var showActivity: ((ActivityState) -> Void)?
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
