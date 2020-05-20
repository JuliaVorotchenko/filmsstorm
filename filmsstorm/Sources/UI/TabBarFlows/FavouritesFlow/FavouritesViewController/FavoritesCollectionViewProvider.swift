//
//  FavoritesViewControllerDataSource.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 18.05.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class FavoritesCollectionViewProvider: NSObject, UICollectionViewDelegate {
    
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
    private let collectionView: UICollectionView
    private var events: ((FavoritesContainer) -> Void)?
    
    init(collectionView: UICollectionView, events: ((FavoritesContainer) -> Void)?) {
        self.collectionView = collectionView
        self.events = events
        super.init()
        self.collectionView.register(ListTypeCell.self)
        self.collectionView.register(MediaItemImageCell.self)
        self.collectionView.delegate = self
        self.collectionView.setCollectionViewLayout(self.createCompositionalLayout(), animated: false)
    }
    
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
        self.dataSource?.apply(self.createSnapshot(), animatingDifferences: false)
    }
    
    private func createDataSource() -> UICollectionViewDiffableDataSource<Section, FavoritesContainer>? {
        let dataSource: UICollectionViewDiffableDataSource<Section, FavoritesContainer>? =
            UICollectionViewDiffableDataSource(collectionView: collectionView) {
                collectionView, indexPath, item -> UICollectionViewCell in
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
        
        dataSource?.apply(self.createSnapshot(), animatingDifferences: false)
        
        return dataSource
    }
    
    private func createSnapshot(_ sections: [Section] = Section.allCases,
                                with items: [FavoritesContainer] = []) -> NSDiffableDataSourceSnapshot<Section, FavoritesContainer> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, FavoritesContainer>()
        snapshot.appendSections(sections)
        sections.forEach { snapshot.appendItems([], toSection: $0)}
        return snapshot
    }
    
    // MARK: - Setup Layout

    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            let section = Section.allCases[sectionIndex]
            switch section {
            case .moviesWatchlistLabel, .showsWatchlistLabel, .favoriteMoviesLabel, .favoriteShowsLabel:
                return CollectionLayoutFactory.listTypeSection()
            case .moviesWatchlist, .showsWatchlist, .favoriteMovies, .favoriteShows:
                return CollectionLayoutFactory.noHeaderMediaImageSection()
            }
        }
        return layout
    }
    
    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.dataSource?.itemIdentifier(for: indexPath)
        model.map { self.events?($0) }
    }
}
