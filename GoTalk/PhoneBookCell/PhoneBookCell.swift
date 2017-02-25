//
//  PhoneBookCell.swift
//  GoTalk
//
//  Created by Subhodip on 24/02/17.
//  Copyright © 2017 Subhodip. All rights reserved.
//

import AddressBook
import Contacts
import UIKit

class PhoneBookCell: UITableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var iboPhotoLabel: UIImageView!
    @IBOutlet weak var iboNameLabel: UILabel!
    @IBOutlet weak var iboPhoneNumberLabel: UILabel!
    @IBOutlet weak var iboRecordImageView: UIImageView!
    @IBOutlet weak var iboRecordButton: UIButton!
    @IBOutlet weak var iboPlayButton: UIButton!
    @IBOutlet weak var iboPlayImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Rounded Images
    func setCircularAvatar() {
        iboPhotoLabel.layer.cornerRadius = iboPhotoLabel.bounds.size.width / 2.0
        iboPhotoLabel.layer.masksToBounds = true
    }
    
    //MARK: - Layout
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        setCircularAvatar()
    }
    
    //MARK: - ConfigureCell
    func configureWithContactEntry(_ contact: PhoneBookContactList) {
        iboNameLabel.text = contact.name
        iboPhoneNumberLabel.text = contact.phoneNumber ?? ""
        iboPhotoLabel.image = contact.image ?? UIImage(named: "Photo")
        setCircularAvatar()
    }
    
    //MARK: - Record IBAction
    @IBAction func ibaRecordButton(_ sender: UIButton) {
    }
    
    //MARK: - Play IBAction
    @IBAction func ibaPlayButton(_ sender: UIButton) {
    }
    
}
