//
//  MediaItemViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 25.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class MediaItemViewController<T: MediaItemPresenter>: UIViewController, Controller, ActivityViewPresenter, UICollectionViewDelegate {
    
    // MARK: - Subtypes
    
    typealias RootViewType = MediaItemView
    typealias Service = T
    
    enum Section {
        case main
    }
    
    // MARK: - Private properties
    
    let loadingView = ActivityView()
    let presenter: Service
    
    private var sectionsSimilars = [DiscoverCellModel]()
    private var sectionsActors = [ActorModel]()
    private var actors = [ActorModel]()
    private var similars = [DiscoverCellModel]()
    
    private var similarsDataSource: UICollectionViewDiffableDataSource<Section, DiscoverCellModel>?
    private var actorsDataSource: UICollectionViewDiffableDataSource<Section, ActorModel>?
    
    
    var itemDetails: MediaItemModel?
    
    // MARK: - Init and deinit
    
    deinit {
        self.hideActivity()
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
        self.setupNavigationView()
        self.getItemDetails()
        self.getActors()
        self.configureSimilarsDataSource()
        self.configureActorsDataSource()
        self.setCollectionView()
    }
    
    // MARK: - Private methods
    
    private func getItemDetails() {
        
        let item = self.presenter.itemModel
        
        self.presenter.getItemDetails { [weak self] model in
            self?.rootView?.descriptionView.fill(detailsModel: model, requestModel: item, onAction: .init {
                self?.onCardEvent($0)})
        }
    }
    
    private func getActors() {
        self.presenter.getItemCast {  [weak self] model in
            self?.actors = model
        }
    }
    
    private func getSimilars() {
        print(#function)
        self.presenter.getItemSimilars { [weak self] model in
            self?.similars = model
        }
    }
    
    private func setupNavigationView() {
        self.rootView?.navigationView?.actionHandler = { [weak self] in
            self?.presenter.onBack()
        }
        let item = self.presenter.itemModel
        self.rootView?.navigationView?.titleFill(with: item.name ?? "oops")
    }
    
    private func onCardEvent(_ event: ItemDescriptionEvent) {
        switch event {
        case .watchlist(let model):
            self.presenter.addToWatchList(model)
            self.rootView?.descriptionView.watchlistedSuccsessfully()
        case .favourites(let model):
            self.presenter.addToFavourites(model)
            self.rootView?.descriptionView.likedSuccessfully()
        }
    }
    
    
    // MARK: - Private Methods for CollectionView
  
    private func setCollectionView() {
        let layout = self.createLayout()
        self.rootView?.similarsCollection.setCollectionViewLayout(layout, animated: true)
        self.rootView?.actorsCollection.setCollectionViewLayout(layout, animated: true)
        self.rootView?.similarsCollection.delegate = self
        self.rootView?.actorsCollection.delegate = self
        self.rootView?.similarsCollection.register(ImageViewCell.self)
        self.rootView?.actorsCollection.register(ImageViewCell.self)
    }
        
    private func sectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item, count: 3)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(15.0))
//        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
//                                                                 elementKind: "sectionHeader",
//                                                                 alignment: .top)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        //section.boundarySupplementaryItems = [header]
        return section
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 16
        return UICollectionViewCompositionalLayout(section: sectionLayout(), configuration: config)
    }
    
    private func configureSimilarsDataSource() {
        guard let collectionView = self.rootView?.similarsCollection else { return }
        
        self.similarsDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self] collection, indexPath, item -> UICollectionViewCell? in
            let cell: ImageViewCell = collection.dequeueReusableCell(ImageViewCell.self, for: indexPath)
            cell.similarsFill(model: item)
            return cell
        }
        let snapshot = self.createSimilarsSnapshot()
        self.similarsDataSource?.apply(snapshot)
        
    }
    
    private func configureActorsDataSource() {
        guard let collectionView = self.rootView?.actorsCollection else { return }
        
        self.actorsDataSource =  UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self] collection, indexPath, item -> UICollectionViewCell? in
            
            let cell: ImageViewCell = collection.dequeueReusableCell(ImageViewCell.self, for: indexPath)
            cell.actorsFill(model: item)
            return cell
        }
    }
    
    private func createSimilarsSnapshot() -> NSDiffableDataSourceSnapshot<Section, DiscoverCellModel> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DiscoverCellModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.sectionsSimilars)
        
        return snapshot
    }
    
    private func createdActorsSnapshot() -> NSDiffableDataSourceSnapshot<Section, ActorModel> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ActorModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.sectionsActors)
        
        return snapshot
    }
}
