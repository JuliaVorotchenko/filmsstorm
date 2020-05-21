//
//  ActorsCollectionViewProvider.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 21.05.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class ActorsCollectionViewProvider: NSObject, UICollectionViewDelegate {
    
    enum Section: CaseIterable {
        case actor
        case actorsMedia
    }
    
    enum ActorContainer: Hashable {
        case actor(ActorDetailsModel)
        case actorsMedia(DiscoverCellModel)
    }
    
    lazy var dataSource = self.createDataSource()
    private let collectionView: UICollectionView
    private var events: ((ActorContainer) -> Void)?
    
    init(collectionView: UICollectionView, events: ((ActorContainer) -> Void)?) {
        self.collectionView = collectionView
        self.events = events
        super.init()
        self.collectionView.register(ActorDescriptionCell.self)
        self.collectionView.register(MediaItemImageCell.self)
        self.collectionView.registerHeader(SectionHeaderView.self)
        self.collectionView.delegate = self
        self.collectionView.setCollectionViewLayout(self.createCompositionalLayout(), animated: false)
    }
    
    func update(for section: Section, with items: [ActorContainer]) {
        var snapshot = self.dataSource?.snapshot()
        snapshot?.appendItems(items, toSection: section)
        snapshot.map { self.dataSource?.apply($0, animatingDifferences: false)}
    }
    
    private func createDataSource() -> UICollectionViewDiffableDataSource<Section, ActorContainer>? {
        
        let dataSource: UICollectionViewDiffableDataSource<Section, ActorContainer>? =
            UICollectionViewDiffableDataSource(collectionView: collectionView) {
                
                collectionView, indexPath, item -> UICollectionViewCell in
                
                switch item {
                case .actor(let model):
                    let cell: ActorDescriptionCell = collectionView.dequeueReusableCell(ActorDescriptionCell.self,
                                                                                        for: indexPath)
                    cell.fill(with: model)
                    return cell
                    
                case .actorsMedia(let model):
                    let cell: MediaItemImageCell = collectionView.dequeueReusableCell(MediaItemImageCell.self,
                                                                                      for: indexPath)
                    cell.similarsFill(model: model)
                    return cell
                    
                }
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, ActorContainer>()
        snapshot.appendSections(Section.allCases)
        Section.allCases.forEach { snapshot.appendItems([], toSection: $0)}
        
        dataSource?.supplementaryViewProvider = { [weak self] in self?.supplementaryViewProvider(collectionView: $0,
                                                                                                 kind: $1,
                                                                                                 indexPath: $2) }
        dataSource?.apply(snapshot, animatingDifferences: false)
        
        return dataSource
    }
    
    private func supplementaryViewProvider(collectionView: UICollectionView, kind: String,
                                           indexPath: IndexPath) -> UICollectionReusableView? {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier,
            for: indexPath) as? SectionHeaderView
        
        switch Section.allCases[indexPath.section] {
        case .actor: break
        case .actorsMedia:
            header?.fill(with: "Actors Movies")
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.dataSource?.itemIdentifier(for: indexPath)
        model.map { self.events?($0) }
        }
    
    // MARK: - Setup Layout
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            let section = Section.allCases[sectionIndex]
            switch section {
            case .actor:
                return CollectionLayoutFactory.mediaItemDescriptionSection()
            case .actorsMedia:
                return CollectionLayoutFactory.mediaItemImagesSections()
            }
        }
        return layout
    }
}
