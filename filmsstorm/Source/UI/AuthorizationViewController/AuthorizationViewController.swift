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
        self.spinnerStart()
        self.networking.getToken { (result) in
            switch result {
            case .success(let token):
                self.validateToken(token: token.requestToken)
            case .failure(let error):
                print(error.stringDescription)
                self.spinnerStop()
            }
        }
    }
    
    private func validateToken(token: String) {
        guard let username = self.rootView?.usernameTextField.text,
            let password = self.rootView?.passwordTextField.text else { return }
        let model = AuthRequestModel(username: username, password: password, requestToken: token)
        self.networking.validateToken(with: model) { (result) in
            switch result {
            case .success(let token):
                self.createSession(validToken: token.requestToken)
            case .failure(let error):
                self.spinnerStop()
                print(error.stringDescription)
            }
        }
    }
    
    private func createSession(validToken: String) {
        let model = SessionRequestBody(requestToken: validToken)
        self.networking.createSession(with: model) { (result) in
            switch result {
            case .success(let sessionID):
                self.spinnerStart()
                  UserDefaultsContainer.session = sessionID.sessionID
                self.eventHandler?(.login)
            case .failure(let error):
                 self.spinnerStop()
                print(error.stringDescription)
            }
            
        }
    }
}
