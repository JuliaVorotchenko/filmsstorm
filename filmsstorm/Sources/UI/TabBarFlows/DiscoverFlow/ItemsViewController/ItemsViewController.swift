//
//  MoviesViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 24.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class ItemsViewController<T: ItemsPresenter>: UIViewController, Controller, UICollectionViewDelegate {
    
    // MARK: - Subtypes
    
    typealias RootViewType = MoviesView
    typealias Service = T
    
    enum Section: CaseIterable {
        case  main
    }
    
    // MARK: - Private properties
    
    let presenter: T
    private var items = [DiscoverCellModel]()
    private var dataSource: UICollectionViewDiffableDataSource<Section, DiscoverCellModel>?
    
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
        self.setupNavigationView()
        self.setCollectionView()
        self.getPopularMovies()
    }
    
    // MARK: - Private Methods
    
    private func getPopularMovies() {
        self.presenter.getItems { [weak self] in
            self?.items = $0
            self?.createDataSource()
        }
    }
    
    private func setCollectionView() {
        let layout = CollectionLayoutFactory.standart()
        let collectionView = self.rootView?.collectionView
        collectionView?.register(DiscoverCollectionViewCell.self)
        collectionView?.delegate = self
        collectionView?.setCollectionViewLayout(layout, animated: true)
    }
    
    private func setupNavigationView() {
        self.rootView?.navigationView?.actionHandler = { [weak self] in
            self?.presenter.onBack()
        }
        self.rootView?.navigationView?.titleFill(with: self.presenter.title)
    }
        
    // MARK: - set diffableDatasource
    
    func createDataSource() {
        
        guard let collectionView = self.rootView?.collectionView else { return }
        
        self.dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self] collection, indexPath, item -> UICollectionViewCell? in
            
            let cell: DiscoverCollectionViewCell = collection.dequeueReusableCell(DiscoverCollectionViewCell.self, for: indexPath)
            cell.fill(with: item)
            return cell
        }
        let snapshot = self.createSnapshot()
        self.dataSource?.apply(snapshot)
    }
    
    func createSnapshot() -> NSDiffableDataSourceSnapshot<Section, DiscoverCellModel> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DiscoverCellModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.items)
        return snapshot
    }
    
    // MARK: - CollectionView Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.items[indexPath.row]
        self.presenter.onMedia(item: model)
    }
}
