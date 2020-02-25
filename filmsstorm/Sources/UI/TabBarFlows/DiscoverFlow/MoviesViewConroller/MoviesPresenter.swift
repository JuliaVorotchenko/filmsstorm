//
//  MoviesViewPresenter.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 24.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

enum MoviesEvent: EventProtocol {
    case movie
    case error(AppError)
}

protocol MoviesPresenter: Presenter {
    var showActivity: ((ActivityState) -> Void)? { get set }
    func getPopularMovies(_ completion: (( [MovieListResult]) -> Void)?)
    func onMovie()
}

class MoviesPresenterImpl: MoviesPresenter {
    
    // MARK: - Private Properties
    
    internal let eventHandler: ((MoviesEvent) -> Void)?
    internal var showActivity: ((ActivityState) -> Void)?
    private let networking: NetworkManager
    var view = MoviesView()
    
    // MARK: - Init and deinit
    
    init(networking: NetworkManager, event: ((MoviesEvent) -> Void)?) {
        self.networking = networking
        self.eventHandler = event
    }
    
    // MARK: - Methods
    
    func getPopularMovies(_ completion: (( [MovieListResult]) -> Void)?) {
        self.networking.getPopularMovies { [weak self] result in
            switch result {
            case .success(let model):
                completion?(model.results)
                
            case .failure(let error):
                self?.eventHandler?(.error(.networkingError(error)))
            }
        }
    }
    
    func onMovie() {
        self.eventHandler?(.movie)
    }
    
    func setTitle() {
        print("presenter movies set title")
        self.view.navigationView?.titleLabel?.text = "Movies"
    }
}
