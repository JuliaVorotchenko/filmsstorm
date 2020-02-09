//
//  ProfileViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 06.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

enum ProfileEvent: EventProtocol {
    case logout
    case close
    case error(AppError)
}

class ProfileViewController: UIViewController, Controller, ActivityViewPresenter {
    
    // MARK: - Subtypes
    
    typealias RootViewType = ProfileView
    typealias Event = ProfileEvent
    
    // MARK: - Public Properties
    
    let loadingView = ActivityView()
    let eventHandler: ((ProfileEvent) -> Void)?
    
    // MARK: - Private properties
    
    private let networking: NetworkManager
    
    // MARK: - IBActions
    
    @IBAction func setImagesQualityButton(_ sender: Any) {
    }
    
    @IBAction func aboutButton(_ sender: Any) {
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        print("k")
        self.logout()
    }
    
init(networking: NetworkManager, event: ((ProfileEvent) -> Void)?) {
        self.networking = networking
        self.eventHandler = event
        super.init(nibName: F.toString(type(of: self)), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rootView?.setAvatar()
        
    }
    
    private func logout() {
        self.showActivity()
        let sessionID = UserDefaultsContainer.session
        self.networking.logout(sessionID: sessionID) { [weak self] result in
            switch result {
            case .success:
                UserDefaultsContainer.unregister()
                self?.eventHandler?(.logout)
                self?.hideActivity()
            case .failure(let error):
                print(error.stringDescription)
                self?.hideActivity()
                self?.eventHandler?(.error(.networkingError(error)))
            }
        }
    }
}
