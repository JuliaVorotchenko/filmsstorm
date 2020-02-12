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
    
    enum Section: CaseIterable {
        case main
    }
    
    // MARK: - Public Properties
    
    let loadingView = ActivityView()
    let eventHandler: ((ProfileEvent) -> Void)?
    
    // MARK: - Private properties
    
    private let networking: NetworkManager
    private var user: UserModel?
    
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
        self.getUserDetails()
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
    
    func getUserDetails() {
        self.networking.getUserDetails(sessionID: UserDefaultsContainer.session) { [weak self] result in
            switch result {
            case .success(let model):
                self?.user = model
                self?.rootView?.tableView.reloadData()
            case .failure(let error):
                self?.eventHandler?(.error(.networkingError(error)))
            }
        }
    }
}

extension ProfileViewController: UITableViewDataSource {
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if indexPath.row == 0 {
            let cell0: AvatarViewCell = tableView.dequeueReusableCell(AvatarViewCell.self, for: indexPath)
            guard let userModel = self.user else { return UITableViewCell() }
            cell0.fill(model: userModel)
            cell = cell0
        }
        
        if indexPath.row == 1 {
            let cell1: QualitySettingViewCell = tableView.dequeueReusableCell(QualitySettingViewCell.self, for: indexPath)
            cell = cell1
        }
        
        if indexPath.row == 2 {
            let cell2: AboutViewCell = tableView.dequeueReusableCell(AboutViewCell.self, for: indexPath)
            cell2.aboutTappedAction = { [weak self] in
                self?.eventHandler?(.about)
            }
            cell = cell2
        }
        
        if indexPath.row == 3 {
            let cell3: LogoutViewCell  = tableView.dequeueReusableCell(LogoutViewCell.self, for: indexPath)
            cell3.logoutTappedAction = { [weak self] in
                self?.logout()
            }
            cell = cell3
        }
        
        return cell
    }
    
    private func setTableVievDelegate() {
        self.rootView?.tableView.dataSource = self
    }
    
    private func regiterCells() {
        let tableView = self.rootView?.tableView
        tableView?.register(AvatarViewCell.self)
        tableView?.register(QualitySettingViewCell.self)
        tableView?.register(AboutViewCell.self)
        tableView?.register(LogoutViewCell.self)
    }
}
