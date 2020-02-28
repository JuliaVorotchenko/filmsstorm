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
    
    
    @IBOutlet var cellContainerView: UIView!
    @IBOutlet var imageView: UIImageView?
    @IBOutlet var likeButton: UIView?
    @IBOutlet var favouriteButton: UIView?
    
    // MARK: - Private properties
    
    private var actionHandler: ((MovieCardEvent) -> Void)?
    
    // MARK: - Public Methods
    
    public func fillMovies(with model: MovieListResult?, _ eventModel: MovieCardEventModel) {
        self.imageView?.setImage(from: model?.posterPath)
        self.actionHandler = eventModel.action
    }
    
    public func fillShows(with model: ShowListResult?, _ eventModel: MovieCardEventModel) {
        self.imageView?.setImage(from: model?.posterPath)
        self.actionHandler = eventModel.action
    }
    
    public func actionFill(with model: MovieCardEventModel) {
        self.actionHandler = model.action
    }
    
   
    
    public func setCornerRadiusWithShadow() {
        self.rounded(cornerRadius: 2)
        self.likeButton?.rounded(cornerRadius: 7)
        self.favouriteButton?.rounded(cornerRadius: 7)
        self.addShadow(color: .cyan, offset: CGSize(width: 2.0, height: 2.0), opacity: 0.8, radius: 2.0, shadowRect: nil)
       
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
