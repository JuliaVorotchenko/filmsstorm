//
//  NavigationView.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 19.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

class NavigationView: UIView {
    
    var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    func loadFromnNib() -> UIView {
        let bundle = Bundle(for: NavigationView.self)
        let nib = UINib(nibName: F.toString(NavigationView.self), bundle: bundle)
        
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return UIView() }
    
        return view
    }
    
    func setup() {
        self.view = self.loadFromnNib()
        self.view.frame = bounds
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(self.view)
    }
    
}
