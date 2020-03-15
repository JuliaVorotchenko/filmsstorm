//
//  SectionHeader.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 15.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeader"
    
    let title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.title.textColor = UIColor(named: .sectionHeader)
        self.title.font = UIFontMetrics.default.scaledFont(for: UIFont.italicSystemFont(ofSize: 16))
        self.title.text = "similars"
        self.addSubview(self.title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
