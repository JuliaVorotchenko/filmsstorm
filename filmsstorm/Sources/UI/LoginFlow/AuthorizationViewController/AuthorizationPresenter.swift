//
//  AuthorizationPresentationService.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 23.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//
import Foundation
import CoreData

enum AuthEvent: EventProtocol {
    case login
    case error(AppError)
}

protocol AuthorizationPresenter: Presenter {
    var showActivity: Handler<ActivityState>? { get set }
    func getToken(username: String, password: String)
    func saveFavoriteLists() 
}

final class AuthorizationPresenterImpl: AuthorizationPresenter {
    
    // MARK: - Private properties
    
    private let networking: AuthorizationNetworkManager
    let eventHandler: Handler<AuthEvent>
    var showActivity: Handler<ActivityState>?
    let coreDataManager = CoreDataManager.shared
    
    // MARK: - Init and deinit
    
    init(networking: AuthorizationNetworkManager, event: @escaping Handler<AuthEvent>) {
        self.networking = networking
        self.eventHandler = event
    }
    
    // MARK: - Public Methods
    
    func getToken(username: String, password: String) {
        self.showActivity?(.show)
        self.networking.getToken { [weak self] (result) in
            switch result {
            case .success(let token):
                self?.validateToken(token: token.requestToken, username: username, password: password)
            case .failure(let error):
                self?.showActivity?(.hide)
                self?.eventHandler(.error(.networkingError(error)))
            }
        }
    }
    
    func saveFavoriteLists() {
        self.saveFavoriteMovies()
        self.saveFavoriteShows()
        self.saveWatchlistedMovies()
        self.saveWatchlistedShows()
    }
    
    // MARK: - Private methods
    // MARK: - Auth methods

    private func validateToken(token: String, username: String, password: String) {
        let model = AuthRequestModel(username: username, password: password, requestToken: token)
        self.networking.validateToken(with: model) { [weak self] (result) in
            switch result {
            case .success(let token):
                self?.createSession(validToken: token.requestToken)
            case .failure(let error):
                self?.showActivity?(.hide)
                self?.eventHandler(.error(.networkingError(error)))
            }
        }
    }
    
    private func createSession(validToken: String) {
        let model = SessionRequestBody(requestToken: validToken)
        self.networking.createSession(with: model) { [weak self] (result) in
            switch result {
            case .success(let sessionID):
                self?.showActivity?(.hide)
                KeyChainContainer.sessionID = sessionID.sessionID
                self?.eventHandler(.login)
            case .failure(let error):
                self?.showActivity?(.hide)
                self?.eventHandler(.error(.networkingError(error)))
            }
        }
    }
    
    // MARK: - Data base writting
    
    private func saveFavoriteMovies() {
        self.networking.getFavoriteMovies { result in
            switch result {
            case .success(let model):
                self.coreDataManager.saveFavoriteMovies(movies: model.results)
            case .failure(let error):
                self.eventHandler(.error(.networkingError(error)))
            }
        }
    }
    
    private func saveFavoriteShows() {
        self.networking.getFavoriteShows { result  in
            switch result {
            case .success(let model):
                self.coreDataManager.saveFavoriteShows(shows: model.results)
            case .failure(let error):
               self.eventHandler(.error(.networkingError(error)))
            }
        }
    }
    
    private func saveWatchlistedMovies() {
        self.networking.getWathchListMovies { result in
            switch result {
            case .success(let model):
                self.coreDataManager.saveWatchlistedMovies(movies: model.results)
            case .failure(let error):
               self.eventHandler(.error(.networkingError(error)))
            }
        }
    }
    
    private func saveWatchlistedShows() {
        self.networking.getWatchListShows { result in
            switch result {
            case .success(let model):
                self.coreDataManager.saveWatchlistedShows(shows: model.results)
            case .failure(let error):
               self.eventHandler(.error(.networkingError(error)))
            }
        }
    }
}
