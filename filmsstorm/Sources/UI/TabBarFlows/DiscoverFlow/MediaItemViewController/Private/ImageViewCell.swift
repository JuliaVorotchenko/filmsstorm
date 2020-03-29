//
//  ItemImageViewCell.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 10.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class ImageViewCell: UICollectionViewCell {

    @IBOutlet var itemImage: LoadingImageView?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.itemImage?.cancelLoading()
    }

    func fill(with model: ActorModel) {
        let path = model.actorImage
        self.itemImage?.loadImage(from: path)
    }
}
