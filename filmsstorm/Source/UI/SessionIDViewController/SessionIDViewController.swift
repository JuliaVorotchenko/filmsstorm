//
//  SessionIDViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 29.12.2019.
//  Copyright © 2019 Alexander Andriushchenko. All rights reserved.
//

import UIKit

enum SessionIDEvent: EventProtocol {
    case back
    case showSessionId
}

class SessionIDViewController: UIViewController, Controller {
    
    // MARK: - Subtypes
    
    typealias Event = SessionIDEvent
    typealias RootViewType = SessionIDView
    
    // MARK: - temporary values
    
    let apiKey = "f4559f172e8c6602b3e2dd52152aca52"
    
    // MARK: - Private properties
    
    private let networking: NetworkManager
    let eventHandler: ((SessionIDEvent) -> Void)?
    
    // MARK: - Init and deinit
    
    deinit {
        print("sessioIdContr")
    }
    
    init(networking: NetworkManager, event: ((SessionIDEvent) -> Void)?) {
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
        self.getUserDetails()
        self.rootView?.fillLabel()

    }
    
    // MARK: - IBActions
    
    @IBAction func backButtonTaapped(_ sender: Any) {
        print("button tapped")
        self.logout()
    }
    
    // MARK: - Private Methods
    
    func logout() {
        let sessionID = UserDefaultsContainer.session
        print(sessionID)
        self.networking.logout(sessionID: sessionID) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let response):
                DispatchQueue.main.async {
                    print(response)
                    self.eventHandler?(.back)
                }
            }
        }
    }
    
    func getUserDetails() {
        let sessionID = UserDefaultsContainer.session
        self.networking.getAccountDetails(sessionID: sessionID) { (result) in
            switch result {
            case .success(let username):
                DispatchQueue.main.async {
                    self.rootView?.userIDLabel.text = username
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}
