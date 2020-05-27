//
//  ListViewControllerDataSource.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 18.05.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class ListTableViewProvider: NSObject, UITableViewDelegate {
    
    enum Section: CaseIterable {
        case main
    }
    
    var items: [DiscoverCellModel] = []
    lazy var dataSource = self.createDataSource()
    private let tableView: UITableView
    private var event: ((DiscoverCellModel) -> Void)?
    
    init(tableView: UITableView, event: ((DiscoverCellModel) -> Void)?) {
        self.tableView = tableView
        self.event = event
        super.init()
        self.tableViewSetup()
    }
    
    func update(with items: [DiscoverCellModel]) {
        var snapshot = self.dataSource?.snapshot()
        snapshot?.appendItems(items, toSection: Section.main)
        snapshot.map { self.dataSource?.apply($0, animatingDifferences: false)}
    }
    
    private func createDataSource() -> UITableViewDiffableDataSource<Section, DiscoverCellModel>? {
        let dataSource: UITableViewDiffableDataSource<Section, DiscoverCellModel>? =
            UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, item -> UITableViewCell? in
                let cell: ListTableViewCell =
                    tableView.dequeueReusableCell(ListTableViewCell.self, for: indexPath)
                cell.fill(with: item)
                return cell
        }
        
        dataSource?.apply(self.createSnapshot(), animatingDifferences: false)
        return dataSource
    }
    
    private func createSnapshot() -> NSDiffableDataSourceSnapshot<Section, DiscoverCellModel> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DiscoverCellModel>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(self.items)
        return snapshot
    }
    
    private func tableViewSetup() {
        self.tableView.register(ListTableViewCell.self)
        self.tableView.delegate = self
    }
    
    // MARK: - TableView delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataSource?.itemIdentifier(for: indexPath)
        model.map { self.event?($0) }
    }
}
