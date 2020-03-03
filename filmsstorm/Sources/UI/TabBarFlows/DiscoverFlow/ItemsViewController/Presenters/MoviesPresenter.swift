//
//  MoviesViewPresenter.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 24.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

enum MoviesEvent: EventProtocol {
    case movie(ConfigureModel)
    case error(AppError)
    case back
}

protocol ItemsPresenter: Presenter {
    var showActivity: ((ActivityState) -> Void)? { get set }
    func getItems(_ completion: Handler<[DiscoverCellModel]>?)
    func onMedia(item: ConfigureModel)
    func onBack()
}

class MoviesPresenterImpl: ItemsPresenter {
    
    // MARK: - Private Properties
    
    internal let eventHandler: ((MoviesEvent) -> Void)?
    internal var showActivity: ((ActivityState) -> Void)?
    private let networking: NetworkManager
    
    // MARK: - Init and deinit
    
    init(networking: NetworkManager, event: ((MoviesEvent) -> Void)?) {
        self.networking = networking
        self.eventHandler = event
    }
    
    // MARK: - Methods
    
    func getItems(_ completion: Handler<[DiscoverCellModel]>?) {
        self.networking.getPopularMovies { [weak self] result in
            switch result {
            case .success(let model):
                completion?(model.results.map(DiscoverCellModel.create))
            case .failure(let error):
                self?.eventHandler?(.error(.networkingError(error)))
            }
        }
    }
    
    func onMedia(item: ConfigureModel) {
        self.eventHandler?(.movie(item))
    }
    
    func onBack() {
        self.eventHandler?(.back)
    }
}
