//
//  MoviesWatclistPresenter.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 01.05.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

enum MoviesWatchlistEvent: EventProtocol {
    case media(ConfigureModel)
    case back
    case error(AppError)
}

class MoviesWatchlistPresenterImpl: ListsPresenter {
    
    // MARK: - Private Properties
    
    let eventHandler: Handler<MoviesWatchlistEvent>
    private let networking: FavoritesNetworkManager
    var title = Constants.moviesWachlist
    private let coreDataManager = CoreDataManager.shared
    
    // MARK: - Init and deinit
    
    init(networking: FavoritesNetworkManager, event: @escaping Handler<MoviesWatchlistEvent>) {
        self.networking = networking
        self.eventHandler = event
    }
    
     // MARK: - Networking dependency methods
    
    func getItems(_ completion: (([DiscoverCellModel]) -> Void)?) {
        self.coreDataManager.getMoviesWatchlist { movies in
            completion?(movies.map { DiscoverCellModel.create($0!, mediaType: .movie) })
        }
    }
    
    // MARK: - Action Methods
    
    func onMedia(item: DiscoverCellModel) {
        self.eventHandler(.media(item))
    }
    
    func back() {
        self.eventHandler(.back)
    }
}
