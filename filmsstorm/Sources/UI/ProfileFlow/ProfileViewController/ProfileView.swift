//
//  ProfileView.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 06.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class ProfileView: UIView {

    @IBOutlet weak var avatarContainerView: UIView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    func setAvatar() {
        self.avatarContainerView.backgroundColor = .clear
        self.avatarContainerView.layer.cornerRadius = avatarContainerView.frame.size.width / 2
        self.avatarContainerView.layer.borderColor = CGColor(srgbRed: 71, green: 160, blue: 37, alpha: 0.85)
        self.avatarContainerView.layer.borderWidth = 3.0
        
        self.avatarImage.layer.cornerRadius = avatarImage.frame.size.width / 2
        
    }
    
}
