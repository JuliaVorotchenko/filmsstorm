//
//  FavoriteShowsPresenter.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 01.05.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

enum FavoriteShowsEvent: EventProtocol {
    case media(ConfigureModel)
    case back
    case error(AppError)
}

class FavoriteShowsPresenterImpl: ListsPresenter {
   
    // MARK: - Private Properties
    
    let eventHandler: Handler<FavoriteShowsEvent>
    private let networking: FavoritesNetworkManager
    var title = Constants.favoriteShows
    private let coreDataManager = CoreDataManager.shared
    
    // MARK: - Init and deinit
    
    init(networking: FavoritesNetworkManager, event: @escaping Handler<FavoriteShowsEvent>) {
        self.networking = networking
        self.eventHandler = event
    }
    
     // MARK: - Networking dependency methods
    
    func getItems(_ completion: (([DiscoverCellModel]) -> Void)?) {
        self.coreDataManager.getFavoriteShows { shows in
            completion?(shows.map { DiscoverCellModel.create($0!, mediaType: .tv) })
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
