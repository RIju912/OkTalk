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
import AVFoundation


class PhoneBookCell: UITableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var iboPhotoLabel: UIImageView!
    @IBOutlet weak var iboNameLabel: UILabel!
    @IBOutlet weak var iboPhoneNumberLabel: UILabel!
    @IBOutlet weak var iboRecordImageView: UIImageView!
    @IBOutlet weak var iboRecordButton: UIButton!
    @IBOutlet weak var iboPlayButton: UIButton!
    @IBOutlet weak var iboPlayImageView: UIImageView!
    
    //MARK: - Variable
    var recorder: AVAudioRecorder!
    var player:AVAudioPlayer!
    var soundFileURL:URL!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iboPlayButton.isEnabled = false
        iboPlayButton.alpha = 0.5
        setSessionPlayback()
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
    
    //MARK: - Session Playback
    func setSessionPlayback() {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - Record Permission
    func recordWithPermission(_ setup:Bool) {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        if (session.responds(to: #selector(AVAudioSession.requestRecordPermission(_:)))) {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    self.setSessionPlayAndRecord()
                    if setup {
                        self.setupRecorder()
                    }
                    self.recorder.record()
                } else {
                    //print("Permission to record not granted")
                }
            })
        } else {
            //print("requestRecordPermission unrecognized")
        }
    }
    
    //MARK: - Recorder Setup
    func setupRecorder() {
        let format = DateFormatter()
        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
        let currentFileName = "recording-\(format.string(from: Date())).m4a"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.soundFileURL = documentsDirectory.appendingPathComponent(currentFileName)
        
        let recordSettings:[String : AnyObject] = [
            AVFormatIDKey:             NSNumber(value: kAudioFormatAppleLossless),
            AVEncoderAudioQualityKey : NSNumber(value:AVAudioQuality.max.rawValue),
            AVEncoderBitRateKey :      NSNumber(value:320000),
            AVNumberOfChannelsKey:     NSNumber(value:2),
            AVSampleRateKey :          NSNumber(value:44100.0)
        ]
        
        do {
            recorder = try AVAudioRecorder(url: soundFileURL, settings: recordSettings)
            recorder.delegate = self
            recorder.isMeteringEnabled = true
            recorder.prepareToRecord() // creates/overwrites the file at soundFileURL
        } catch let error as NSError {
            recorder = nil
            print(error.localizedDescription)
        }
        
    }
    
    //MARK: - Session for Play and Record
    func setSessionPlayAndRecord() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - Record IBAction
    @IBAction func ibaRecordButton(_ sender: UIButton) {
        if player != nil && player.isPlaying {
            player.stop()
        }
        
        if recorder == nil {
            iboRecordButton.setTitle("Recording...", for:UIControlState())
            iboPlayButton.setTitle("Play", for:UIControlState())
            iboPlayButton.isEnabled = false
            iboPlayButton.alpha = 0.5
            recordWithPermission(true)
            return
        }
        
        if recorder != nil && recorder.isRecording {
            
            self.stopRecording()
            
        } else {
            iboRecordButton.setTitle("Recording...", for:UIControlState())
            iboPlayButton.setTitle("Play", for:UIControlState())
            iboPlayButton.isEnabled = false
            iboPlayButton.alpha = 0.5
            recordWithPermission(false)
        }
    }
    
    //MARK: - Stop Recording
    func stopRecording(){
        
        iboRecordButton.setTitle("Record", for:UIControlState())
        recorder?.stop()
        player?.stop()
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
            iboPlayButton.isEnabled = true
            iboPlayButton.alpha = 1.0
            iboRecordButton.isEnabled = true
            iboRecordButton.alpha = 1.0
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - Play IBAction
    @IBAction func ibaPlayButton(_ sender: UIButton) {
        if iboPlayButton.titleLabel?.text == "Play"{
            iboPlayButton.setTitle("Playing...", for:UIControlState())
            setSessionPlayback()
            play()
        }else{
           iboPlayButton.setTitle("Play", for:UIControlState())
           player?.stop()
        }
        
    }
    
    //MARK: - Play Record
    func play() {
        
        var url:URL?
        if self.recorder != nil {
            url = self.recorder.url
        } else {
            url = self.soundFileURL!
        }
        do {
            self.player = try AVAudioPlayer(contentsOf: url!)
            player.delegate = self
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
        } catch let error as NSError {
            self.player = nil
            print(error.localizedDescription)
        }
        
    }
    
}

// MARK:- AVAudioRecorderDelegate
extension PhoneBookCell: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder,
                                         successfully flag: Bool) {
        iboPlayButton.isEnabled = true
        iboPlayButton.alpha = 1.0
        iboRecordButton.setTitle("Record", for:UIControlState())
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder,
                                          error: Error?) {
        
        if let e = error {
            print("\(e.localizedDescription)")
        }
    }
    
}

// MARK:- AVAudioPlayerDelegate
extension PhoneBookCell: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        iboRecordButton.isEnabled = true
        iboPlayButton.setTitle("Play", for:UIControlState())
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let e = error {
            print("\(e.localizedDescription)")
        }
        
    }
}
