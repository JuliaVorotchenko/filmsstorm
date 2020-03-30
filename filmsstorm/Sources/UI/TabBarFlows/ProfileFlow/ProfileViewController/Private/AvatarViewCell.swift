//
//  AvatarViewCell.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 11.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class AvatarViewCell: UITableViewCell {
    
    @IBOutlet var containerView: UIView?
    @IBOutlet weak var avatarView: UIImageView?
    @IBOutlet weak var usernameLabel: UILabel?
    
    @IBOutlet var combineView: UIView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setAvatar()
    }
    
    func fill(model: UserModel?) {
        let path = model?.avatar?.gravatar?.hashString
        self.avatarView?.setImage(from: path, mainPath: .gravatar)
        self.usernameLabel?.text = model?.username
    }
    
    private func setAvatar() {
        self.avatarView?.roundedWithWidth()
        self.avatarView?.layer.borderColor = UIColor(red: 0.153, green: 0.153, blue: 0.455, alpha: 1).cgColor
        self.avatarView?.layer.borderWidth = 10.0
        
    }
}
