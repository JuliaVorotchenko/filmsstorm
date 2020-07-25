//
//  MediaItemViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 25.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit
import AVKit

class MediaItemViewController<T: MediaItemPresenter>: UIViewController, Controller, UICollectionViewDelegate {
    
    // MARK: - Subtypes
    
    typealias RootViewType = MediaItemView
    typealias Service = T
    typealias DataSource = MediaItemCollectionViewProvider
    
    // MARK: - Properties
    
    let presenter: Service
    
    private lazy var dataSource = self.rootView?
        .collectionView
        .map { DataSource(collectionView: $0, events: { [weak self] event  in self?.bindActions(event) },
                          itemDescrEvents: { [weak self] event in self?.onItemDescriptionEvent(event) })}
    
    // MARK: - Init and deinit
    
    deinit {
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
    
    override func loadView() {
        super.loadView()
        //self.presenter.getLists()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationView()
        self.getItemDescription()
        self.getMovieSimilars()
        self.getItemCast()
    }
    
    // MARK: - Private methods
    
    private func getItemDescription() {
        self.presenter.getItemDetails { [weak self] model in
            self?.dataSource?.update(for: .media, with: [.media(model)])
        }
    }
    
    private func getItemCast() {
        self.presenter.getItemCast { [weak self] models in
            self?.dataSource?.update(for: .actors, with: models.map(DataSource.MediaItemContainer.actors))
        }
    }
    
    private func getMovieSimilars() {
        self.presenter.getItemSimilars { [weak self] in
            self?.dataSource?.update(for: .similars, with: $0.map(DataSource.MediaItemContainer.similars))
        }
    }
    
    private func setupNavigationView() {
        self.rootView?.navigationView?.actionHandler = { [weak self] in
            self?.presenter.onBack()
        }
        let item = self.presenter.itemModel
        self.rootView?.navigationView?.titleFill(with: item.name ?? "N/A")
    }
    
    private func onItemDescriptionEvent(_ event: DataSource.ItemDescriptionEvent) {
        switch event {
        case .watchlist(let model, let state):
            model.map { self.presenter.updateWatchlist(for: $0, isWatchlisted: state) }
        case .favourites(let model, let state):
            model.map { self.presenter.updateFavorites(for: $0, isFavorite: state) }
        case .play(let model):
            model.map(self.presenter.onPlay)
        }
    }
    
    private func bindActions(_ events: DataSource.MediaItemContainer) {
        switch events {
        case .actors(let model): self.presenter.onActor(actor: model)
        case .media(let model): self.presenter.onPlay(item: model!)
        case .similars(let model): self.presenter.onSimilarsItem(with: model)
        }
    }
}
