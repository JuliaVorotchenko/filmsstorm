//
//  ItemImageViewCell.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 10.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class ImageViewCell: UICollectionViewCell {
  
    @IBOutlet var itemImage: UIImageView!
    
    func fill(model: DiscoverCellModel) {
        let path = model.posterPath
        self.itemImage.setImage(from: path, mainPath: .mainPath)
    }
}
