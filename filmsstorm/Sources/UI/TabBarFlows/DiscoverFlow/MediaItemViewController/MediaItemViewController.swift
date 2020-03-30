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
    
    enum Section: CaseIterable {
        case media
        case similars
        case actors
    }
    
    enum MediaItemContainer: Hashable {
        case media(MediaItemModel?)
        case similars(DiscoverCellModel)
        case actors(ActorModel)
    }
    
    // MARK: - Properties
    
    let sectionHeaderElementKind = "SectionHeaderView"
    
    let loadingView = ActivityView()
    let presenter: Service
    
    private lazy var dataSource = self.createDataSource()
    
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
        self.setCollectionView()
        self.getMovieSimilars()
        self.getItemCast()
        self.getItemDescription()
    }
    
    // MARK: - Private methods
    
    private func getItemCast() {
        self.presenter.getMovieCast { [weak self] models in
            self?.update(for: .actors, with: models.map(MediaItemContainer.actors))
        }
    }
    
    private func getMovieSimilars() {
        self.presenter.getMovieSimilars { [weak self] in
            self?.update(for: .similars, with: $0.map(MediaItemContainer.similars))
        }
    }
    
    private func getItemDescription() {
        self.presenter.getItemDetails { [weak self] model in
            self?.update(for: .media, with: [.media(model)])
        }
    }
    
    private func setupNavigationView() {
        self.rootView?.navigationView?.actionHandler = { [weak self] in
            self?.presenter.onBack()
        }
        let item = self.presenter.itemModel
        self.rootView?.navigationView?.titleFill(with: item.name ?? "N/A")
    }
    
    private func onCardEvent(_ event: ItemDescriptionEvent) {
        switch event {
        case .watchlist(let model):
            self.presenter.addToWatchList(model)
            F.Log("you added to watch list \(String(describing: model?.name)), \(String(describing: model?.mediaType))")
        case .favourites(let model):
            self.presenter.addToFavourites(model)
            F.Log("you added to favourites \(String(describing: model?.name)), \(String(describing: model?.mediaType))")
        }
    }
    
    // MARK: - Private Methods for CollectionView
    
    private func setCollectionView() {
        let collection = self.rootView?.collecionView
        collection?.register(MediaItemImageCell.self)
        collection?.register(ItemDescriptionViewCell.self)
        collection?.registerHeader(SectionHeaderView.self)
        collection?.setCollectionViewLayout(self.createCompositionalLayout(), animated: false)
    }
    
    private func update(for section: Section, with items: [MediaItemContainer]) {
        var snapshot = self.dataSource?.snapshot()
        snapshot?.appendItems(items, toSection: section)
        snapshot.map { self.dataSource?.apply($0, animatingDifferences: false)}
    }
    
    func createDataSource() -> UICollectionViewDiffableDataSource<Section, MediaItemContainer>? {
        let dataSource: UICollectionViewDiffableDataSource<Section, MediaItemContainer>? =
            self.rootView?.collecionView
                .map { collectionView in UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell in
                    
                    switch item {
                    case .media(let model):
                        let cell: ItemDescriptionViewCell = collectionView.dequeueReusableCell(ItemDescriptionViewCell.self,
                                                                                               for: indexPath)
                        cell.fill(detailsModel: model, onAction: .init { self.onCardEvent($0) })
                        return cell
                        
                    case .similars(let model):
                        let cell: MediaItemImageCell = collectionView.dequeueReusableCell(MediaItemImageCell.self,
                                                                                          for: indexPath)
                        cell.similarsFill(model: model)
                        return cell
                        
                    case .actors(let model):
                        let cell: MediaItemImageCell = collectionView.dequeueReusableCell(MediaItemImageCell.self,
                                                                                          for: indexPath)
                        cell.actorsFill(model: model)
                        return cell
                    }
                    }
                    
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, MediaItemContainer>()
        snapshot.appendSections(Section.allCases)
        Section.allCases.forEach { snapshot.appendItems([], toSection: $0)}
        
        dataSource?.supplementaryViewProvider = { [weak self] in self?.supplementaryViewProvider(collectionView: $0,
                                                                                                 kind: $1,
                                                                                                 indexPath: $2) }
        dataSource?.apply(snapshot, animatingDifferences: false)
        
        return dataSource
    }
    
    private func supplementaryViewProvider(collectionView: UICollectionView,
                                           kind: String,
                                           indexPath: IndexPath) -> UICollectionReusableView? {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier,
            for: indexPath) as? SectionHeaderView
        
        switch Section.allCases[indexPath.section] {
        case .actors:
            header?.fill(with: "Actors")
        case .similars:
            header?.fill(with: "Similars")
        case .media:
            break
        }
        
        return header
    }
    
    // MARK: - Setup Layout
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, _) -> NSCollectionLayoutSection? in
            let section = Section.allCases[sectionIndex]
            switch section {
            case .actors:
                return CollectionLayoutFactory.mediaItemImagesSections()
            case .media:
                return CollectionLayoutFactory.mediaItemDescriptionSection()
            case .similars:
                return CollectionLayoutFactory.mediaItemImagesSections()
            }
        }
        return layout
    }
}
