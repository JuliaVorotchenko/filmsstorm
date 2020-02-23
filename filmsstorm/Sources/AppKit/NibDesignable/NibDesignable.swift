//
//  NibDesignable.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 19.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

protocol NibDesignable: NSObjectProtocol {
   
    func loadNib() -> UIView

}

extension NibDesignable where Self: UIView {
    
    func loadNib() -> UIView {
        let subject = type(of: self)
        let bundle = Bundle(for: subject)
        let nib = UINib(nibName: String(describing: subject), bundle: bundle)
        return nib.instantiate(withOwner: self).first as? UIView ?? UIView()
    }
    
    func setupView() {
        let view = self.loadNib()
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
}

//@IBDesignable
class NibDesignableImpl: UIView, NibDesignable {
    
      override init(frame: CGRect) {
          super.init(frame: frame)
          self.setupView()
      }
      
      required init?(coder: NSCoder) {
          super.init(coder: coder)
          self.setupView()
      }
}
