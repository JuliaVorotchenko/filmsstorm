//
//  FavouritesViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 25.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

final class FavouritesViewController<T: FavouritesPresenter>: UIViewController, Controller {
    
    // MARK: - Subtypes
    
    typealias RootViewType = FavouritesView
    typealias Service = T
    typealias DataSource = FavoritesCollectionViewProvider
    
    // MARK: - Properties
    
    let presenter: T
    private lazy var dataSource = self.rootView?
        .collectionView
        .map { DataSource(collectionView: $0) { [weak self] in self?.bindAcions($0) }}
    
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
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getMoviesWatchlist()
        self.dataSource?.updateListsLabels()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.dataSource?.clearDataSource()
    }
    
    // MARK: - Private methods to retrieve lists
    
    private func getMoviesWatchlist() {
        self.presenter.getMoviesWatchlist {  [weak self] model in
            self?.dataSource?.update(for: .moviesWatchlist, with: model.map(FavoritesCollectionViewProvider.FavoritesContainer.media))
            self?.getShowsWatchlist()
        }
    }
    
    private func getShowsWatchlist() {
        self.presenter.getShowsWatchList {  [weak self] model in
            self?.dataSource?.update(for: .showsWatchlist, with: model.map(FavoritesCollectionViewProvider.FavoritesContainer.media))
            self?.getFavoriteMovies()
        }
    }
    
    private func getFavoriteMovies() {
        self.presenter.getFavoriteMovies {  [weak self] model in
            self?.dataSource?.update(for: .favoriteMovies, with: model.map(FavoritesCollectionViewProvider.FavoritesContainer.media))
            self?.getFavoriteShows()
        }
    }
    
    private func getFavoriteShows() {
        self.presenter.getFavoriteShows {  [weak self] model in
            self?.dataSource?.update(for: .favoriteShows, with: model.map(FavoritesCollectionViewProvider.FavoritesContainer.media))
        }
    }
    
    private func bindAcions(_ events: DataSource.FavoritesContainer) {
        print(#function)
        
        switch events {
        case .media(let model): self.presenter.onMedia(item: model)
        case .favoriteMoviesLabel: self.presenter.onFavoriteMovies()
        case .favoriteShowsLabel: self.presenter.onFavoriteShows()
        case .moviesWatchlistLabel: self.presenter.onMoviesWatchList()
        case .showsWatchlistLabel: self.presenter.onShowsWatchlist()
        }
    }
}
