//
//  CollectionViewCell.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 24.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.movieName.text = ""
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func fill(with model: PopularMoviesModel) {
        let movieResult = model.results[0]
        self.movieName.text = movieResult.title ?? "some title"
    }
    
}
