//
//  ItemDescriptionViewCell.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 10.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class ItemDescriptionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet var itemImage: UIImageView!
    
    @IBOutlet var backgroundImage: UIImageView!
    
    @IBOutlet var itemName: UILabel!
    @IBOutlet var originalName: UILabel!
    
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
  
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var myListButton: UIButton!
    
    @IBOutlet var playButtonView: UIView!
    
    // MARK: - Cell life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }

    // MARK: - Methods
    
    func fill(model: DiscoverCellModel) {
        let imagePath = model.posterPath
        let backgroundPath = model.backDropPath
        self.itemImage.setImage(from: imagePath, mainPath: .mainPath)
        self.backgroundImage.setImage(from: backgroundPath, mainPath: .mainPath)
        self.itemName.text = model.name
        self.originalName.text = model.name
        self.ratingLabel.text = String("\(model.voteAverage)")
        self.yearLabel.text = "22.03.15"
    }
    
    func setupUI() {
        self.likeButton.rounded(cornerRadius: 5)
        self.likeButton.rounded(cornerRadius: 5)
        self.playButtonView.rounded(cornerRadius: 8)
    }

    
    // MARK: - IBActions
    
    @IBAction func onLike(_ sender: UIButton) {
    }
   
    @IBAction func onList(_ sender: UIButton) {
    }
   
    @IBAction func onPlay(_ sender: Any) {
    }
}
