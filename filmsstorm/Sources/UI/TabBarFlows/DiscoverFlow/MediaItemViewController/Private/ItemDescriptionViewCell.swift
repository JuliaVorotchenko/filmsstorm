//
//  ItemDescriptionViewCell.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 10.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class ItemDescriptionViewCell: UITableViewCell {

    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var itemNameLabel: UILabel!
    
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var myListButton: UIButton!
    
    @IBAction func onLike(_ sender: UIButton) {
    }
    @IBAction func onList(_ sender: UIButton) {
    }
}
