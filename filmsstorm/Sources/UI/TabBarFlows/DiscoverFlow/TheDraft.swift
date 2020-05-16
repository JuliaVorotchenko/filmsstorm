//
//  TheDraft.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 15.05.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class DiscoverViewControllerDataSourceProvider: NSObject, UICollectionViewDelegate {
    
    enum Section: CaseIterable {
        case  main
    }
    
    var items = [DiscoverCellModel]()
    var dataSource: UICollectionViewDiffableDataSource<Section, DiscoverCellModel>?
    
    func createDataSource(rootView: DiscoverView?) {
        
        guard let collectionView = rootView?.collectionView else { return }
        
        self.dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self] collection, indexPath, item -> UICollectionViewCell? in
            
            let cell: DiscoverCollectionViewCell = collection.dequeueReusableCell(DiscoverCollectionViewCell.self, for: indexPath)
            cell.fill(with: item)
            return cell
        }
        let snapshot = self.createSnapshot()
        self.dataSource?.apply(snapshot)
        
    }
    
    func createSnapshot() -> NSDiffableDataSourceSnapshot<Section, DiscoverCellModel> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DiscoverCellModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.items)
        
        return snapshot
    }

}
