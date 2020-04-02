//
//  VideoPlayerViewController.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 02.04.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView

class VideoPlayerViewController<T: VideoPlayerViewPresenter >: UIViewController, Controller, ActivityViewPresenter {

    // MARK: - Subtypes
    
    typealias RootViewType = VideoPlayerView
    typealias Service = T
    
    // MARK: - Private properties
    
    let loadingView = ActivityView()
    let presenter: Service

    // MARK: - Init and deinit
     
     deinit {
         self.hideActivity()
         F.Log(F.toString(Self.self))
     }
     
     required init(_ presentation: Service) {
         self.presenter = presentation
         super.init(nibName: F.nibNamefor(Self.self), bundle: nil)
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationView()
    }
    
    // MARK: - Private methods
    
    private func setupNavigationView() {
        self.rootView?.customNavigationView.actionHandler = { [weak self] in
            self?.presenter.onBack()
        }
        self.rootView?.customNavigationView.titleFill(with: self.presenter.item.name!)
    }

}
