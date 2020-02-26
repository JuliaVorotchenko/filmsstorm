//
//  SearchPresenter.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 24.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

enum SearchEvent: EventProtocol {
    case mediaItem
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
    
    internal let eventHandler: ((SearchEvent) -> Void)?
    internal var showActivity: ((ActivityState) -> Void)?
    private let networking: NetworkManager
    
    // MARK: - Init and deinit
    
    init(networking: NetworkManager, event: ((SearchEvent) -> Void)?) {
        self.networking = networking
        self.eventHandler = event
    }
    
    // MARK: - Methods
    
    func onMediaItem() {
        self.eventHandler?(.mediaItem)
    }
    
    func onBack() {
        self.eventHandler?(.back)
    }
}
