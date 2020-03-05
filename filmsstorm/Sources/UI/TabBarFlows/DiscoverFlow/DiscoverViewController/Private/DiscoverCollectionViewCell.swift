//
//  CollectionViewCell.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 24.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

typealias Handler<T> = (T) -> Void

enum MovieCardEvent: Equatable {
    case watchlist(DiscoverCellModel?)
    case favourites(DiscoverCellModel?)
}

struct MovieCardEventModel {
    let action: ((MovieCardEvent) -> Void)
}

struct ActionModel<Model: Equatable>: Hashable, Equatable {
    let action: Handler<Model>?
    
    func hash(into hasher: inout Hasher) { }
    
    static func == (lhs: ActionModel<Model>, rhs: ActionModel<Model>) -> Bool {
        return true
    }
}

class DiscoverCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet var imageView: UIImageView?
    
    // MARK: - Private properties
    
    private var item: DiscoverCellModel?
    private var actionHandler: Handler<MovieCardEvent>?
    private let networking = NetworkManager()
    
    // MARK: - Cell life cycle
    
    override func awakeFromNib() {
        self.setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.item = nil
    }
    
    // MARK: - Public Methods
    
    public func fill(with model: DiscoverCellModel?, onAction: ActionModel<MovieCardEvent>?) {
        self.item = model
        self.imageView?.setImage(from: model?.posterPath)
        self.actionHandler = onAction?.action
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        self.addShadow()
    }
    
    // MARK: - IBActions
    
    @IBAction func onFavorites(_ sender: UIButton) {
        print("on like")
         self.actionHandler?(.favourites(self.item))
        self.addToFavourites(self.item)
    }
    
    @IBAction func onWatchlist(_ sender: UIButton) {
        print("onfav")
        self.actionHandler?(.watchlist(self.item))
        self.addToWatchList(self.item)
    }
    
    func addToFavourites(_ item: DiscoverCellModel?) {
        guard let item = item, let id = item.id else { return }
        let model = AddFavouritesRequestModel(mediaType: item.mediaType, mediaID: id, isFavourite: true)
        self.networking.addToFavourites(with: model) { result in
            switch result {
            case .success(let response):
                print(response.statusMessage)
            case .failure(let error):
                print(error.stringDescription)
                
            }
        }
    }
    
    func addToWatchList(_ item: DiscoverCellModel?) {
        guard let item = item, let id = item.id else { return }
        let model = AddWatchListRequestModel(mediaType: item.mediaType, mediaID: id, toWatchList: true)
        self.networking.addToWatchlist(with: model) { result in
            switch result {
            case .success(let response):
                print(response.statusMessage)
            case .failure(let error):
                print(error.stringDescription)
            }
        }
    }
}
