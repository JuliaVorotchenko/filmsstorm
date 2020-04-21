//
//  FavouritesViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 25.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class FavouritesViewController<T: FavouritesPresenter>: UIViewController, Controller, UICollectionViewDelegate {
    
    // MARK: - Subtypes
    
    typealias RootViewType = FavouritesView
    typealias Service = T
    
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
    
    // MARK: - Properties
    
    let loadingView = ActivityView()
    let presenter: T
    
    private lazy var dataSource = self.createDataSource()
    
    // MARK: - Init and deinit
    
    deinit {
        F.Log(F.toString(Self.self))
    }
    
    required init(_ presentation: Service) {
        self.presenter = presentation
        super.init(nibName: F.nibNamefor(Self.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCollectionView()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.dataSourceCleanOut()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.updateListsLabels()
        
        defer {
            self.getFavoriteShows()
        }
        
        defer {
            self.getFavoriteMovies()
        }
        
        defer {
            self.getMoviesWatchlist()
        }
        
        do {
            self.getShowsWatchlist()
        }
    }
    
    // MARK: - Private methods to retrieve lists
    
    private func getMoviesWatchlist() {
        self.presenter.getMoviesWatchlist {  [weak self] model in
            self?.update(for: .moviesWatchlist, with: model.map(FavoritesContainer.media))
        }
    }
    
    private func getShowsWatchlist() {
        self.presenter.getShowsWatchList {  [weak self] model in
            self?.update(for: .showsWatchlist, with: model.map(FavoritesContainer.media))
        }
    }
    
    private func getFavoriteMovies() {
        self.presenter.getFavoriteMovies {  [weak self] model in
            self?.update(for: .favoriteMovies, with: model.map(FavoritesContainer.media))
        }
    }
    
    private func getFavoriteShows() {
        self.presenter.getFavoriteShows {  [weak self] model in
            self?.update(for: .favoriteShows, with: model.map(FavoritesContainer.media))
        }
    }
    
    private func updateListsLabels() {
        self.update(for: .favoriteMoviesLabel, with: [FavoritesContainer.favoriteMoviesLabel])
        self.update(for: .favoriteShowsLabel, with: [FavoritesContainer.favoriteShowsLabel])
        self.update(for: .moviesWatchlistLabel, with: [FavoritesContainer.moviesWatchlistLabel])
        self.update(for: .showsWatchlistLabel, with: [FavoritesContainer.showsWatchlistLabel])
    }
    
    // MARK: - Private Methods for CollectionView
    
    private func setCollectionView() {
        let collection = self.rootView?.collectionView
        collection?.register(MediaItemImageCell.self)
        collection?.register(ListTypeCell.self)
        collection?.setCollectionViewLayout(self.createCompositionalLayout(), animated: false)
        collection?.delegate = self
    }
    
    private func update(for section: Section, with items: [FavoritesContainer]) {
        var snapshot = self.dataSource?.snapshot()
        snapshot?.appendItems(items, toSection: section)
        snapshot.map { self.dataSource?.apply($0, animatingDifferences: false)}
    }
    
    private func dataSourceCleanOut() {
        let items = [FavoritesContainer]()
        var snapshot = NSDiffableDataSourceSnapshot<Section, FavoritesContainer>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(items)
        self.dataSource?.apply(snapshot, animatingDifferences: false)
    }

    func createDataSource() -> UICollectionViewDiffableDataSource<Section, FavoritesContainer>? {
        let dataSource: UICollectionViewDiffableDataSource<Section, FavoritesContainer>? =
            self.rootView?.collectionView
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.dataSource?.itemIdentifier(for: indexPath)
        model.map {
            switch $0 {
            case .media(let model):
                self.presenter.onMedia(item: model)
            case .favoriteMoviesLabel, .favoriteShowsLabel, .moviesWatchlistLabel, .showsWatchlistLabel:
                print("on header")
            }
        }
    }
    
    // MARK: - Setup Layout
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            let section = Section.allCases[sectionIndex]
            switch section {
            case .moviesWatchlistLabel:
                return CollectionLayoutFactory.listTypeSection()
            case .moviesWatchlist:
                return CollectionLayoutFactory.noHeaderMediaImageSection()
            case .showsWatchlistLabel:
                return CollectionLayoutFactory.listTypeSection()
            case .showsWatchlist:
                return CollectionLayoutFactory.noHeaderMediaImageSection()
            case .favoriteMoviesLabel:
                return CollectionLayoutFactory.listTypeSection()
            case .favoriteMovies:
                return CollectionLayoutFactory.noHeaderMediaImageSection()
            case .favoriteShowsLabel:
                return CollectionLayoutFactory.listTypeSection()
            case .favoriteShows:
                return CollectionLayoutFactory.noHeaderMediaImageSection()
            }
        }
        return layout
    }
}
