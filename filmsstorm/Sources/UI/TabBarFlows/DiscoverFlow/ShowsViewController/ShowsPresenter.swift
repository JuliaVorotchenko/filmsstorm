//
//  ShowsPresenter.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 24.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

enum ShowsEvent: EventProtocol {
    case show
    case error(AppError)
}

protocol ShowsPresenter: Presenter {
    var showActivity: ((ActivityState) -> Void)? { get set }
    func getPopularShows(_ completion: (( [ShowListResult]) -> Void)?)
    func onShow()
}

class ShowPresenterImpl: ShowsPresenter {
    
    // MARK: - Private Properties
    
    internal let eventHandler: ((ShowsEvent) -> Void)?
    internal var showActivity: ((ActivityState) -> Void)?
    private let networking: NetworkManager
    var view = ShowsView()
    
    // MARK: - Init and deinit
    
    init(networking: NetworkManager, event: ((ShowsEvent) -> Void)?) {
        self.networking = networking
        self.eventHandler = event
    }
    
    // MARK: - Methods
    
    func getPopularShows(_ completion: (( [ShowListResult]) -> Void)?) {
        self.networking.getPopularShows { [weak self] result in
            switch result {
            case .success(let model):
                completion?(model.results)
                
            case .failure(let error):
                self?.eventHandler?(.error(.networkingError(error)))
            }
        }
    }
    
    func onShow() {
        self.eventHandler?(.show)
    }
}
