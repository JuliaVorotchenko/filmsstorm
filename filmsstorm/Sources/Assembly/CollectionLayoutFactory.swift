//
//  CollectionLayoutFactory.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 02.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

enum CollectionLayoutFactory {
    static func standart() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.455),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(0.495))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(6)
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 7
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 9, bottom: 0, trailing: 9)

        return UICollectionViewCompositionalLayout(section: section)
    }
    
    static func mediaItemImagesSections() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(128),
                                                         heightDimension: .absolute(190))
                   let item = NSCollectionLayoutItem(layoutSize: itemSize)
                  
                   let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                          heightDimension: .estimated(222))
                   let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                   group.interItemSpacing = .fixed(14)
                   
                   let section = NSCollectionLayoutSection(group: group)
                   section.contentInsets = .init(top: 8, leading: 14, bottom: 15, trailing: 0)
                   section.interGroupSpacing = 14
                   section.orthogonalScrollingBehavior = .continuous
                   
                   let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                           heightDimension: .estimated(20))
                   let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                       layoutSize: headerSize,
                       elementKind: F.toString(SectionHeaderView.self), alignment: .top)
                   section.boundarySupplementaryItems = [sectionHeader]
       return section
    }
    
    static func mediaItemDescriptionSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(320))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 8, trailing: 0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}
