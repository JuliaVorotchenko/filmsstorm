//
//  AvatarViewCell.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 11.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class AvatarViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarContainer: UIView!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
   
   
    func fill(model: UserModel) {
        self.setAvatar()
        self.usernameLabel.text = model.username
    }
    
    private func setAvatar() {
        self.avatarContainer.backgroundColor = .clear
        self.avatarContainer.layer.cornerRadius = avatarContainer.frame.size.width / 2
        self.avatarContainer.layer.borderColor = CGColor(srgbRed: 71, green: 160, blue: 37, alpha: 0.85)
        self.avatarContainer.layer.borderWidth = 3.0
        
        self.avatarView.layer.cornerRadius = avatarView.frame.size.width / 2
        self.avatarView.image = UIImage(named: "user")
    }
}
