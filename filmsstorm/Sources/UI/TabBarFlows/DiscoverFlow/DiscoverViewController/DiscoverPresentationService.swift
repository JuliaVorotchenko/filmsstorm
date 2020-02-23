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
}

protocol DiscoverPresentationService: PresentationService {
    var showActivity: ((ActivityState) -> Void)? { get set }
    func getPopularMovies(_ complition: (( [MovieListResult]) -> Void)?)
}

class DiscoverPresentationServiceImpl: DiscoverPresentationService {
    
    // MARK: - Properties
    let eventHandler: ((DiscoverEvent) -> Void)?
     var showActivity: ((ActivityState) -> Void)?
    private let networking: NetworkManager
    
    // MARK: - Init and deinit
    init(networking: NetworkManager, event: ((DiscoverEvent) -> Void)?) {
        self.networking = networking
        self.eventHandler = event
    }
    
    // MARK: - Methods
    
    func getPopularMovies(_ complition: (( [MovieListResult]) -> Void)?) {
        self.networking.getPopularMovies { [weak self] result in
            switch result {
            case .success(let model):
                complition?(model.results)
                
            case .failure(let error):
                self?.eventHandler?(.error(.networkingError(error)))
            }
        }
    }
}
