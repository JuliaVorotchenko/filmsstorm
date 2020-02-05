//
//  SessionIDView.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 29.12.2019.
//  Copyright © 2019 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class SessionIDView: UIView {
    @IBOutlet weak var sessionIdLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    
    func fillLabel() {
        let sessionID = UserDefaultsContainer.session
        self.sessionIdLabel.text = sessionID
        let username = UserDefaultsContainer.username
        self.userIDLabel.text = username
    }
}
