//
//  CollectionViewCell.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 24.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    private let imageLoadingService: ImageLoadingService = ImageLoadingServiceImpl()

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.movieName.text = ""
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func fill(with model: MovieListResult?) {
        self.imageLoadingService.loadImage(from: model?.posterPath) { [weak self] result in
            switch result {
            case .success(let image):
                self?.movieImage.image = image
            case .failure(let error):
                print(error)
            }
        }
        self.movieName.text = model?.title
    }
    
}
