//
//  ProfileViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 06.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit
import Foundation

enum ProfileEvent: EventProtocol {
    case logout
    case about
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
    
    // MARK: - Init & deinit
    
    init(networking: NetworkManager, event: ((ProfileEvent) -> Void)?) {
        self.networking = networking
        self.eventHandler = event
        super.init(nibName: F.toString(type(of: self)), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - VC lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        self.setTableVievDelegate()
        self.regiterCells()
    }
    
    // MARK: - Private methods
    
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

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table view data source & delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if indexPath.row == 0 {
            guard let cell0 = tableView.dequeueReusableCell(withIdentifier: "AvatarViewCell",
                                                            for: indexPath) as? AvatarViewCell else { return UITableViewCell() }
            cell0.setAvatar()
            cell = cell0
        }
        
        if indexPath.row == 1 {
            guard let cell1 = tableView.dequeueReusableCell(withIdentifier: "QualitySettingViewCell",
                                                            for: indexPath) as? QualitySettingViewCell else { return UITableViewCell() }
            cell = cell1
        }
        
        if indexPath.row == 2 {
            guard let cell2 = tableView.dequeueReusableCell(withIdentifier: "AboutViewCell",
                                                            for: indexPath) as? AboutViewCell else { return UITableViewCell() }
            cell2.aboutTappedAction = { [unowned self] in
                self.eventHandler?(.about)
            }
            cell = cell2
        }
        
        if indexPath.row == 3 {
            guard let cell3 = tableView.dequeueReusableCell(withIdentifier: "LogoutViewCell",
                                                            for: indexPath) as? LogoutViewCell else { return UITableViewCell() }
            cell3.logoutTappedAction = { [unowned self] in
                self.logout()
            }
            cell = cell3
            
        }
        
        return cell
    }
    
    private func setTableVievDelegate() {
        self.rootView?.tableView.delegate = self
        self.rootView?.tableView.dataSource = self
    }
    
    private func regiterCells() {
        
        self.rootView?.tableView.register(UINib(nibName: "AvatarViewCell", bundle: nil),
                                          forCellReuseIdentifier: "AvatarViewCell")
        
        self.rootView?.tableView.register(UINib(nibName: "QualitySettingViewCell", bundle: nil),
                                          forCellReuseIdentifier: "QualitySettingViewCell")
        
        self.rootView?.tableView.register(UINib(nibName: "AboutViewCell", bundle: nil),
                                          forCellReuseIdentifier: "AboutViewCell")
        
        self.rootView?.tableView.register(UINib(nibName: "LogoutViewCell", bundle: nil),
                                          forCellReuseIdentifier: "LogoutViewCell")
    }
}
