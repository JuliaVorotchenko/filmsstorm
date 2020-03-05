//
//  DiscoverPresentationService.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 23.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

enum DiscoverEvent: EventProtocol {
    case error(AppError)
    case onHeaderEvent(DiscoverHeaderEvent)
    case onMediaItem(ConfigureModel)
    
}

protocol DiscoverPresenter: Presenter {
    var  showActivity: Handler<ActivityState>? { get set }
    func getPopularMovies(_ completion: (( [MovieListResult]) -> Void)?)
    func onMovies()
    func onShows()
    func onSearch()
    func onMedia(item: ConfigureModel)
    func addToFavourites(_ item: DiscoverCellModel?)
    func addToWatchList(_ item: DiscoverCellModel?)
}

class DiscoverPresenterImpl: DiscoverPresenter {
    
    // MARK: - Private Properties
    let eventHandler: Handler<DiscoverEvent>?
    var showActivity: Handler<ActivityState>?
    private let networking: NetworkManager
    
    // MARK: - Init and deinit
    
    init(networking: NetworkManager, event: Handler<DiscoverEvent>?) {
        self.networking = networking
        self.eventHandler = event
    }
    
    // MARK: - Methods
    
    func getPopularMovies(_ completion: (( [MovieListResult]) -> Void)?) {
        self.networking.getUpcomingMovies { [weak self] result in
            switch result {
            case .success(let model):
                completion?(model.results)
                
            case .failure(let error):
                self?.eventHandler?(.error(.networkingError(error)))
            }
        }
    }
    
    func addToFavourites(_ item: DiscoverCellModel?) {
        guard let item = item, let id = item.id else { return }
        let model = AddFavouritesRequestModel(mediaType: item.mediaType, mediaID: id, isFavourite: true)
        self.networking.addToFavourites(with: model) { result in
            switch result {
            case .success(let response):
                print(response.statusMessage)
            case .failure(let error):
                print(error.stringDescription)
                
            }
        }
    }
    
    func addToWatchList(_ item: DiscoverCellModel?) {
        guard let item = item, let id = item.id else { return }
        let model = AddWatchListRequestModel(mediaType: item.mediaType, mediaID: id, toWatchList: true)
        self.networking.addToWatchlist(with: model) { result in
            switch result {
            case .success(let response):
                print(response.statusMessage)
            case .failure(let error):
                print(error.stringDescription)
            }
        }
    }
    
    func onMovies() {
        self.eventHandler?(.onHeaderEvent(.onMovies))
    }
    
    func onShows() {
        self.eventHandler?(.onHeaderEvent(.onShows))
    }
    
    func onSearch() {
        self.eventHandler?(.onHeaderEvent(.onSearch))
    }
    
    func onMedia(item: ConfigureModel) {
        self.eventHandler?(.onMediaItem(item))
    }
}
