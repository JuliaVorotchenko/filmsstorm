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
       
    private var item: DiscoverCellModel?
    
    
    // MARK: - Cell life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }

    // MARK: - Methods
    
    func fill(model: DiscoverCellModel) {
        self.item = model
        self.itemImage.setImage(from: model.posterPath)
        self.backgroundImage.setImage(from: model.backDropPath)
        self.itemName.text = model.name
        self.originalName.text = model.name
        self.ratingLabel.text = String("\(model.voteAverage)")
        self.yearLabel.text = "22.03.15"
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
        self.itemImage.addShadow(color: .white, opacity: 0.3)
    }

    // MARK: - IBActions
    
    @IBAction func onList(_ sender: UIButton) {
    }
    @IBAction func onPlay(_ sender: UIButton) {
    }
    @IBAction func onLike(_ sender: UIButton) {
    }
}
