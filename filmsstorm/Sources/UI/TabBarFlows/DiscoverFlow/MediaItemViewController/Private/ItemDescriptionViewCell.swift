//
//  ItemDescriptionViewCell.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 10.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class ItemDescriptionViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet var itemImage: UIImageView!
    
    @IBOutlet var backgroundImage: UIImageView!
    
    @IBOutlet var itemName: UILabel!
    @IBOutlet var originalName: UILabel!
    
    
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
  
    
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var myListButton: UIButton!
    
    @IBOutlet var playButtonView: UIView!
    
   
    // MARK: - IBActions
    
    @IBAction func onLike(_ sender: UIButton) {
    }
    @IBAction func onList(_ sender: UIButton) {
    }
    @IBAction func onPlay(_ sender: Any) {
    }
}
