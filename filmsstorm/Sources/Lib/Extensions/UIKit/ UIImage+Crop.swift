//
//   UIImage+Crop.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 03.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import Foundation

import UIKit

extension UIImage {
    func square(with centerSize: CGSize) -> UIImage? {
        return self.cgImage.flatMap { cgimage in
            let contextImage = UIImage(cgImage: cgimage)
            let contextSize = contextImage.size
            let scale = contextSize.height / UIScreen.main.bounds.width
            var posX: CGFloat = 0
            var posY: CGFloat = 0
            var cgwidth = centerSize.width
            let squareSize = CGSize(width: cgwidth * scale, height: cgwidth * scale)
            
            if contextSize.width > contextSize.height {
                posX = ((contextSize.width - contextSize.height) / 2)
                posY = 0
                cgwidth = contextSize.height
            } else {
                posX = 0
                posY = ((contextSize.height - contextSize.width) / 2)
                cgwidth = contextSize.width
            }
            
            let distance = (cgwidth - squareSize.width) / 2
            let rect = CGRect(x: posX + distance,
                              y: posY + distance,
                              width: squareSize.width,
                              height: squareSize.width)
            
            return cgimage.cropping(to: rect).map { imageRef in
                UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
            }
        }
    }
    
}
