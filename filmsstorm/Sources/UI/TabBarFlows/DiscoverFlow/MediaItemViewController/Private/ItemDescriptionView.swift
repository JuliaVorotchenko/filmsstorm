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
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var listButton: UIButton!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var playButtonView: UIView!
    @IBOutlet var overviewLabel: UILabel!
    @IBOutlet var overviewContainer: UIView!
    
    // MARK: - Private properties
       
    private var itemDetails: MediaItemModel?
    private var item: DiscoverCellModel?
    private var actionHandler: Handler<MovieCardEvent>?
        
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
         self.actionHandler?(.watchlist(self.item))
    }
    @IBAction func onPlay(_ sender: UIButton) {
    }
    @IBAction func onLike(_ sender: UIButton) {
          self.actionHandler?(.favourites(self.item))
    }
}
