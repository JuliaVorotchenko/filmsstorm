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
    case error(AppError)
}

class MainViewController: UIViewController, Controller, ActivityViewPresenter {

    // MARK: - Subtypes
    
    typealias Event = SessionIDEvent
    typealias RootViewType = MainView
    
    // MARK: - temporary values
    
    let apiKey = "f4559f172e8c6602b3e2dd52152aca52"
    
    // MARK: - Private properties
    
    private let networking: NetworkManager
    let eventHandler: ((SessionIDEvent) -> Void)?
    let loadingView = ActivityView()
    
    // MARK: - Init and deinit
    
    deinit {
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
        self.rootView?.collectionView.register(UINib(nibName: "MainCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MainCollectionViewCell")
    }
    
    // MARK: - IBActions
    
    // MARK: - Private Methods
    
    private func getUserDetails() {
        let sessionID = UserDefaultsContainer.session
        self.networking.getUserDetails(sessionID: sessionID) { [weak self] result in
            switch result {
            case .success(let usermodel):
                UserDefaultsContainer.username = usermodel.username ?? ""
                DispatchQueue.main.async {
//                    self?.rootView?.fillLabel()
                }
            case .failure(let error):
                self?.eventHandler?(.error(.networkingError(error)))
                print(error.stringDescription)
            }
        }
    }
    
    private func logout() {
        self.showActivity()
        let sessionID = UserDefaultsContainer.session
        self.networking.logout(sessionID: sessionID) { [weak self] result in
            switch result {
            case .success:
                self?.eventHandler?(.back)
                self?.hideActivity()
            case .failure(let error):
                print(error.stringDescription)
                self?.hideActivity()
                self?.eventHandler?(.error(.networkingError(error)))
                
            }
        }
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell",
                                                             for: indexPath) as? MainCollectionViewCell else {
                                                                return UICollectionViewCell() }
        return cell
    }
    
    
}
