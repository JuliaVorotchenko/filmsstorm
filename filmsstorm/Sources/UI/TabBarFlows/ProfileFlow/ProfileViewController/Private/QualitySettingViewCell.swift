//
//  QualitySettingViewCell.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 11.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class QualitySettingViewCell: UITableViewCell {
    @IBOutlet weak var imageQualityLabel: UILabel?
    @IBOutlet weak var setQuality: UISwitch?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setQuality?.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
    }
    
    @objc func stateChanged(switchState: UISwitch) {
        if switchState.isOn {
            ImageQualitySettingContainer.imageQualityIsHigh = true
        } else {
            ImageQualitySettingContainer.imageQualityIsHigh = false
        }
    }
}
