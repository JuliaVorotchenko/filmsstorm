//
//  ProfilePresentationService.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 23.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

enum ProfileEvent: EventProtocol {
    case logout
    case about
    case error(AppError)
}

protocol ProfilePresenter: Presenter {
    var showActivity: ((ActivityState) -> Void)? { get set }
    func onAbout()
    func onLogout()
    func getUserDetails(_ completion: ((UserModel) -> Void)?)
}

class ProfilePresenterImpl: ProfilePresenter {
    
    // MARK: - Subtypes
    
    typealias Event = ProfileEvent
    
    // MARK: - Public properties
    
    var user: UserModel?
    
    // MARK: - Private properties
    
    var showActivity: ((ActivityState) -> Void)?
    private let networking: ProfileNetworkManager
    let eventHandler: (ProfileEvent) -> Void
    
    // MARK: - Init and deinit
    
    init(networking: ProfileNetworkManager, event: @escaping (ProfileEvent) -> Void) {
        self.networking = networking
        self.eventHandler = event
    }
    
    // MARK: - Private methods
    
    func onLogout() {
        self.showActivity?(.show)
        self.networking.logout { [weak self] result in
            switch result {
            case .success:
                KeyChainContainer.unregister()
                self?.eventHandler(.logout)
                self?.showActivity?(.hide)
            case .failure(let error):
                F.Log(error.stringDescription)
                self?.showActivity?(.hide)
                self?.eventHandler(.error(.networkingError(error)))
            }
        }
    }
    
    func getUserDetails(_ completion: ((UserModel) -> Void)?) {
        self.networking.getUserDetails { [weak self] result in
            switch result {
            case .success(let model):
                completion?(model)
            case .failure(let error):
                self?.eventHandler(.error(.networkingError(error)))
            }
        }
    }
    
    func onAbout() {
        self.eventHandler(.about)
    }
}
