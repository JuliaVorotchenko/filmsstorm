//
//  ListViewControllerDataSource.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 18.05.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class ListViewControllerDataSource {
    
    enum Section: CaseIterable {
        case main
    }
    
    var items: [DiscoverCellModel] = []
    lazy var dataSource = self.createDataSource()
    
    var rootView: ListView = .init()
    
    func createDataSource() -> UITableViewDiffableDataSource<Section, DiscoverCellModel>? {
        let dataSource: UITableViewDiffableDataSource<Section, DiscoverCellModel>? =
            self.rootView.tableView
                .map { tableView in
                UITableViewDiffableDataSource(tableView: tableView) { (tableView, indexPath, item) -> UITableViewCell? in
                    let cell: ListTableViewCell =
                        tableView.dequeueReusableCell(ListTableViewCell.self, for: indexPath)
                    cell.fill(with: item)
                    return cell
                }
            }
        var snapshot = NSDiffableDataSourceSnapshot<Section, DiscoverCellModel>()
              snapshot.appendSections(Section.allCases)
              Section.allCases.forEach { snapshot.appendItems([], toSection: $0)}
              
              dataSource?.apply(snapshot, animatingDifferences: false)
              
              return dataSource
        }
    
    
    func update(section: [Section], items: [DiscoverCellModel]) {
        var snapshot = self.dataSource?.snapshot()
        snapshot?.appendItems(items, toSection: .main)
        snapshot.map { self.dataSource?.apply($0, animatingDifferences: false)}
    }
}
