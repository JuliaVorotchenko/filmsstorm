//
//  ShowsWatchlistPresenter.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 01.05.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

enum ShowsWatchlistEvent: EventProtocol {
    case media(ConfigureModel)
    case back
    case error(AppError)
}

class ShowsWatchlistPresenterImpl: ListsPresenter {
    
    // MARK: - Private Properties
    
    let eventHandler: Handler<ShowsWatchlistEvent>
    private let networking: FavoritesNetworkManager
    var title = Constants.showsWatchlist
    
    // MARK: - Init and deinit
    
    init(networking: FavoritesNetworkManager, event: @escaping Handler<ShowsWatchlistEvent>) {
        self.networking = networking
        self.eventHandler = event
    }
    
    // MARK: - Networking dependency methods
    
    func getItems(_ completion: (([DiscoverCellModel]) -> Void)?) {
        self.networking.getWatchListShows { [weak self] result in
            switch result {
            case .success(let watchlist):
                completion?(watchlist.results.map(DiscoverCellModel.create))
            case .failure(let error):
                self?.eventHandler(.error(.networkingError(error)))
            }
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
