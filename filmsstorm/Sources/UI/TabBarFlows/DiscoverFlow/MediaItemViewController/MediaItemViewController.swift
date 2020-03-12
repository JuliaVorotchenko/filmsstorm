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
    
    enum Section: Int, CaseIterable {
        case main
        case overview
        case similars
        case actors
    }
    
    // MARK: - Private properties
    
    let loadingView = ActivityView()
    let presenter: Service
    
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
        self.cellRegister()
        self.setCollectionView()
    }
    
    // MARK: - Private methods


    
   private func setupNavigationView() {
    
        self.rootView?.navigationView?.actionHandler = { [weak self] in
            self?.presenter.onBack()
        }
    let item = self.presenter.itemModel
    self.rootView?.navigationView?.titleFill(with: item.name ?? "oops")
    
    }
    
    private func cellRegister() {
        self.rootView?.collectionView.register(ImageViewCell.self)
        self.rootView?.collectionView.register(ItemDescriptionViewCell.self)
        self.rootView?.collectionView.register(ItemOverviewViewCell.self)
    }
    
    private func setCollectionView() {
        let layout = self.createLayout()
           self.rootView?.collectionView.setCollectionViewLayout(layout, animated: true)
       }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionNumber, env -> NSCollectionLayoutSection? in
            switch Section(rawValue: sectionNumber) {
            case .main:
                return self.mainSection()
            case .overview:
                return self.overviewSection()
            case .similars:
                return self.similarsSection()
            case .actors:
                return self.similarsSection()
            case .none:
               return nil
            }
        }
    }
    
    private func mainSection() -> NSCollectionLayoutSection {
        let sectionWidth = self.view.bounds.width
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(sectionWidth),
                                              heightDimension: .absolute(248))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(sectionWidth),
                                               heightDimension: .absolute(248))
        let group = NSCollectionLayoutGroup(layoutSize: groupSize)
        
        return NSCollectionLayoutSection(group: group)
    }
    
    private func overviewSection() -> NSCollectionLayoutSection {
        let sectionWidth = self.view.bounds.width
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(sectionWidth),
                                                     heightDimension: .absolute(170))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(sectionWidth),
                                               heightDimension: .absolute(248))
        let group = NSCollectionLayoutGroup(layoutSize: groupSize)
        
        return NSCollectionLayoutSection(group: group)
    }
    
    private func similarsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitem: item, count: 3)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }

}
