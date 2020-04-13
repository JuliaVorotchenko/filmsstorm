//
//  ActorDescriptionCell.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 12.04.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class ActorDescriptionCell: UICollectionViewCell {
    @IBOutlet weak var backgroundImage: LoadingImageView!
    @IBOutlet weak var actorImage: LoadingImageView!
    @IBOutlet weak var actorNameLabel: UILabel!
    @IBOutlet weak var birthDate: UILabel!
    @IBOutlet weak var birthPlace: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var biographyLabel: UILabel!
    
    func fill(with model: ActorDetailsModel) {
        self.backgroundImage.loadImage(from: model.profilePath)
        self.actorImage.loadImage(from: model.profilePath)
        self.actorNameLabel.text = model.name
        self.birthDate.text = model.birthday
        self.birthPlace.text = model.birthPlace
        self.age.text = "78"
        self.biographyLabel.text = model.biography
    }
}
