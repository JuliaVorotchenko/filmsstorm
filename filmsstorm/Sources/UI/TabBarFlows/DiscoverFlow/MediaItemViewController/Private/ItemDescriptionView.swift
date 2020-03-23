//
//  ItemDescriptionViewCell.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 10.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

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

class ItemDescriptionView: NibDesignableImpl {
    
    // MARK: - IBOutlets
    
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var itemImage: UIImageView!
    @IBOutlet var itemName: UILabel!
    @IBOutlet var originalName: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var likeButton: AnimatedButton!
    @IBOutlet var listButton: AnimatedButton!
    @IBOutlet var playButton: AnimatedButton!
    @IBOutlet var playButtonView: UIView!
    @IBOutlet var overviewLabel: UILabel!
    @IBOutlet var overviewContainer: UIView!
    
    // MARK: - Private properties
    
    private var itemDetails: MediaItemModel?
    private var item: DiscoverCellModel?
    private var actionHandler: Handler<MovieCardEvent>?
    private var isTapped: Bool = false
    
    // MARK: - Cell life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    // MARK: - Methods
    
    func fill(detailsModel: MediaItemModel, requestModel: DiscoverCellModel?, onAction: ActionModel<MovieCardEvent>?) {
        self.actionHandler = onAction?.action
        self.item = requestModel
        
        self.itemDetails = detailsModel
        self.itemImage.setImage(from: detailsModel.poster)
        self.backgroundImage.setImage(from: detailsModel.background)
        self.itemName.text = detailsModel.name
        self.originalName.text = detailsModel.originalName
        self.genreLabel.text = detailsModel.genre.map { $0.name }.prefix(2).joined(separator: ", ")
        self.ratingLabel.text = String("\(detailsModel.rating)")
        self.yearLabel.text = detailsModel.releaseDate
        self.overviewLabel.text = detailsModel.overview
    }
    
    func setupUI() {
        self.overviewLabel.font = UIFont(name: "Abel-Regular", size: 14)
        self.overviewLabel.sizeToFit()
        self.overviewContainer.sizeToFit()
        self.likeButton.rounded(cornerRadius: 5)
        self.listButton.rounded(cornerRadius: 5)
        self.playButtonView.rounded(cornerRadius: 8)
        self.itemImage.rounded(cornerRadius: 5)
    }
    
    // MARK: - IBActions
    
    @IBAction func onList(_ sender: UIButton) {
        self.isTapped = !self.isTapped
        if self.isTapped {
            self.listButton.setImage(UIImage(named: "watchlisted"), for: .normal)
            self.listButton.likeBounce(0.5)
        } else {
            self.listButton.setImage(UIImage(named: "watchlist"), for: .normal)
            self.listButton.unLikeBounce(0.3)
        }
        self.actionHandler?(.watchlist(self.item))
    }
    
    @IBAction func onPlay(_ sender: UIButton) {
    }
    
    @IBAction func onLike(_ sender: UIButton) {
        self.isTapped = !self.isTapped
        if self.isTapped {
            self.likeButton.setImage(UIImage(named: "liked"), for: .normal)
            self.likeButton.likeBounce(0.5)
        } else {
            self.likeButton.unLikeBounce(0.3)
            self.likeButton.setImage(UIImage(named: "like"), for: .normal)
        }
        
        self.actionHandler?(.favourites(self.item))
    }
}
