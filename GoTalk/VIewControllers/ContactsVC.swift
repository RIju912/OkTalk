//
//  ContactsVC.swift
//  GoTalk
//
//  Created by Subhodip on 24/02/17.
//  Copyright © 2017 Subhodip. All rights reserved.
//

import UIKit
import Contacts

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

class ContactsVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var iboTableView: UITableView!
    @IBOutlet weak var iboZeroContactsLabel: UILabel!
    @IBOutlet weak var iboSearchIcon: UIImageView!
    @IBOutlet weak var iboSearchButtonOutlet: UIButton!
    
    //MARK: - Variables
    var contactStorage = CNContactStore()
    var contactsModel = [PhoneBookContactList]()
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        iboTableView.register(UINib(nibName: "PhoneBookCell", bundle: nil), forCellReuseIdentifier: "PhoneBookCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        iboTableView.isHidden = true
        iboZeroContactsLabel.isHidden = false
        iboZeroContactsLabel.text = "Retrieving contacts..."
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestAccessToContacts { (success) in
            if success {
                DispatchQueue.main.async {
                    self.retrieveContacts({ (success, contact) in
                        self.iboTableView.isHidden = !success
                        self.iboZeroContactsLabel.isHidden = success
                        if success && contact?.count > 0 {
                            self.contactsModel = contact!
                            self.iboTableView.reloadData()
                        } else {
                            self.iboZeroContactsLabel.text = "Please provide permission to get contacts..."
                        }
                    })
                }
            }else{
                self.iboZeroContactsLabel.text = "Please provide permission to get contacts..."
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Auth for access
    func requestAccessToContacts(_ completion: @escaping (_ success: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized: completion(true) // authorized previously
        case .denied, .notDetermined: // needs to ask for authorization
            self.contactStorage.requestAccess(for: CNEntityType.contacts, completionHandler: { (accessGranted, error) -> Void in
                completion(accessGranted)
            })
        default: // not authorized.
            completion(false)
        }
    }
    
    //MARK: - Retrive contacts
    func retrieveContacts(_ completion: (_ success: Bool, _ contacts: [PhoneBookContactList]?) -> Void) {
        var contacts = [PhoneBookContactList]()
        do {
            let contactsFetchRequest = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactImageDataKey as CNKeyDescriptor, CNContactImageDataAvailableKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor])
            try contactStorage.enumerateContacts(with: contactsFetchRequest, usingBlock: { (cnContact, error) in
                if let contact = PhoneBookContactList(cnContact: cnContact) { contacts.append(contact) }
            })
            completion(true, contacts)
        } catch {
            completion(false, nil)
        }
    }
    
    //MARK: - IBAction
    @IBAction func iboSearchButtonA(_ sender: UIButton) {
    }

}


//MARK: - UITableViewDataSource && Delegate methods
extension ContactsVC: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneBookCell", for: indexPath) as! PhoneBookCell
        let entry = contactsModel[(indexPath as NSIndexPath).row]
        cell.configureWithContactEntry(entry)
        cell.layoutIfNeeded()
        
        return cell
    }
}
