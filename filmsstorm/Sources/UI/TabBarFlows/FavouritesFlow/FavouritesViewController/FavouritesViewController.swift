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
        
    // MARK: - Properties
    
    let presenter: T
    
    private lazy var dataSource = self.dataSourceProvider.createDataSource()
    
    let dataSourceProvider = FavoritesViewControllerDataSource()
    
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
        guard let rootView = self.rootView else { return }
        self.dataSourceProvider.rootView = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getMoviesWatchlist()
        self.dataSourceProvider.updateListsLabels()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.dataSourceProvider.clearDataSource()
    }
    
    // MARK: - Private methods to retrieve lists
    
    private func getMoviesWatchlist() {
        self.presenter.getMoviesWatchlist {  [weak self] model in
            self?.dataSourceProvider.update(for: .moviesWatchlist, with: model.map(FavoritesViewControllerDataSource.FavoritesContainer.media))
            self?.getShowsWatchlist()
        }
    }
    
    private func getShowsWatchlist() {
        self.presenter.getShowsWatchList {  [weak self] model in
            self?.dataSourceProvider.update(for: .showsWatchlist, with: model.map(FavoritesViewControllerDataSource.FavoritesContainer.media))
            self?.getFavoriteMovies()
        }
    }
    
    private func getFavoriteMovies() {
        self.presenter.getFavoriteMovies {  [weak self] model in
            self?.dataSourceProvider.update(for: .favoriteMovies, with: model.map(FavoritesViewControllerDataSource.FavoritesContainer.media))
            self?.getFavoriteShows()
        }
    }
    
    private func getFavoriteShows() {
        self.presenter.getFavoriteShows {  [weak self] model in
            self?.dataSourceProvider.update(for: .favoriteShows, with: model.map(FavoritesViewControllerDataSource.FavoritesContainer.media))
        }
    }
    
    // MARK: - Private Methods for CollectionView
    
    private func setCollectionView() {
        let collection = self.rootView?.collectionView
        collection?.register(MediaItemImageCell.self)
        collection?.register(ListTypeCell.self)
        collection?.setCollectionViewLayout(self.createCompositionalLayout(), animated: false)
        collection?.delegate = self
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.dataSourceProvider.dataSource?.itemIdentifier(for: indexPath)
        let presenter = self.presenter
        model.map {
            switch $0 {
            case .media(let model): presenter.onMedia(item: model)
            case .favoriteMoviesLabel: presenter.onFavoriteMovies()
            case .favoriteShowsLabel: presenter.onFavoriteSHows()
            case .moviesWatchlistLabel: presenter.onMoviesWatchList()
            case .showsWatchlistLabel: presenter.onShowsWatchlist()
                
            }
        }
    }
    
    // MARK: - Setup Layout
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            let section = FavoritesViewControllerDataSource.Section.allCases[sectionIndex]
            switch section {
            case .moviesWatchlistLabel, .showsWatchlistLabel, .favoriteMoviesLabel, .favoriteShowsLabel:
                return CollectionLayoutFactory.listTypeSection()
            case .moviesWatchlist, .showsWatchlist, .favoriteMovies, .favoriteShows:
                return CollectionLayoutFactory.noHeaderMediaImageSection()
            }
        }
        return layout
    }
}
