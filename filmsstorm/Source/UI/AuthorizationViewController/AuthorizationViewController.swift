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
    case error(String)
}
/*
 1. Get request token with APIkey
 2. Validate request token with password and username
 3. Get sessionID
 */
class AuthorizationViewController: UIViewController, Controller {
    
    // MARK: - Subtypes
    
    typealias Event = AuthEvent
    typealias RootViewType = AuthorizationView
    
    // MARK: - Properties
    
    private let networking: NetworkManager
    let eventHandler: ((Event) -> Void)?
    
    // MARK: - Init and deinit
    
    init(networking: NetworkManager, event: ((AuthEvent) -> Void)?) {
        self.networking = networking
        self.eventHandler = event
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBAction
    
    @IBAction func buttonTapped(_ sender: Any) {
        self.getToken()
    }
    
    private func getToken() {
        print("get token")
        self.networking.getToken { [weak self] result in
            switch result {
            case .success(let token):
                print(token)
                UserDefaultsContainer.token = token
                DispatchQueue.main.async {
                    self?.validateToken(requestToken: token)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func validateToken(requestToken: String) {
        guard let username = self.rootView?.usernameTextField.text,
            let password = self.rootView?.passwordTextField.text else { return }
        self.networking.validateToken(username: username,
                                      password: password,
                                      requestToken: UserDefaultsContainer.token) { [weak self] result in
                                        switch result {
                                        case .success(let validToken):
                                            UserDefaultsContainer.token = validToken
                                            DispatchQueue.main.async {
                                                print(validToken)
                                                self?.createSession(validToken: validToken)
                                            }
                                            
                                        case .failure(let error):
                                            print(error.localizedDescription)
                                        }
                                        
        }
    }
    
    private func createSession(validToken: String) {
        self.networking.createSession(validToken: validToken) { [weak self] result in
            switch result {
            case .success(let sessionID):
                UserDefaultsContainer.session = sessionID
                print(sessionID)
                DispatchQueue.main.async {
                    self?.eventHandler?(.login)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
