//
//  ListTypeCell.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 15.04.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class ListTypeCell: UICollectionViewCell {

    @IBOutlet weak var listTypeLabel: UILabel!
  
    func fill(listType: String) {
        self.listTypeLabel.text = listType
    }

}
