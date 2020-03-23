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
    
    @IBOutlet var imageView: UIImageView?

    // MARK: - Cell life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    // MARK: - Public Methods
    
    public func fill(with model: DiscoverCellModel?) {
        self.imageView?.setImage(from: model?.posterPath)
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        self.addShadow()
    }

}
