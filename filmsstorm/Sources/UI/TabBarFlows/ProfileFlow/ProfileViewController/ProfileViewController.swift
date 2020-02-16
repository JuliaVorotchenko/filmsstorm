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
    
    enum Item: Hashable {
        case profile(UserModel?)
        case imageQuality
        case about(ActionCellModel)
        case logout(ActionCellModel)
    }
    
    // MARK: - Public Properties
    
    let loadingView = ActivityView()
    let eventHandler: ((ProfileEvent) -> Void)?
    
    // MARK: - Private properties
    
    private let networking: NetworkManager
    private var user: UserModel?
    private var items: [Item] = []
    private lazy var dataSource = self.diffableDataSource()
    
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
        self.setupTableView()
        self.getUserDetails()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.createItems()
    }
    
    // MARK: - Private methods
    
    private func onLogout() {
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
                self?.createItems()
            case .failure(let error):
                self?.eventHandler?(.error(.networkingError(error)))
            }
        }
    }
    
    private func createItems() {
        let logoutImage = UIImage(named: "logout")
        let aboutImage = UIImage(named: "about")
        let aboutCellModel = ActionCellModel(name: "About us", image: aboutImage, action: self.onAbout)
        let logoutCellModel = ActionCellModel(name: "Logout", image: logoutImage, action: self.onLogout)
        self.items = [.profile(self.user), .imageQuality, .about(aboutCellModel), .logout(logoutCellModel)]
        self.update(sections: Section.allCases, items: self.items)
    }
    
    private func onAbout() {
        self.eventHandler?(.about)
    }
    
    private func update(sections: [Section], items: [Item]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(sections)
        snapshot.appendItems(items)
        self.dataSource?.apply(snapshot)
        
    }
    
    private func setupTableView() {
        let tableView = self.rootView?.tableView
        tableView?.register(AvatarViewCell.self)
        tableView?.register(QualitySettingViewCell.self)
        tableView?.register(ActionViewCell.self)
        tableView?.dataSource = self.dataSource
    }
    
    private func diffableDataSource() -> UITableViewDiffableDataSource<Section, Item>? {
        return self.rootView.map {
            UITableViewDiffableDataSource(tableView: $0.tableView) { (tableView, indexPath, items) -> UITableViewCell? in
                switch items {
                case .profile(let model):
                    let cell: AvatarViewCell = tableView.dequeueReusableCell(AvatarViewCell.self, for: indexPath)
                    cell.fill(model: model)
                    return cell
                case .imageQuality:
                    let cell: QualitySettingViewCell = tableView.dequeueReusableCell(QualitySettingViewCell.self, for: indexPath)
                    return cell
                case .about(let model):
                    let cell: ActionViewCell = tableView.dequeueReusableCell(ActionViewCell.self, for: indexPath)
                    cell.fill(with: model)
                    return cell
                case .logout(let model):
                    let cell: ActionViewCell = tableView.dequeueReusableCell(ActionViewCell.self, for: indexPath)
                    cell.fill(with: model)
                    return cell
                }
            }
        }
    }
    
}
