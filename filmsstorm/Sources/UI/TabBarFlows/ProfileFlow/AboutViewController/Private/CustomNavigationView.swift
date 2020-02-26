//
//  CustomNavigationView.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 20.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class CustomNavigationView: NibDesignableImpl {
    
    @IBOutlet var backButton: UIButton?
    @IBOutlet var titleLabel: UILabel?
    
    var actionHandler: (() -> Void)?
    
    @IBAction func onBack(_ sender: UIButton) {
        self.actionHandler?()
    }
    
    func titleFill(with title: String) {
         print("title fill")
        self.titleLabel?.text = title
    }
    
}
