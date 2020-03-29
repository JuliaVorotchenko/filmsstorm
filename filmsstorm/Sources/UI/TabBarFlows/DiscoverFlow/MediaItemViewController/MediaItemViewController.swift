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
        case actor
    }

    enum MediaItemContainer: Hashable {
        case media(MediaItemModel?)
        case similars(DiscoverCellModel)
        case actor(ActorModel)
    }
    
    // MARK: - Private properties
    
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
        self.getItemDescription()
        self.getMovieSimilars()
        self.getMovieCast()
    }
    
    // MARK: - Private methods

    private func getMovieCast() {
        self.presenter.getMovieCast { [weak self] models in
            self?.update(for: .actor, with: models.map(MediaItemContainer.actor))
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

    // MARK: - Private Methods
    
    private func setCollectionView() {
        let collection = self.rootView?.collectionView
        collection?.register(ImageViewCell.self)
        collection?.register(DiscoverCollectionViewCell.self)
        collection?.register(ItemDescriptionViewCell.self)
        collection?.registerHeader(SectionHeaderView.self)
        collection?.setCollectionViewLayout(self.createCompositionalLayout(), animated: false)
    }

    private func update(for section: Section, with items: [MediaItemContainer]) {
        var snapshot = self.dataSource?.snapshot()
        snapshot?.appendItems(items, toSection: section)
        snapshot.map { self.dataSource?.apply($0, animatingDifferences: false) }
    }

    func createDataSource() -> UICollectionViewDiffableDataSource<Section, MediaItemContainer>? {
        let dataSource: UICollectionViewDiffableDataSource<Section, MediaItemContainer>? = self.rootView?.collectionView
            .map { collectionView in UICollectionViewDiffableDataSource(collectionView: collectionView) { collection, indexPath, item -> UICollectionViewCell? in
                switch item {
                case .media(let model):
                    let cell: ItemDescriptionViewCell = collectionView.dequeueReusableCell(ItemDescriptionViewCell.self, for: indexPath)
                    cell.fill(detailsModel: model, onAction: nil)
                    return cell
                case .similars(let model):
                    let cell: DiscoverCollectionViewCell = collectionView.dequeueReusableCell(DiscoverCollectionViewCell.self, for: indexPath)
                    cell.fill(with: model)
                    return cell
                case .actor(let model):
                    let cell: ImageViewCell = collection.dequeueReusableCell(ImageViewCell.self, for: indexPath)
                    cell.fill(with: model)
                    return cell
                }
                }
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, MediaItemContainer>()
        snapshot.appendSections(Section.allCases)
        Section.allCases.forEach { snapshot.appendItems([], toSection: $0) }

        dataSource?.supplementaryViewProvider = { [weak self] in self?.supplementaryView(collectionView: $0, kind: $1, indexPath: $2) }
        dataSource?.apply(snapshot, animatingDifferences: false)

        return dataSource
    }

    private func supplementaryView(collectionView: UICollectionView,
                                   kind: String,
                                   indexPath: IndexPath) -> UICollectionReusableView? {

        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: F.toString(SectionHeaderView.self),
                                                                     for: indexPath) as? SectionHeaderView

        switch Section.allCases[indexPath.section] {
        case .actor:
            header?.fill(from: "Actors")
        case .similars:
            header?.fill(from: "Similars")
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
            case .actor:
                return self?.createItemImageSection()
            case .media:
                return self?.createMediaSection()
            case .similars:
                return self?.createItemImageSection()
            }
        }
        return layout
    }

    func createItemImageSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(128),
                                              heightDimension: .absolute(190))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(222))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(14)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 8, leading: 14, bottom: 15, trailing: 0)
        section.interGroupSpacing = 14
        section.orthogonalScrollingBehavior = .continuous

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(20))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: F.toString(SectionHeaderView.self), alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }

    func createMediaSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(320))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 8, trailing: 0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }

}
