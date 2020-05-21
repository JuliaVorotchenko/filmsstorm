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

class DiscoverViewController<T: DiscoverPresenter>: UIViewController, Controller {
    
    // MARK: - Subtypes
    
    typealias RootViewType = DiscoverView
    typealias Service = T
    typealias DataSource = DiscoverCollectionViewProvider
   
    // MARK: - Private properties
    
    let presenter: T
    private lazy var dataSource = self.rootView?.collectionView
        .map { DataSource(collectionView: $0) { [weak self] in self?.bindAction(model: $0) }}
    
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
        self.getPopularMovies()
        self.setupHeader()
    }
    
    // MARK: - Private Methods
    
    private func getPopularMovies() {
        self.presenter.getPopularMovies { [weak self] value in
            let items = value.map { DiscoverCellModel.create($0)}
            self?.dataSource?.update(with: items)
        }
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
    
    func bindAction(model: DiscoverCellModel) {
        self.presenter.onMedia(item: model)
    }
}
