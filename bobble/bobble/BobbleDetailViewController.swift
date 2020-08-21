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
import Messages
import MessageUI
import os.log

class BobbleDetailViewController: UIViewController, MFMessageComposeViewControllerDelegate {

    var delegate: viewBobble?
    var bobble: Bobble?
    var sentBobbleId: Int = 0
    var myWonBobbles = [myBobbles]()
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
        }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        myWonBobbles = []
        
        if let wonBobbles = loadMyBobbles() {
            myWonBobbles += wonBobbles
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
    
    private func loadMyBobbles() -> [myBobbles]? {
        let ArchiveURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.mikalanthony.bobble")?.appendingPathComponent("myBobbles")
        return NSKeyedUnarchiver.unarchiveObject(withFile: ArchiveURL!.path) as? [myBobbles]
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
    
    @IBAction func bobbleShareButtonTapped(_ sender: Any) {
        sentBobbleId = bobble!.id

        if(MFMessageComposeViewController.canSendText()) {
            var components = URLComponents()
            
            let bobbleId = URLQueryItem(name: "id", value: String(bobble!.id))
            
            components.queryItems = [bobbleId]
            
            let controller = MFMessageComposeViewController()

            let message = MSMessage()
            
            let alternateMessageLayout = MSMessageTemplateLayout()
            
            alternateMessageLayout.caption = "You've been sent a bobble!"
               
            alternateMessageLayout.image = UIImage(named: "sendBobbleImage")

            alternateMessageLayout.imageTitle = "Mystery Bobble"
            
            message.layout = alternateMessageLayout
            message.summaryText = "You've Received a Mystery Bobble!"
            
            message.layout = alternateMessageLayout
            message.url = components.url
            controller.message = message
            
            controller.recipients = []
            controller.messageComposeDelegate = self
            
            self.present(controller, animated: true, completion: nil)
        }
    }

}
