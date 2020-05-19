//
//  SessionIDViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 29.12.2019.
//  Copyright © 2019 Alexander Andriushchenko. All rights reserved.
//

import UIKit

struct Constants {
    static let movieTitle = "Movies"
    static let showsTitle = "TVShows"
    static let favoriteMovies = "Favorite Movies"
    static let favoriteShows = "Favorite TVShows"
    static let moviesWachlist = "Movie List"
    static let showsWatchlist = "TVShows List"
    static let signUpURL = "https://www.themoviedb.org/account/signup"
}

class DiscoverViewController<T: DiscoverPresenter>: UIViewController, Controller, UICollectionViewDelegate {
    
    // MARK: - Subtypes
    
    typealias RootViewType = DiscoverView
    typealias Service = T
    
    enum Section: CaseIterable {
        case  main
    }
    
    // MARK: - Private properties
    
    let presenter: T
    private let dataSourceProvider = DiscoverViewControllerDataSourceProvider()
    
    // MARK: - Init and deinit
    
    deinit {
        F.Log(F.toString(Self.self))
    }
    
    required init(_ presenter: Service) {
        self.presenter = presenter
        super.init(nibName: F.nibNamefor(Self.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCollectionView()
        self.getPopularMovies()
        self.setupHeader()
        self.dataSourceProvider.createDataSource(rootView: self.rootView)
    }
    
    // MARK: - Private Methods
    
    private func getPopularMovies() {
        self.presenter.getPopularMovies { [weak self] value in
            self?.dataSourceProvider.items = value.map(DiscoverCellModel.create)
            self?.dataSourceProvider.createDataSource(rootView: self?.rootView)
        }
    }
    
    private func setCollectionView() {
        self.rootView?.collectionView.delegate = self
        self.rootView?.collectionView.register(DiscoverCollectionViewCell.self)
        let layout = CollectionLayoutFactory.standart()
        self.rootView?.collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func setupHeader() {
        let model = DiscoverHeaderModel(movieButton: Constants.movieTitle, showsButton: Constants.showsTitle ) { [weak self] in
            self?.onHeaderEvents($0) }
        self.rootView?.headerView.fill(with: model)
    }
    
    private func onHeaderEvents(_ event: DiscoverHeaderEvent) {
        switch event {
        case .onSearch:
            self.presenter.onSearch()
        case .onShows:
            self.presenter.onShows()
        case .onMovies:
            self.presenter.onMovies()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.dataSourceProvider.items[indexPath.row]
        self.presenter.onMedia(item: model)
    }
}
