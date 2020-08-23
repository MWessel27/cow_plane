    //
//  BobbleDetailViewController.swift
//  bobble
//
//  Created by Mikalangelo Wessel on 8/13/20.
//  Copyright © 2020 Mikalangelo Wessel. All rights reserved.
//

import UIKit
import bobbleFramework
import myBobblesFramework
import bobbleTransactionLogFramework
import BobblePullTokenFramework
import Messages
import MessageUI
import os.log

class BobbleDetailViewController: UIViewController, MFMessageComposeViewControllerDelegate {

    var delegate: viewBobble?
    var bobble: Bobble?
    var sentBobbleId: Int = 0
    var myWonBobbles = [myBobbles]()
    var transactionLogIds = [bobbleTransactionLog]()
    var bobblePullTokens = [BobblePullTokens]()
    var onDoneBlock: ((Bool) -> Void)?
    
    @IBOutlet var bobbleNameLabel: UILabel!
    @IBOutlet var bobbleImageView: UIImageView!
    @IBOutlet var bobbleNumberLabel: UILabel!
    @IBOutlet var bobbleOutOfLabel: UILabel!
    @IBOutlet var bobbleDescription: UILabel!

    @IBOutlet var bobbleShareButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bobbleNameLabel.text = bobble?.name
        bobbleImageView.image = UIImage(named: String(bobble!.image))
        bobbleNumberLabel.text = String(bobble!.number)
        bobbleOutOfLabel.text = String(bobble!.outOf)
        bobbleDescription.text = bobble?.bobbleDescription
        
        if let wonBobbles = loadMyBobbles() {
                myWonBobbles += wonBobbles
        }
        
        if let transactionLog = loadMyTransactionLog() {
            transactionLogIds += transactionLog
        }
        
        if let pullTokens = loadMyPullTokens() {
            bobblePullTokens += pullTokens
        }
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        myWonBobbles = []
        transactionLogIds = []
        bobblePullTokens = []
        
        if let wonBobbles = loadMyBobbles() {
            myWonBobbles += wonBobbles
        }
        
        if let transactionLog = loadMyTransactionLog() {
            transactionLogIds += transactionLog
        }
        
        if let pullTokens = loadMyPullTokens() {
            bobblePullTokens += pullTokens
        }
    }
    
    private func saveMyBobbles() {
        let ArchiveURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.mikalanthony.bobble")?.appendingPathComponent("myBobbles")
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(myWonBobbles, toFile: ArchiveURL!.path)
        if isSuccessfulSave {
            os_log("Bobbles successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save Bobbles...", log: OSLog.default, type: .error)
        }
    }
    
    private func saveMyTransactionLog() {
        let ArchiveURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.mikalanthony.bobble")?.appendingPathComponent("transactionLog")
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(transactionLogIds, toFile: ArchiveURL!.path)
        if isSuccessfulSave {
            os_log("Transaction Log successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Transaction Log to save Bobbles...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadMyBobbles() -> [myBobbles]? {
        let ArchiveURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.mikalanthony.bobble")?.appendingPathComponent("myBobbles")
        return NSKeyedUnarchiver.unarchiveObject(withFile: ArchiveURL!.path) as? [myBobbles]
    }
    
    private func loadMyTransactionLog() -> [bobbleTransactionLog]? {
        let ArchiveURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.mikalanthony.bobble")?.appendingPathComponent("transactionLog")
        return NSKeyedUnarchiver.unarchiveObject(withFile: ArchiveURL!.path) as? [bobbleTransactionLog]
    }
    
    private func loadMyPullTokens() -> [BobblePullTokens]? {
        let ArchiveURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.mikalanthony.bobble")?.appendingPathComponent("bobblePullTokens")
        return NSKeyedUnarchiver.unarchiveObject(withFile: ArchiveURL!.path) as? [BobblePullTokens]
    }
    
    private func savePullTokens() {
        let ArchiveURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.mikalanthony.bobble")?.appendingPathComponent("bobblePullTokens")
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(bobblePullTokens, toFile: ArchiveURL!.path)
        if isSuccessfulSave {
            os_log("Bobble pull tokens successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save Bobble pull tokens...", log: OSLog.default, type: .error)
        }
    }
    
    fileprivate func composeMessage(with bobble: Bobble) {
        if MFMessageComposeViewController.canSendText() {
            var components = URLComponents()
            
            let bobbleId = URLQueryItem(name: "id", value: String(bobble.id))
            
            let alternateMessageLayout = MSMessageTemplateLayout()
            
            let layout = MSMessageLiveLayout(alternateLayout: alternateMessageLayout)
            
            let message = MSMessage()
            layout.alternateLayout.image = UIImage(named: bobble.image)
            message.layout = layout
            
            components.queryItems = [bobbleId]
            
            message.url = components.url
            
            layout.alternateLayout.caption = "This is a test"
    
            let messageComposeViewController = MFMessageComposeViewController()
            messageComposeViewController.message = message
            messageComposeViewController.body = bobble.name
            present(messageComposeViewController, animated: true, completion: nil)
        }
        bobblePullTokens[0].bobblePullTokenCount += 1
        savePullTokens()
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch(result) {
        case MessageComposeResult.sent:
            
            let bobbleId = sentBobbleId
            
            var count = 0
            for bobble in myWonBobbles {
                if(bobble.id == bobbleId) {
                    myWonBobbles.remove(at: count)
                    break
                }
                count += 1
            }
            saveMyBobbles()
        default:
            return
            
        }
        controller.dismiss(animated: true, completion: nil)
        delegate?.modalDismissed()
        self.dismiss(animated: true, completion: nil)
    }
    
    func generateRandomTransactionID() -> Int? {
        return Int.random(in: 1...1000000)
    }
    
    @IBAction func bobbleShareButtonTapped(_ sender: Any) {
        sentBobbleId = bobble!.id

        if(MFMessageComposeViewController.canSendText()) {
            var components = URLComponents()
            
            let bobbleId = URLQueryItem(name: "id", value: String(bobble!.id))
            let transactionIDString = generateRandomTransactionID()!
            let transactionID = URLQueryItem(name: "transactionID", value: String(transactionIDString))
            
            components.queryItems = [bobbleId, transactionID]
            
            let controller = MFMessageComposeViewController()

            let message = MSMessage()
            
            let alternateMessageLayout = MSMessageTemplateLayout()
            
            alternateMessageLayout.caption = "You've been sent a bobble!"
               
            alternateMessageLayout.image = UIImage(named: "sendBobbleImage")

            alternateMessageLayout.imageTitle = "Mystery Bobble"
            
            message.layout = alternateMessageLayout
            message.summaryText = "You've Received a Mystery Bobble!"
            
            message.shouldExpire = true
            
            message.layout = alternateMessageLayout
            message.url = components.url
            controller.message = message
            
            controller.recipients = []
            controller.messageComposeDelegate = self
            
            self.present(controller, animated: true, completion: nil)
            
            bobblePullTokens[0].bobblePullTokenCount += 1
            savePullTokens()
        }
    }

}
