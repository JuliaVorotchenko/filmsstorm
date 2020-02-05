//
//  UIView+Extensions.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 30.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImage(from path: String?,
                  defaultImage: UIImage? = UIImage(named: "tmdbLogo"),
                  imageLoadingService: ImageLoadingService = ImageLoadingServiceImpl()) {
        imageLoadingService.loadImage(from: path) { [weak self] result in
            switch result {
            case .success(let image):
                self?.image = image
            case .failure:
                self?.image = defaultImage
            }
        }
    }
}
