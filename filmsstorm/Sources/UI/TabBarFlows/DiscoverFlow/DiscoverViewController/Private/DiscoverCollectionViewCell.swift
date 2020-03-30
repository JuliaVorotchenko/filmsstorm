//
//  CollectionViewCell.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 24.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

typealias Handler<T> = (T) -> Void

class DiscoverCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet var imageView: LoadingImageView?
    
    // MARK: - Cell life cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView?.image = nil
        self.imageView?.cancelLoading()
    }
    
    // MARK: - Public Methods
    
    public func fill(with model: DiscoverCellModel?) {
        self.imageView?.loadImage(from: model?.posterImage)
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        self.addShadow()
    }
    
}
