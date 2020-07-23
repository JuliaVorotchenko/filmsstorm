//
//  FavoriteMoviesPresenter.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 01.05.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

enum FavoriteMoviesEvent: EventProtocol {
    case media(ConfigureModel)
    case back
    case error(AppError)
}

protocol ListsPresenter: Presenter {
    var title: String { get }
    func getItems(_ completion: Handler<[DiscoverCellModel]>?)
    func onMedia(item: DiscoverCellModel)
    func back()
}

class FavoriteMoviesPresenterImpl: ListsPresenter {
    
    // MARK: - Private Properties
    
    let eventHandler: Handler<FavoriteMoviesEvent>
    private let networking: FavoritesNetworkManager
    var title = Constants.favoriteMovies
    private let coreDataManager = CoreDataManager.shared
    
    // MARK: - Init and deinit
    
    init(networking: FavoritesNetworkManager, event: @escaping Handler<FavoriteMoviesEvent>) {
        self.networking = networking
        self.eventHandler = event
    }
    
     // MARK: - Networking dependency methods
    
    func getItems(_ completion: (([DiscoverCellModel]) -> Void)?) {
        self.coreDataManager.getFavoriteMovies { movies in
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
