//
//  MediaItemCollectionViewProvider.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 21.05.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class MediaItemCollectionViewProvider: NSObject, UICollectionViewDelegate {
    
    enum Section: CaseIterable {
        case media
        case actors
        case similars
    }
    
    enum MediaItemContainer: Hashable {
        case media(MediaItemModel?)
        case actors(ActorModel)
        case similars(DiscoverCellModel)
    }
    
    enum ItemDescriptionEvent: Equatable {
        case watchlist(MediaItemModel?, isWatchlisted: Bool)
        case favourites(MediaItemModel?, isLiked: Bool)
        case play(MediaItemModel?)
    }

    private lazy var dataSource = self.createDataSource()
    private let collectionView: UICollectionView
    private var events: ((MediaItemContainer) -> Void)?
    var itemEvent: ((ItemDescriptionEvent) -> Void)?
    
    init(collectionView: UICollectionView, events: ((MediaItemCollectionViewProvider.MediaItemContainer) -> Void)?) {
        self.collectionView = collectionView
        self.events = events
        
        super.init()
        self.collectionView.register(MediaItemImageCell.self)
        self.collectionView.register(ItemDescriptionViewCell.self)
        self.collectionView.registerHeader(SectionHeaderView.self)
        self.collectionView.setCollectionViewLayout(self.createCompositionalLayout(), animated: false)
        self.collectionView.delegate = self
    }
    
    func update(for section: Section, with items: [MediaItemContainer]) {
        var snapshot = self.dataSource?.snapshot()
        snapshot?.appendItems(items, toSection: section)
        snapshot.map { self.dataSource?.apply($0, animatingDifferences: false)}
    }
    
    func createDataSource() -> UICollectionViewDiffableDataSource<Section, MediaItemContainer>? {
        
        let dataSource: UICollectionViewDiffableDataSource<Section, MediaItemContainer>? =
            UICollectionViewDiffableDataSource(collectionView: collectionView) {
                collectionView, indexPath, item -> UICollectionViewCell in
                
                switch item {
                case .media(let model):
                    let cell: ItemDescriptionViewCell = collectionView.dequeueReusableCell(ItemDescriptionViewCell.self,
                                                                                           for: indexPath)
                   // cell.fill(detailsModel: model, onAction: .init { self.onItemDescriptionEvent($0) })
                    return cell
                    
                case .similars(let model):
                    let cell: MediaItemImageCell = collectionView.dequeueReusableCell(MediaItemImageCell.self,
                                                                                      for: indexPath)
                    cell.similarsFill(model: model)
                    return cell
                    
                case .actors(let model):
                    let cell: MediaItemImageCell = collectionView.dequeueReusableCell(MediaItemImageCell.self,
                                                                                      for: indexPath)
                    cell.actorsFill(model: model)
                    return cell
                }
        }
        
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, MediaItemContainer>()
        snapshot.appendSections(Section.allCases)
        Section.allCases.forEach { snapshot.appendItems([], toSection: $0)}
        
        dataSource?.supplementaryViewProvider = { [weak self] in self?.supplementaryViewProvider(collectionView: $0,
                                                                                                 kind: $1,
                                                                                                 indexPath: $2) }
        dataSource?.apply(snapshot, animatingDifferences: false)
        
        return dataSource
    }
    
    private func supplementaryViewProvider(collectionView: UICollectionView,
                                           kind: String,
                                           indexPath: IndexPath) -> UICollectionReusableView? {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier,
            for: indexPath) as? SectionHeaderView
        
        switch Section.allCases[indexPath.section] {
        case .actors:
            header?.fill(with: "Actors")
        case .similars:
            header?.fill(with: "Similars")
        case .media:
            break
        }
        
        return header
    }
    
    // MARK: - Setup Layout
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            let section = Section.allCases[sectionIndex]
            switch section {
            case .actors:
                return CollectionLayoutFactory.mediaItemImagesSections()
            case .media:
                return CollectionLayoutFactory.mediaItemDescriptionSection()
            case .similars:
                return CollectionLayoutFactory.mediaItemImagesSections()
            }
        }
        return layout
    }
    
    // MARK: - CollectionView delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.dataSource?.itemIdentifier(for: indexPath)
        model.map {
            switch $0 {
            case .actors:
                self.events?($0)
            case .media:
                break
            case .similars:
                self.events?($0)
            }
        }
    }
}
