//
//  ProfileViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 06.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class ProfileViewController<T: ProfilePresenter>: UIViewController, Controller {
    
    // MARK: - Subtypes
    
    typealias RootViewType = ProfileView
    typealias DataSource = ProfileTableViewProvider
    typealias Service = T
    
    // MARK: - Public Properties
    let presenter: T
    private lazy var dataSource = self.rootView?.tableView
        .map { DataSource(tableView: $0)}
    
    // MARK: - Init & deinit
    
    required init(_ presentation: Service) {
        self.presenter = presentation
        super.init(nibName: F.nibNamefor(Self.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        F.Log(self)
    }
    
    // MARK: - VC lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserDetails()
    }
  
    private func getUserDetails() {
        self.presenter.getUserDetails { [weak self] in
            self?.dataSource?.user = $0
            self?.createItems()
        }
    }
    
    // MARK: - Private methods
    
    private func createItems() {
        let logoutImage = UIImage(named: "logout")
        let aboutImage = UIImage(named: "about")
        let aboutCellModel = ActionCellModel(name: "About us", image: aboutImage) { [weak self] in self?.presenter.onAbout() }
        let logoutCellModel = ActionCellModel(name: "Logout", image: logoutImage, action: { [weak self] in self?.presenter.onLogout() })
        self.dataSource?.items = [.profile(self.dataSource?.user), .imageQuality, .about(aboutCellModel), .logout(logoutCellModel)]
        guard let items = self.dataSource?.items else { return }
        self.dataSource?.update(with: items)
    }
}
