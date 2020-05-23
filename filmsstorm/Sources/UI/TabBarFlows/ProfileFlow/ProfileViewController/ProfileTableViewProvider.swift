//
//  ProfileTableViewProvider.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 23.05.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class ProfileTableViewProvider: NSObject, UITableViewDelegate {
    
    enum Section: CaseIterable {
        case main
    }
    
    enum Item: Hashable {
        case profile(UserModel?)
        case imageQuality
        case about(ActionCellModel)
        case logout(ActionCellModel)
    }
    
    var items: [Item] = []
    var user: UserModel?
    lazy var dataSource = self.createDataSource()
    private let tableView: UITableView
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        self.tableView.register(AvatarViewCell.self)
        self.tableView.register(QualitySettingViewCell.self)
        self.tableView.register(ActionViewCell.self)
        self.tableView.dataSource = self.dataSource
    }
    
    func update(with items: [Item]) {
        var snapshot = self.dataSource?.snapshot()
        snapshot?.appendItems(items)
        snapshot.map { self.dataSource?.apply($0, animatingDifferences: false)}
    }
    
    private func createDataSource() -> UITableViewDiffableDataSource<Section, Item>? {
        let dataSource: UITableViewDiffableDataSource<Section, Item>? =
            UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, item -> UITableViewCell? in
                switch item {
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
        
        dataSource?.apply(self.createSnapshot(), animatingDifferences: false)
        return dataSource
    }
    
    private func createSnapshot() -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(self.items)
        return snapshot
    }
    
}
