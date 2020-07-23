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
    case onHeaderEvent(FavoritesHeaderEvent)
    case error(AppError)
}

enum FavoritesHeaderEvent: EventProtocol {
    case favoriteMovies
    case favoriteShows
    case moviesWatchList
    case showsWatchlist
}

protocol FavouritesPresenter: Presenter {
    
    func onMedia(item: DiscoverCellModel)
    func onFavoriteMovies()
    func onFavoriteShows()
    func onMoviesWatchList()
    func onShowsWatchlist()
    
    func getMoviesWatchlist(_ completion: (([DiscoverCellModel]) -> Void)?)
    func getShowsWatchList(_ completion: (([DiscoverCellModel]) -> Void)?)
    func getFavoriteMovies(_ completion: (([DiscoverCellModel]) -> Void)?)
    func getFavoriteShows(_ completion: (([DiscoverCellModel]) -> Void)?)
}

class FavouritesPresenterImpl: FavouritesPresenter {
    
    // MARK: - Private Properties
    
    let eventHandler: Handler<FavouritesEvent>
    private let networking: FavoritesNetworkManager
    private let coreDataManager = CoreDataManager.shared
    
    // MARK: - Init and deinit
    
    init(networking: FavoritesNetworkManager, event: @escaping Handler<FavouritesEvent>) {
        self.networking = networking
        self.eventHandler = event
    }
    
    // MARK: - Network Requests
    
    func getMoviesWatchlist(_ completion: (([DiscoverCellModel]) -> Void)?) {
        self.coreDataManager.getMoviesWatchlist { movies in
            completion?(movies.map { DiscoverCellModel.create($0!, mediaType: .movie) })
        }
    }
    
    func getShowsWatchList(_ completion: (([DiscoverCellModel]) -> Void)?) {
        self.coreDataManager.getShowsWatchlist { shows in
            completion?(shows.map { DiscoverCellModel.create($0!, mediaType: .tv) })
        }
    }
    
    func getFavoriteMovies(_ completion: (([DiscoverCellModel]) -> Void)?) {
        self.coreDataManager.getFavoriteMovies { movies in
            completion?(movies.map { DiscoverCellModel.create($0!, mediaType: .movie) })
        }
    }
    
    func getFavoriteShows(_ completion: (([DiscoverCellModel]) -> Void)?) {
        self.coreDataManager.getFavoriteShows { movies in
            completion?(movies.map { DiscoverCellModel.create($0!, mediaType: .tv) })
        }
    }
    
    // MARK: - Action Methods
    
    func onMedia(item: DiscoverCellModel) {
        self.eventHandler(.onMedia(item))
    }
    
    func onFavoriteMovies() {
        self.eventHandler(.onHeaderEvent(.favoriteMovies))
    }
    
    func onFavoriteShows() {
        self.eventHandler(.onHeaderEvent(.favoriteShows))
    }
    
    func onMoviesWatchList() {
        self.eventHandler(.onHeaderEvent(.moviesWatchList))
    }
    
    func onShowsWatchlist() {
        self.eventHandler(.onHeaderEvent(.showsWatchlist))
    }
}
