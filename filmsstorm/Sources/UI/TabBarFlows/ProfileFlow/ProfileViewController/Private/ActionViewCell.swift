//
//  AboutLogoutViewCell.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 11.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

struct ActionCellModel: Hashable {
    static func == (lhs: ActionCellModel, rhs: ActionCellModel) -> Bool {
        lhs.name == rhs.name && lhs.image == rhs.image
    }
    
    let name: String
    let image: UIImage?
    let action: (() -> Void)?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(image)
    }
}

class ActionViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var iconImage: UIImageView?
    @IBOutlet private weak var actionButton: UIButton?
    
    private var actionHandler: (() -> Void)?
    
    func fill(with model: ActionCellModel) {
        self.actionHandler = model.action
        self.titleLabel?.text = model.name
        self.iconImage?.image = model.image
    }
    
    @IBAction func onAction(_ sender: Any) {
        self.actionHandler?()
    }
}
