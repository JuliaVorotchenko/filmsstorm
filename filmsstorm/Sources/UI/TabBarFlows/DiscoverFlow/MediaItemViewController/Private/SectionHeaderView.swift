//
//  SectionHeader.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 15.03.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

enum SectionHeaderEvent: CaseIterable {
    case moviesWatchlist
    case showsWatchlist
    case favoriteMovies
    case favoriteShows
}

struct SectionHeaderModel: Hashable {
//    let id = UUID()
    // TODO: Remove Secton to SectionHeaderEvent
    let section: Section
    let action: ActionModel<Section>
}

class SectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeaderView"

    private var model: SectionHeaderModel?

    @IBOutlet var label: UILabel?
   
    override func prepareForReuse() {
        super.prepareForReuse()
        self.label?.text = ""
        self.model = nil
    }
    
    func fill(with text: String) {
        self.label?.text = text
    }

    func fill(with model: SectionHeaderModel) {
        self.label?.text = model.section.rawValue
        self.model = model
    }

    @IBAction func onAction(_ sender: UIButton) {
        self.model.do { $0.action.action?($0.section) }
    }
}
