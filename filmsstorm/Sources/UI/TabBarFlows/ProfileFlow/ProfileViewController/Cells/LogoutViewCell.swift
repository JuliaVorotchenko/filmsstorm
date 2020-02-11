//
//  LogoutViewCell.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 11.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class LogoutViewCell: UITableViewCell {
    
    @IBOutlet weak var logoutButton: UIButton!
    
    var logoutTappedAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        self.logoutTappedAction?()
    }
}
