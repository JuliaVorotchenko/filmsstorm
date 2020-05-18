//
//  FavoritesViewControllerDataSource.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 18.05.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class FavoritesViewControllerDataSource {
   
    enum Section: CaseIterable {
        case moviesWatchlistLabel
        case moviesWatchlist
        case showsWatchlistLabel
        case showsWatchlist
        case favoriteMoviesLabel
        case favoriteMovies
        case favoriteShowsLabel
        case favoriteShows
    }
    
    enum FavoritesContainer: Hashable {
        case media(DiscoverCellModel)
        case moviesWatchlistLabel
        case showsWatchlistLabel
        case favoriteMoviesLabel
        case favoriteShowsLabel
    }
    
    lazy var dataSource = self.createDataSource()
    var rootView: FavouritesView = .init()
    
    func update(for section: Section, with items: [FavoritesContainer]) {
        var snapshot = self.dataSource?.snapshot()
        snapshot?.appendItems(items, toSection: section)
        snapshot.map { self.dataSource?.apply($0, animatingDifferences: false)}
    }
    
    func updateListsLabels() {
        self.update(for: .favoriteMoviesLabel, with: [FavoritesContainer.favoriteMoviesLabel])
        self.update(for: .favoriteShowsLabel, with: [FavoritesContainer.favoriteShowsLabel])
        self.update(for: .moviesWatchlistLabel, with: [FavoritesContainer.moviesWatchlistLabel])
        self.update(for: .showsWatchlistLabel, with: [FavoritesContainer.showsWatchlistLabel])
    }
    
    func clearDataSource() {
           let items = [FavoritesContainer]()
           var snapshot = NSDiffableDataSourceSnapshot<Section, FavoritesContainer>()
           snapshot.appendSections(Section.allCases)
           snapshot.appendItems(items)
           self.dataSource?.apply(snapshot, animatingDifferences: false)
       }
    
    func createDataSource() -> UICollectionViewDiffableDataSource<Section, FavoritesContainer>? {
        let dataSource: UICollectionViewDiffableDataSource<Section, FavoritesContainer>? =
            self.rootView.collectionView
                .map { collectionView in UICollectionViewDiffableDataSource(collectionView: collectionView) {
                    [weak self] collectionView, indexPath, item -> UICollectionViewCell in
                    switch item {
                        
                    case .media(let model):
                        let cell: MediaItemImageCell = collectionView.dequeueReusableCell(MediaItemImageCell.self, for: indexPath)
                        cell.similarsFill(model: model)
                        return cell
                        
                    case .moviesWatchlistLabel:
                        let cell: ListTypeCell = collectionView.dequeueReusableCell(ListTypeCell.self, for: indexPath)
                        cell.fill(listType: "Movie List")
                        return cell
                        
                    case .showsWatchlistLabel:
                        let cell: ListTypeCell = collectionView.dequeueReusableCell(ListTypeCell.self, for: indexPath)
                        cell.fill(listType: "TV List")
                        return cell
                        
                    case .favoriteMoviesLabel:
                        let cell: ListTypeCell = collectionView.dequeueReusableCell(ListTypeCell.self, for: indexPath)
                        cell.fill(listType: "Favorite Movies")
                        return cell
                        
                    case .favoriteShowsLabel:
                        let cell: ListTypeCell = collectionView.dequeueReusableCell(ListTypeCell.self, for: indexPath)
                        cell.fill(listType: "Favorite Shows")
                        return cell
                    }
                    }
                    
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, FavoritesContainer>()
        snapshot.appendSections(Section.allCases)
        Section.allCases.forEach { snapshot.appendItems([], toSection: $0)}
        
        dataSource?.apply(snapshot, animatingDifferences: false)
        
        return dataSource
    }
}
