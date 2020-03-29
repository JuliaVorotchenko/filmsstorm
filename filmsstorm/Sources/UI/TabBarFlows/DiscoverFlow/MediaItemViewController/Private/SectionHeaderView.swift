//
//  SectionHeader.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 15.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeaderView"
    
    @IBOutlet var title: UILabel!

    func fill(from model: String) {
        self.title.text = model
    }
}
