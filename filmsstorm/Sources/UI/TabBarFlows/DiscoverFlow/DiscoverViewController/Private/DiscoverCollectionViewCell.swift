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
    
    public func setCornerRadius() {
        self.imageview?.layer.cornerRadius = 7
        self.likeButton?.layer.cornerRadius = 7
        self.favouriteButton?.layer.cornerRadius = 7
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
