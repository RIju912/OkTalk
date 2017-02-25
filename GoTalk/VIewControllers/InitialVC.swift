//
//  InitialVC.swift
//  GoTalk
//
//  Created by Subhodip on 24/02/17.
//  Copyright © 2017 Subhodip. All rights reserved.
//

import UIKit

class InitialVC: UIViewController {
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - IBAction
    @IBAction func ibaAccessPhoneBook(_ sender: UIButton) {
        if #available(iOS 9, *) {
            self.performSegue(withIdentifier: "AccessToContacts", sender: sender)
        } else {
            self.showAlertMessage("Sorry, only available for iOS 9 and up.")
        }
    }
    
}
