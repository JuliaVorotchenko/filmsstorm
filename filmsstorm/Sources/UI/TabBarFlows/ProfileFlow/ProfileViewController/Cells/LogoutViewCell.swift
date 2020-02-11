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
        self.logoutButton.addTarget(self, action: #selector(logoutButtonTapped(_:)), for: .touchUpInside)
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        self.logoutTappedAction?()
    }
}
