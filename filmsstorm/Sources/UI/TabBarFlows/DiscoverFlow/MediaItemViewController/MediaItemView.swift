//
//  MediaItemView.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 25.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class MediaItemView: UIView {

    @IBOutlet var navigationView: CustomNavigationView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var mediaItemImage: UIImageView!
    @IBOutlet var mediaItemName: UILabel!
    @IBOutlet var mediaItemYear: UILabel!
    @IBOutlet var mediaItemAgeLimit: UILabel!
    @IBOutlet var mediaItemDuration: UILabel!
    @IBOutlet var mediaItemDesription: UILabel!
}
