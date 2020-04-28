//
//  UIViewControllerextension.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 22.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

// MARK: - Alert constants

struct  TextConstants {
    static let close = "Close"
    static let cancel = "Cancel"
    static let serverError = "Server Error"
    static let appError = "App error."
    static let searchErrorTitle = "Search error"
    static let searchErrorMessage = "No results found"
}

// MARK: - Protocol extension

extension UIViewController {
    
    // MARK: - Private typealias
    
    private typealias Text = TextConstants
    
    // MARK: - Methods
    
    func showAlert(title: String?,
                   message: String? = nil,
                   preferredStyle: UIAlertController.Style = .alert,
                   actions: [UIAlertAction]? = [UIAlertAction(title: Text.close,
                                                              style: .destructive,
                                                              handler: nil)]) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: preferredStyle)
        actions?.forEach { alertController.addAction($0) }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showErrorAlert(_ title: String?, error: Error?) {
        self.showAlert(title: title, message: error?.localizedDescription)
    }
    
    func showAlertWithAction(title: String?,
                             message: String?,
                             actionTitle: String?,
                             action: ((UIAlertAction) -> Void)?) {
        let alertAction = UIAlertAction(title: actionTitle,
                                        style: .default,
                                        handler: action)
        self.showAlert(title: title,
                       message: message,
                       actions: [alertAction])
    }
}
