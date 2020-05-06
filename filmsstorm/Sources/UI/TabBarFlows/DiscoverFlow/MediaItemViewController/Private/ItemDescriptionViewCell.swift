//
//  ItemDescriptionViewCell.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 10.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

enum ItemDescriptionEvent: Equatable {
    case watchlist(MediaItemModel?, isWatchlisted: Bool)
    case favourites(MediaItemModel?, isLiked: Bool)
    case play(MediaItemModel?)
}

struct ItemDescriptionEventModel {
    let action: ((ItemDescriptionEvent) -> Void)
}

struct ActionModel<Model: Equatable>: Hashable, Equatable {
    let action: Handler<Model>?
    
    func hash(into hasher: inout Hasher) { }
    
    static func == (lhs: ActionModel<Model>, rhs: ActionModel<Model>) -> Bool {
        return true
    }
}

class ItemDescriptionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet var backgroundImage: LoadingImageView?
    @IBOutlet var itemImage: LoadingImageView?
    @IBOutlet var itemName: UILabel?
    @IBOutlet var originalName: UILabel?
    @IBOutlet var genreLabel: UILabel?
    @IBOutlet var yearLabel: UILabel?
    @IBOutlet var ratingLabel: UILabel?
    @IBOutlet var likeButton: AnimatedButton?
    @IBOutlet var listButton: AnimatedButton?
    @IBOutlet var playButton: UIButton?
    @IBOutlet var playButtonView: UIView?
    @IBOutlet var overviewLabel: UILabel?
    @IBOutlet var overviewContainer: UIView?
    
    // MARK: - Private properties
    
    private var item: MediaItemModel?
    private var actionHandler: Handler<ItemDescriptionEvent>?
    private var likeIsTapped = false
    private var listIsTapped = false
    
    // MARK: - Cell life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.reset()
    }
    
    // MARK: - Methods
    
    func fill(detailsModel: MediaItemModel?, onAction: ActionModel<ItemDescriptionEvent>?) {
        self.actionHandler = onAction?.action
        self.item = detailsModel
        self.likeIsTapped = detailsModel?.isLiked ?? false
        self.listIsTapped = detailsModel?.isWatchListed ?? false
        self.likeButton?.backgroundColor = detailsModel?.isLiked == true ? .green : .clear
        self.listButton?.backgroundColor = detailsModel?.isWatchListed == true ? .green : .clear
        self.itemImage?.loadImage(from: detailsModel?.posterImage, mainPath: Path(rawValue: Path.mainPath))
        self.backgroundImage?.loadImage(from: detailsModel?.backgroundImage, mainPath: Path(rawValue: Path.mainPath))
        self.itemName?.text = detailsModel?.name
        self.originalName?.text = detailsModel?.originalName
        self.genreLabel?.text = detailsModel?.genre.map { $0.name }.shuffled().prefix(2).joined(separator: ", ")
        self.ratingLabel?.text = detailsModel?.voteAverage.map { "\($0)" }
        self.yearLabel?.text = detailsModel?.releaseDate
        self.overviewLabel?.text = detailsModel?.overview
    }
    
    private func setupUI() {
        self.overviewLabel?.font = UIFont(name: "Abel-Regular", size: 14)
        self.overviewLabel?.sizeToFit()
        self.overviewContainer?.sizeToFit()
        self.likeButton?.rounded(cornerRadius: 5)
        self.listButton?.rounded(cornerRadius: 5)
        self.playButtonView?.rounded(cornerRadius: 8)
        self.itemImage?.rounded(cornerRadius: 5)
    }
    
    func onLikeAnimation(isLiked: Bool) {
        self.likeButton?.likeBounce(0.5)
        self.likeButton?.backgroundColor = isLiked ? .green : .clear
    }
    
    func onListAnimation(isWatchlisted: Bool) {
        self.listButton?.likeBounce(0.5)
        self.listButton?.backgroundColor = isWatchlisted ? .green : .clear
    }
    
    private func reset() {
        self.itemImage?.cancelLoading()
        self.item = nil
        self.actionHandler = nil
        self.likeIsTapped = false
        self.listIsTapped = false
    }
    
    // MARK: - IBActions
    
    @IBAction func onList(_ sender: UIButton) {
        self.listIsTapped = !self.listIsTapped
        self.onListAnimation(isWatchlisted: self.listIsTapped)
        self.actionHandler?(.watchlist(self.item, isWatchlisted: self.listIsTapped))
    }
    
    @IBAction func onPlay(_ sender: UIButton) {
        self.actionHandler?(.play(self.item))
    }
    
    @IBAction func onLike(_ sender: UIButton) {
        self.likeIsTapped = !self.likeIsTapped
        self.onLikeAnimation(isLiked: self.likeIsTapped)
        self.actionHandler?(.favourites(self.item, isLiked: self.likeIsTapped))
    }
}
