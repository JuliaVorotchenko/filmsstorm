//
//  NavigationView.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 19.02.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

enum DiscoverHeaderEvent {
    case onSearch
    case onTVShow
    case onMovie
}

struct DiscoverHeaderModel {
    
    let action: ((DiscoverHeaderEvent) -> Void)?
}

class DiscoverHeaderView: NibDesignableImpl {
    
    struct Constants {
        static let movieButton = "Movies"
        static let tvButton = "TVShows"
    }
    
    @IBOutlet var tvButton: UIButton?
    @IBOutlet var movieButton: UIButton?
    
    var actionHandler: ((DiscoverHeaderEvent) -> Void)?
    
    func fill(with model: DiscoverHeaderModel) {
        self.actionHandler = model.action
        self.tvButton?.setTitle(Constants.tvButton, for: .normal)
        self.movieButton?.setTitle(Constants.movieButton, for: .normal)
    }
    
    @IBAction func onSearch(_ sender: UIButton) {
        self.actionHandler?(.onSearch)
    }
    
    @IBAction func onTVShows(_ sender: UIButton) {
        self.actionHandler?(.onTVShow)
    }
    @IBAction func onMovies(_ sender: UIButton) {
        self.actionHandler?(.onMovie)
    }
}
