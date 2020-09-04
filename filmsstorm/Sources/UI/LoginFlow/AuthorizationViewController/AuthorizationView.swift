//
//  AuthorizationView.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 29.12.2019.
//  Copyright © 2019 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class AuthorizationView: UIView {
    
    @IBOutlet var usernameTextField: UITextField?
    @IBOutlet var passwordTextField: UITextField?
    @IBOutlet var loginButton: UIButton?
    @IBOutlet var signUpButon: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUI()
    }
    
    private func setUI() {
        guard let usernameIcon = UIImage(named: "usernameIcon") else { return }
        guard let passwordIcon = UIImage(named: "passwordIcon") else { return }
        self.usernameTextField?.setIcon(usernameIcon)
        self.passwordTextField?.setIcon(passwordIcon)
        self.loginButton?.addShadow()
        self.signUpButon?.addShadow()
    }
}
