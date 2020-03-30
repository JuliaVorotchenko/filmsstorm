//
//  ItemImageViewCell.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 10.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class MediaItemImageCell: UICollectionViewCell {
  
    @IBOutlet var itemImage: UIImageView?
        
    func similarsFill(model: DiscoverCellModel) {
        let path = model.posterPath
        self.itemImage?.setImage(from: path, mainPath: .mainPath)
    }
    
    func actorsFill(model: ActorModel) {
        let path = model.actorImage
        self.itemImage?.setImage(from: path, mainPath: .mainPath)
    }
}
