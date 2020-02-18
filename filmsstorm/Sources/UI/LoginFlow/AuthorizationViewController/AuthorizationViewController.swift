//
//  AuthorizationViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 29.12.2019.
//  Copyright © 2019 Alexander Andriushchenko. All rights reserved.
//

import UIKit

enum AuthEvent: EventProtocol {
    case login
    case error(AppError)
}

class AuthorizationViewController: UIViewController, Controller, ActivityViewPresenter {
    
    // MARK: - Subtypes

    typealias RootViewType = AuthorizationView
    
    // MARK: - Properties
    
    private let networking: NetworkManager
    let eventHandler: ((AuthEvent) -> Void)?
    let loadingView: ActivityView = .init()
    
    // MARK: - Init and deinit
    
    deinit {
        self.hideActivity()
        print(F.toString(Self.self))
    }
    
    init(networking: NetworkManager, event: ((AuthEvent) -> Void)?) {
        self.networking = networking
        self.eventHandler = event
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - IBAction
   
    @IBAction func buttonTapped(_ sender: Any) {
        self.getToken()
    }
    
    // MARK: - Private methods

    private func getToken() {
        
        self.showActivity()
        self.networking.getToken { [weak self] (result) in
            switch result {
            case .success(let token):
                self?.validateToken(token: token.requestToken)
            case .failure(let error):
                self?.hideActivity()
                self?.eventHandler?(.error(.networkingError(error)))
            }
        }
    }
    
    private func validateToken(token: String) {
        guard let username = self.rootView?.usernameTextField.text,
            let password = self.rootView?.passwordTextField.text else { return }
        let model = AuthRequestModel(username: username, password: password, requestToken: token)
        self.networking.validateToken(with: model) { [weak self] (result) in
            switch result {
            case .success(let token):
                self?.createSession(validToken: token.requestToken)
            case .failure(let error):
                self?.hideActivity()
                self?.eventHandler?(.error(.networkingError(error)))
            }
        }
    }
    
    private func createSession(validToken: String) {
        let model = SessionRequestBody(requestToken: validToken)
        self.networking.createSession(with: model) { [weak self] (result) in
            switch result {
            case .success(let sessionID):
                self?.hideActivity()
                KeyChainContainer.sessionID = sessionID.sessionID
                self?.eventHandler?(.login)
            case .failure(let error):
                self?.hideActivity()
                self?.eventHandler?(.error(.networkingError(error)))
            }
        }
    }
}
