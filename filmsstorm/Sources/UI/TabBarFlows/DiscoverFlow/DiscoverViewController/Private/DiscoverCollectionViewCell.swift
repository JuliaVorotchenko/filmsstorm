//
//  CollectionViewCell.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 24.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

enum MovieCardEvent {
    case like
    case favourites
}

struct MovieCardEventModel {
    let action: ((MovieCardEvent) -> Void)
}

class DiscoverCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var movieImage: UIImageView!
    @IBOutlet var imageview: UIImageView?
    @IBOutlet var likeButton: UIView?
    @IBOutlet var favouriteButton: UIView?
    
    // MARK: - Private properties
    
    private var actionHandler: ((MovieCardEvent) -> Void)?
  
    // MARK: - Public Methods
    
    public func fill(with model: MovieListResult?) {
        self.movieImage.setImage(from: model?.posterPath)
    }
    
    public func actionFill(with model: MovieCardEventModel) {
        self.actionHandler = model.action
    }
    
    public func setCornerRadiusWithShadow() {
        self.imageview?.layer.cornerRadius = 7
        self.likeButton?.layer.cornerRadius = 7
        self.favouriteButton?.layer.cornerRadius = 7
       
        self.contentView.layer.cornerRadius = 2.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true

        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.8
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
                                             cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
    
    // MARK: - IBActions
    
    @IBAction func onLike(_ sender: UIButton) {
        print("like tapped")
        self.actionHandler?(.like)
    }
    
    @IBAction func onFav(_ sender: UIButton) {
        print("fav tapped")
        self.actionHandler?(.favourites)
    }
    
}
