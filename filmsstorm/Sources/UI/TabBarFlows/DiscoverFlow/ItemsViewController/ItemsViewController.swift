//
//  MoviesViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 24.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class ItemsViewController<T: ItemsPresenter>: UIViewController, Controller, ActivityViewPresenter,
UICollectionViewDelegate {
    
    // MARK: - Subtypes
    
    typealias RootViewType = MoviesView
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
        self.setupNavigationView()
        self.setCollectionView()
        self.rootView?.collectionView?.register(DiscoverCollectionViewCell.self)
        self.getPopularMovies()
        self.rootView?.collectionView?.delegate = self
    }
    
    // MARK: - Private Methods
    
    private func getPopularMovies() {
        self.presenter.getItems { [weak self] in
            self?.sections = $0
            self?.createDataSource()
        }
    }
    
    private func setCollectionView() {
        let layout = CollectionLayoutFactory.standart()
        self.rootView?.collectionView?.setCollectionViewLayout(layout, animated: true)
    }
    
    private func setupNavigationView() {
        self.rootView?.navigationView?.actionHandler = { [weak self] in
            self?.presenter.onBack()
        }
        let title = self.presenter.title
        self.rootView?.navigationView?.titleFill(with: title)
    }
    
    private func onCardEvent(_ event: MovieCardEvent) {
        switch event {
        case .watchlist(let model):
            F.Log("you moved item to watch list \(String(describing: model?.name)), \(String(describing: model?.mediaType))")
        case .favourites(let model):
            F.Log("you added to favourites \(String(describing: model?.name)), \(String(describing: model?.mediaType))")
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
