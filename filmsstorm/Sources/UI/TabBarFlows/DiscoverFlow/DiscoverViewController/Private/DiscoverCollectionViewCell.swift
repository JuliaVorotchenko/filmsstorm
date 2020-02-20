//
//  CollectionViewCell.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 24.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class DiscoverCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var movieImage: UIImageView!

    @IBOutlet var imageview: UIImageView?
    
    @IBOutlet var likeButton: UIView?
    
    @IBOutlet var favouriteButton: UIView?
    
    public func fill(with model: MovieListResult?) {
        self.movieImage.setImage(from: model?.posterPath)
    }
    
    public func setCornerRadius() {
        self.imageview?.layer.cornerRadius = 7
        self.likeButton?.layer.cornerRadius = 7
        self.favouriteButton?.layer.cornerRadius = 7
    }
    
}
