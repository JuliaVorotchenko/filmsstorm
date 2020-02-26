//
//  DiscoverPresentationService.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 23.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

enum DiscoverEvent: EventProtocol {
    case logout
    case error(AppError)
    case onMediaItem
}

protocol DiscoverPresenter: Presenter {
    var showActivity: ((ActivityState) -> Void)? { get set }
    func getPopularMovies(_ completion: (( [MovieListResult]) -> Void)?)
    func onMovies()
    func onShows()
    func onSearch()
    func onMediaItem()
}

class DiscoverPresenterImpl: DiscoverPresenter {
    
    // MARK: - Private Properties
    internal let headerEventHandler: ((DiscoverHeaderEvent) -> Void)?
    internal let eventHandler: ((DiscoverEvent) -> Void)?
    internal var showActivity: ((ActivityState) -> Void)?
    private let networking: NetworkManager
    
    // MARK: - Init and deinit
    
    init(networking: NetworkManager, event: ((DiscoverEvent) -> Void)?, headerEvent: ((DiscoverHeaderEvent) -> Void)?) {
        self.networking = networking
        self.eventHandler = event
        self.headerEventHandler = headerEvent
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
    
    func onMovies() {
        self.headerEventHandler?(.onMovies)
    }
    
    func onShows() {
        self.headerEventHandler?(.onShows)
    }
    
    func onSearch() {
        self.headerEventHandler?(.onSearch)
    }
    
    func onMediaItem() {
        self.eventHandler?(.onMediaItem)
    }
}
