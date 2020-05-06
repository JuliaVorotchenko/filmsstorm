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
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var biographyLabel: UILabel!
    
    func fill(with model: ActorDetailsModel) {
        guard let birthday = model.birthday, let age = self.age(dateString: birthday)  else { return }
        
        self.backgroundImage.loadImage(from: model.profilePath, mainPath: Path(rawValue: Path.mainPath))
        self.actorImage.loadImage(from: model.profilePath, mainPath: Path(rawValue: Path.mainPath))
        self.actorNameLabel.text = model.name
        self.birthDate.text = self.formatDate(dateString: birthday)
        self.birthPlace.text = model.birthPlace
        self.ageLabel.text = age
        self.biographyLabel.text = model.biography

    }
    
    private func age(dateString: String) -> String? {
        let date = dateString.toDate()
        let now = Date()
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.year]
        formatter.unitsStyle = .full
        return formatter.string(from: date, to: now)
        
    }
    
    private func formatDate(dateString: String) -> String? {
        let birthDate = dateString.toDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: birthDate)
    }
}
