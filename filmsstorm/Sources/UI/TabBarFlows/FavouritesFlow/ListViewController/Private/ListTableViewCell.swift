//
//  ListTableViewCell.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 30.04.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

     // MARK: - IBOutlets
    
    @IBOutlet weak var backgroundImage: LoadingImageView!
    @IBOutlet weak var mediaImage: LoadingImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var originalName: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var overview: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: -4, bottom: 4, right: 0))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.backgroundImage.image = nil
        self.backgroundImage.cancelLoading()
        self.mediaImage.image = nil
        self.mediaImage.cancelLoading()
    }
    
    // MARK: - Methods

    public func fill(with model: DiscoverCellModel?) {
        self.backgroundImage.loadImage(from: model?.backgroundImage, mainPath: Path(rawValue: Path.qualityPath))
        self.mediaImage.loadImage(from: model?.posterImage, mainPath: Path(rawValue: Path.qualityPath))
        self.itemName.text = model?.name
        self.originalName.text = model?.originalName
        self.releaseDate.text = model?.releaseDate
        self.rating.text = model?.voteAverage.map { "\($0)" }
        self.overview.text = model?.overview
    }
}
