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
                  mainPath: Path = .mainPath,
                  defaultImage: UIImage? = UIImage(named: "tmdbLogo"),
                  imageLoadingService: ImageLoadingService = ImageLoadingServiceImpl()) {
        imageLoadingService.loadImage(from: path, mainPath: mainPath) { [weak self] result in
            switch result {
            case .success(let image):
                self?.image = image
            case .failure:
                self?.image = defaultImage
            }
        }
    }
}
