//
//  UIViewControllerextension.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 22.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

// MARK: - UIVewController Extension for alerts realisation

extension UIViewController {
    // MARK: - Alert tittles
    
    struct  TextConstants {
        static let close = "Close"
        static let cancel = "Cancel"
        static let serverError = "Server Error"
    }
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
    
    func showServerErrorAlert(_ error: NetworkError?) {
        self.showAlert(title: Text.serverError, message: error?.stringDescription)
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
