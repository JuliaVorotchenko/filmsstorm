//
//  AboutLogoutViewCell.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 11.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class AboutViewCell: UITableViewCell {
    
    @IBOutlet weak var aboutButton: UIButton!
    var aboutTappedAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.aboutButton.addTarget(self, action: #selector(aboutButtonTapped(_:)), for: .touchUpInside)
    }
    
    @IBAction func aboutButtonTapped(_ sender: Any) {
        self.aboutTappedAction?()
    }
}
