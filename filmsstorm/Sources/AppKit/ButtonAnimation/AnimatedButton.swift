//
//  AnimatedButton.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 24.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation
import UIKit

class AnimatedButton: UIButton {

    var animatedView = AnimatedView()
    
    // MARK: - Initializers
    override init (frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    convenience init () {
        self.init(frame: CGRect.zero)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.animatedView.frame = self.bounds
        self.insertSubview(self.animatedView, at: 0)
    }
    
    // MARK: - Setup Methods
    func setup() {
        self.clipsToBounds = false
        self.insertSubview(self.animatedView, at: 0)
    }
    
    func animate () {
        let delay = DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delay) {
            self.animatedView.animate()
        }
    }

    // MARK: Bouncing Animations
    func likeBounce (_ duration: TimeInterval) {
        self.animate()
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: UIView.KeyframeAnimationOptions(), animations: {

            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/5, animations: { [weak self] in
                self?.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
            })

            UIView.addKeyframe(withRelativeStartTime: 1/5, relativeDuration: 1/5, animations: { [weak self] in
                self?.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            })

            UIView.addKeyframe(withRelativeStartTime: 2/5, relativeDuration: 1/5, animations: { [weak self] in
                self?.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            })

            UIView.addKeyframe(withRelativeStartTime: 3/5, relativeDuration: 1/5, animations: { [weak self] in
                self?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            })

            UIView.addKeyframe(withRelativeStartTime: 4/5, relativeDuration: 1/5, animations: { [weak self] in
                self?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })

        })
        
    }
    
    func unLikeBounce (_ duration: TimeInterval) {
        self.transform = CGAffineTransform.identity
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: UIView.KeyframeAnimationOptions(), animations: {

            UIView.addKeyframe(withRelativeStartTime: 1/5, relativeDuration: 1/5, animations: { [weak self] in
                self?.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            })

            UIView.addKeyframe(withRelativeStartTime: 3/5, relativeDuration: 1/5, animations: { [weak self] in
                self?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            })

            UIView.addKeyframe(withRelativeStartTime: 4/5, relativeDuration: 1/5, animations: { [weak self] in
                self?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })

        })

   }

}

extension UIButton {

    func pulsate() {

        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.5
        pulse.fromValue = 0.6
        pulse.toValue = 1
        pulse.autoreverses = true
        pulse.repeatCount = 0.5
        pulse.initialVelocity = 0.2
        pulse.damping = 1.0

        layer.add(pulse, forKey: "pulse")
    }
}
