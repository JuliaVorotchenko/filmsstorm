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
    
    // MARK: - temporary variables
    let apiKey = "f4559f172e8c6602b3e2dd52152aca52"
    var token: RequestToken?
    var validToken: RequestToken?
    var sessionID: SessionID?
    
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
        
        self.networking.getToken { (requestToken, error) in
            if let error = error {
                print(error)
            }
            if let requestToken = requestToken {
                self.networking.validateToken { (validToken, error) in
                    if let error = error {
                        print(error)
                        if let validToken = validToken {
                            self.networking.createSession { (sessionID, error) in
                                if let error = error {
                                    print(error)
                                    if let sessionID = sessionID {
                                        UserDefaultsContainer.session = sessionID
                                        self.eventHandler?(.login)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
   
}
