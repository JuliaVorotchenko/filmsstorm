//
//  TheDraft.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 15.05.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class DiscoverCollectionViewProvider: NSObject, UICollectionViewDelegate {
    
    enum Section: CaseIterable {
        case  main
    }
    
    var items = [DiscoverCellModel]()
    lazy var dataSource = self.createDataSource()
    private let collectionView: UICollectionView
    private var event: ((DiscoverCellModel) -> Void)?
    
    init(collectionView: UICollectionView, event: ((DiscoverCellModel) -> Void)?) {
        self.collectionView = collectionView
        self.event = event
        super.init()
        self.collectionViewSetup()
    }
    
    func update(with items: [DiscoverCellModel]) {
        var snapshot = self.dataSource?.snapshot()
        snapshot?.appendItems(items, toSection: Section.main)
        snapshot.map { self.dataSource?.apply($0, animatingDifferences: false)}
    }
    
    private func createDataSource() -> UICollectionViewDiffableDataSource<Section, DiscoverCellModel>? {
        let dataSource: UICollectionViewDiffableDataSource<Section, DiscoverCellModel>? =
            UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, item
                -> UICollectionViewCell in
                let cell: DiscoverCollectionViewCell =
                    collectionView.dequeueReusableCell(DiscoverCollectionViewCell.self, for: indexPath)
                cell.fill(with: item)
                return cell
        }
        dataSource?.apply(self.createSnapshot(), animatingDifferences: false)
        return dataSource
    }
    
    private func createSnapshot() ->
        NSDiffableDataSourceSnapshot<Section, DiscoverCellModel> {
            var snapshot = NSDiffableDataSourceSnapshot<Section, DiscoverCellModel>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(self.items)
            return snapshot
    }
    
    func clearDataSource() {
           self.items = [DiscoverCellModel]()
           var snapshot = NSDiffableDataSourceSnapshot<Section, DiscoverCellModel>()
           snapshot.appendSections(Section.allCases)
           snapshot.appendItems(items)
           self.dataSource?.apply(snapshot, animatingDifferences: false)
       }
    
    // MARK: - Setup Layout
    
    private func setCompositionalLayout() {
        let layout = CollectionLayoutFactory.standart()
        self.collectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    // MARK: - CollectionView Setup
    
    private func collectionViewSetup() {
        self.collectionView.register(DiscoverCollectionViewCell.self)
        self.collectionView.delegate = self
        self.setCompositionalLayout()
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.dataSource?.itemIdentifier(for: indexPath)
        model.map { self.event?($0) }
    }
}
