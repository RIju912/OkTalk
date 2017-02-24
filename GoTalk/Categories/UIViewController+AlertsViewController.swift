//
//  UIViewController+AlertsViewController.swift
//  GoTalk
//
//  Created by Subhodip on 24/02/17.
//  Copyright © 2017 Subhodip. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //MARK: - default alert/info message with an OK button.
    func showAlertMessage(_ message: String, okButtonTitle: String = "Ok") -> Void {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okButtonTitle, style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
