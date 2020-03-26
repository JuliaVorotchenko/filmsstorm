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
        case actos
    }

    enum MediaItemContainer: Hashable {
        case media(MediaItemModel?)
        case similars(DiscoverCellModel)
        case actos(ActorModel)
    }
    
    // MARK: - Private properties
    
    let loadingView = ActivityView()
    let presenter: Service

    var mediaItemModel: MediaItemModel?
    var discoverCellModel: [DiscoverCellModel]?
    var actorModel: [ActorModel]?

    private var dataSource: UICollectionViewDiffableDataSource<Section, MediaItemContainer>?

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
        self.getFirst()
        self.getItemDescription()
        self.createDataSource()
    }
    
    // MARK: - Private methods

    private func getFirst() {
        self.presenter.getMovieCast { [weak self] models in
            self?.actorModel = models
            self?.updateData()
        }
    }

    private func getMovieSimilars() {
        self.presenter.getMovieSimilars { [weak self] in
            self?.discoverCellModel = $0
            self?.updateData()
        }
    }

    private func getItemDescription() {
        self.presenter.getItemDetails { [weak self] model in
            self?.mediaItemModel = model
            self?.updateData()
        }
    }

    private func setupNavigationView() {
        self.rootView?.navigationView?.actionHandler = { [weak self] in
            self?.presenter.onBack()
        }
        let item = self.presenter.itemModel
        self.rootView?.navigationView?.titleFill(with: item.name ?? "N/A")
    }

    // MARK: - Private Methods for CollectionView
    
    private func setCollectionView() {
        let collection = self.rootView?.collecionView
        collection?.register(ImageViewCell.self)
        collection?.register(DiscoverCollectionViewCell.self)
        collection?.register(ItemDescriptionViewCell.self)
        collection?.setCollectionViewLayout(self.createCompositionalLayout(), animated: false)
    }

    private func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MediaItemContainer>()
        snapshot.appendSections([.media])
        let model = self.mediaItemModel != nil
            ? self.mediaItemModel
            : MediaItemModel.from(configure: self.presenter.itemModel)
        snapshot.appendItems([.media(model)], toSection: .media)

        snapshot.appendSections([.similars])
        let similars = self.discoverCellModel?.map(MediaItemContainer.similars)
        similars.map { snapshot.appendItems($0, toSection: .similars) }

        snapshot.appendSections([.actos])
        let actors = self.actorModel?.map(MediaItemContainer.actos)
        actors.map { snapshot.appendItems($0, toSection: .actos) }

        self.dataSource?.apply(snapshot, animatingDifferences: false)
    }

    func createDataSource() {
        guard let collectionView = self.rootView?.collecionView else { return }
        self.dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collection, indexPath, item -> UICollectionViewCell? in
            switch item {
            case .media(let model):
                let cell: ItemDescriptionViewCell = collectionView.dequeueReusableCell(ItemDescriptionViewCell.self, for: indexPath)
                cell.fill(detailsModel: model, onAction: nil)
                return cell
            case .similars(let model):
                let cell: DiscoverCollectionViewCell = collectionView.dequeueReusableCell(DiscoverCollectionViewCell.self, for: indexPath)
                cell.fill(with: model)
                return cell
            case .actos(let model):
                let cell: ImageViewCell = collection.dequeueReusableCell(ImageViewCell.self, for: indexPath)
                cell.actorsFill(model: model)
                return cell
            }
        }
        self.updateData()
    }

    // MARK: - Setup Layout

    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, _) -> NSCollectionLayoutSection? in
            let section = Section.allCases[sectionIndex]
            switch section {
            case .actos:
                return self?.createWaitingChatSection()
            case .media:
                return self?.createActiveChatSection()
            case .similars:
                return self?.createWaitingChatSection()
            }
        }
        return layout
    }

    func createWaitingChatSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 8, bottom: 0, trailing: 8)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .estimated(104),
                                                     heightDimension: .estimated(88))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuous
        layoutSection.contentInsets = NSDirectionalEdgeInsets.init(top: 66, leading: 12, bottom: 0, trailing: 12)

        return layoutSection
    }

    func createActiveChatSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(86))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 8, trailing: 0)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 66, leading: 20, bottom: 0, trailing: 20)
        return section
    }

}
