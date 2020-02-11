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

class ProfileViewController: UIViewController, Controller, ActivityViewPresenter, UITableViewDataSource, UITableViewDelegate {
    
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
        self.eventHandler?(.about)
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        self.logout()
    }
    
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
        
        self.rootView?.tableView.register(UINib(nibName: "AvatarViewCell", bundle: nil),
                                          forCellReuseIdentifier: "AvatarViewCell")
        
        self.rootView?.tableView.register(UINib(nibName: "QualitySettingViewCell", bundle: nil),
                                          forCellReuseIdentifier: "QualitySettingViewCell")
        
        self.rootView?.tableView.register(UINib(nibName: "AboutLogoutViewCell", bundle: nil),
                                          forCellReuseIdentifier: "AboutLogoutViewCell")
    }
    
    // MARK: - Table view data source & delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if indexPath.row == 0 {
            guard let cell0 = tableView.dequeueReusableCell(withIdentifier: "AvatarViewCell", for: indexPath) as? AvatarViewCell else { return UITableViewCell() }
            cell = cell0
        }
        
        if indexPath.row == 1 {
            guard let cell1 = tableView.dequeueReusableCell(withIdentifier: "QualitySettingViewCell", for: indexPath) as? QualitySettingViewCell else { return UITableViewCell() }
            cell = cell1
        }
        
        if indexPath.row == 2 {
            guard let cell2 = tableView.dequeueReusableCell(withIdentifier: "AboutLogoutViewCell", for: indexPath) as? AboutLogoutViewCell else { return UITableViewCell() }
            cell = cell2
        }
        
        return cell
    }
    
    private func setTableVievDelegate() {
        self.rootView?.tableView.delegate = self
        self.rootView?.tableView.dataSource = self
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
