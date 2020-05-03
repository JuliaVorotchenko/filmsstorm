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
    
    let eventHandler: Handler<FavoriteMoviesEvent>?
    private let networking: NetworkManager
    var title = Constants.favoriteMovies
    
    // MARK: - Init and deinit
    
    init(networking: NetworkManager, event: Handler<FavoriteMoviesEvent>?) {
        self.networking = networking
        self.eventHandler = event
    }
    
     // MARK: - Networking dependency methods
    
    func getItems(_ completion: (([DiscoverCellModel]) -> Void)?) {
        self.networking.getFavoriteMovies { [weak self] result in
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
        self.eventHandler?(.media(item))
    }
    
    func back() {
        self.eventHandler?(.back)
    }
}
