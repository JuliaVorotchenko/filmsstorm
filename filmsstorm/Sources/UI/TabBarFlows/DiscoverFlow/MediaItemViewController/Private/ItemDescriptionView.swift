//
//  ItemDescriptionViewCell.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 10.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

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
       
    private var item: MediaItemModel?
        
    // MARK: - Cell life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }

    // MARK: - Methods
    
    func fill(model: MediaItemModel) {
        self.item = model
        self.itemImage.setImage(from: model.poster)
        self.backgroundImage.setImage(from: model.background)
        self.itemName.text = model.name
        self.originalName.text = model.originalName
        self.genreLabel.text = model.genre.map { $0.name }.prefix(2).joined(separator: ", ")
        self.ratingLabel.text = String("\(model.rating)")
        self.yearLabel.text = model.releaseDate
        self.overviewLabel.text = model.overview
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
    }
    @IBAction func onPlay(_ sender: UIButton) {
    }
    @IBAction func onLike(_ sender: UIButton) {
    }
}
