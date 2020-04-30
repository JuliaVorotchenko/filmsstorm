//
//  FavouritesPresenter.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 25.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

enum FavouritesEvent: EventProtocol {
    case onMedia(DiscoverCellModel)
    case onList([DiscoverCellModel])
    case error(AppError)
}

protocol FavouritesPresenter: Presenter {
    var showActivity: Handler<ActivityState>? { get set }
    func onMedia(item: DiscoverCellModel)
    func onList(models: [DiscoverCellModel])
    
    func getMoviesWatchlist(_ completion: (([DiscoverCellModel]) -> Void)?)
    func getShowsWatchList(_ completion: (([DiscoverCellModel]) -> Void)?)
    func getFavoriteMovies(_ completion: (([DiscoverCellModel]) -> Void)?)
    func getFavoriteShows(_ completion: (([DiscoverCellModel]) -> Void)?)
}

class FavouritesPresenterImpl: FavouritesPresenter {
    
    // MARK: - Private Properties
    
    let eventHandler: Handler<FavouritesEvent>?
    var showActivity: Handler<ActivityState>?
    private let networking: NetworkManager
    
    // MARK: - Init and deinit
    
    init(networking: NetworkManager, event: Handler<FavouritesEvent>?) {
        self.networking = networking
        self.eventHandler = event
    }
    
    // MARK: - Network Requests
    
    func getMoviesWatchlist(_ completion: (([DiscoverCellModel]) -> Void)?) {
        self.networking.getWathchListMovies { [weak self] result in
            switch result {
            case .success(let watchlist):
                completion?(watchlist.results.map(DiscoverCellModel.create))
            case .failure(let error):
                self?.eventHandler?(.error(.networkingError(error)))
            }
        }
    }
    
    func getShowsWatchList(_ completion: (([DiscoverCellModel]) -> Void)?) {
        self.networking.getWatchListShows { [weak self] result in
            switch result {
            case .success(let watchlist):
                completion?(watchlist.results.map(DiscoverCellModel.create))
            case .failure(let error):
                self?.eventHandler?(.error(.networkingError(error)))
            }
        }
    }
    
    func getFavoriteMovies(_ completion: (([DiscoverCellModel]) -> Void)?) {
        self.networking.getFavoriteMovies { [weak self] result in
            switch result {
            case .success(let favorites):
                completion?(favorites.results.map(DiscoverCellModel.create))
            case .failure(let error):
                self?.eventHandler?(.error(.networkingError(error)))
            }
        }
    }
    
    func getFavoriteShows(_ completion: (([DiscoverCellModel]) -> Void)?) {
        self.networking.getFavoriteShows { [weak self] result in
            switch result {
            case .success(let favorites):
                completion?(favorites.results.map(DiscoverCellModel.create))
            case .failure(let error):
                self?.eventHandler?(.error(.networkingError(error)))
            }
        }
    }
    
    // MARK: - Action Methods
    
    func onMedia(item: DiscoverCellModel) {
        self.eventHandler?(.onMedia(item))
    }
    
    func onList(models: [DiscoverCellModel]) {
        self.eventHandler?(.onList(models))
    }
}
