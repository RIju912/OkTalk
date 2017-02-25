//
//  PhoneBookContactList.swift
//  GoTalk
//
//  Created by Subhodip on 24/02/17.
//  Copyright © 2017 Subhodip. All rights reserved.
//

import UIKit
import AddressBook
import Contacts

class PhoneBookContactList: NSObject {
    
    //MARK: - Variables
    var name: String!
    var phoneNumber: String?
    var image: UIImage?
    
    //MARK: - Init
    init(name: String, phoneNumber: String?, image: UIImage?) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.image = image
    }
    
    //MARK: - Access names , image , phonenumber
    init?(cnContact: CNContact) {
        // name
        if !cnContact.isKeyAvailable(CNContactGivenNameKey) && !cnContact.isKeyAvailable(CNContactFamilyNameKey) { return nil }
        self.name = (cnContact.givenName + " " + cnContact.familyName).trimmingCharacters(in: CharacterSet.whitespaces)
        
        // image
        self.image = (cnContact.isKeyAvailable(CNContactImageDataKey) && cnContact.imageDataAvailable) ? UIImage(data: cnContact.imageData!) : nil

        // phone
        if cnContact.isKeyAvailable(CNContactPhoneNumbersKey) {
            if cnContact.phoneNumbers.count > 0 {
                let phone = cnContact.phoneNumbers.first?.value
                self.phoneNumber = phone?.stringValue
            }
        }
    }
}
