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
}

class DiscoverViewController<T: DiscoverPresenter>: UIViewController, Controller, ActivityViewPresenter, UICollectionViewDelegate {
    
    // MARK: - Subtypes
    
    typealias RootViewType = DiscoverView
    typealias Service = T
    
    enum Section: CaseIterable {
        case  main
    }
    
    // MARK: - Private properties
    
    let loadingView = ActivityView()
    let presenter: Service
    private var sections = [DiscoverCellModel]()
    private var dataSource: UICollectionViewDiffableDataSource<Section, DiscoverCellModel>?
    
    // MARK: - Init and deinit
    
    deinit {
        self.hideActivity()
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
        self.rootView?.collectionView.register(DiscoverCollectionViewCell.self)
        self.getPopularMovies()
        self.createDataSource()
        self.setupHeader()
    }
    
    // MARK: - Private Methods
    
    private func getPopularMovies() {
        self.presenter.getPopularMovies { [weak self] value in
            self?.sections = value.map(DiscoverCellModel.create)
            self?.createDataSource()
        }
    }
    
    private func setCollectionView() {
        let layout = CollectionLayoutFactory.standart()
        self.rootView?.collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func setupHeader() {
        let model = DiscoverHeaderModel(movieButton: Constants.movieTitle, showsButton: Constants.showsTitle ) { [weak self] in self?.onHeaderEvents($0) }
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
    
    private func onCardEvent(_ event: MovieCardEvent) {
        switch event {
        case .like(let model):
            F.Log(model?.name as Any)
        case .favourites(let model):
            F.Log(model?.name as Any)
        }
    }
    
    // MARK: - set diffableDatasource
    
    func createDataSource() {
        
        guard let collectionView = self.rootView?.collectionView else { return }
        
        self.dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self ] collection, indexPath, item -> UICollectionViewCell? in
            
            let cell: DiscoverCollectionViewCell = collection.dequeueReusableCell(DiscoverCollectionViewCell.self, for: indexPath)
            cell.fill(with: item, onAction: .init { self?.onCardEvent($0)})
            return cell
        }
        let snapshot = self.createSnapshot()
        self.dataSource?.apply(snapshot)
        
    }
    
    func createSnapshot() -> NSDiffableDataSourceSnapshot<Section, DiscoverCellModel> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DiscoverCellModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.sections)
        return snapshot
    }
    
    // MARK: - CollectionView Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.sections[indexPath.row]
        self.presenter.onMedia(item: model)
    }
}
