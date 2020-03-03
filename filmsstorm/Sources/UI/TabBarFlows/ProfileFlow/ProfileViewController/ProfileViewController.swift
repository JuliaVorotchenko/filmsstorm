//
//  ProfileViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 06.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class ProfileViewController<T: ProfilePresenter>: UIViewController, Controller, ActivityViewPresenter {
   
    // MARK: - Subtypes
    
    typealias RootViewType = ProfileView
    
    typealias Service = T
    
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
    var presenter: T
    let loadingView = ActivityView()

    private var items: [Item] = []
    private lazy var dataSource = self.diffableDataSource()
    private var user: UserModel?
   
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
   self.setupTableView()
        self.presenter.getUserDetails { [weak self] in
            self?.user = $0
            self?.createItems()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.createItems()
    }
    
    // MARK: - Private methods
    
    private func createItems() {
        let logoutImage = UIImage(named: "logout")
        let aboutImage = UIImage(named: "about")
        let aboutCellModel = ActionCellModel(name: "About us", image: aboutImage) { [weak self] in self?.presenter.onAbout() }
        let logoutCellModel = ActionCellModel(name: "Logout", image: logoutImage, action: { [weak self] in self?.presenter.onLogout() })
        self.items = [.profile(self.user), .imageQuality, .about(aboutCellModel), .logout(logoutCellModel)]
        self.update(sections: Section.allCases, items: self.items)
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
