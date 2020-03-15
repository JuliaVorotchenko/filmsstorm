//
//  ItemOverviewViewCell.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 10.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class ItemOverviewViewCell: UICollectionViewCell {
    @IBOutlet var overViewLabel: UILabel!
    
    func fill(model: DiscoverCellModel) {
        self.overViewLabel.text = model.overview
    }
}
