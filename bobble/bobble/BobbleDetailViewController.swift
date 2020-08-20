//
//  BobbleDetailViewController.swift
//  bobble
//
//  Created by Mikalangelo Wessel on 8/13/20.
//  Copyright © 2020 Mikalangelo Wessel. All rights reserved.
//

import UIKit
import bobbleFramework
import Messages
import MessageUI

class BobbleDetailViewController: UIViewController, MFMessageComposeViewControllerDelegate {

    var delegate: viewBobble?
    var bobble: Bobble?
    
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
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func bobbleShareButtonTapped(_ sender: Any) {
//        composeMessage(with: bobble!)
        if(MFMessageComposeViewController.canSendText()) {
            var components = URLComponents()
            
            let bobbleId = URLQueryItem(name: "id", value: String(bobble!.id))
            
            components.queryItems = [bobbleId]
            
            let controller = MFMessageComposeViewController()

            let message = MSMessage()
            
            let alternateMessageLayout = MSMessageTemplateLayout()
            
            alternateMessageLayout.caption = "You've been sent a Bobble!"
            alternateMessageLayout.image = UIImage(named: "sendBobbleImage")
            
            message.layout = alternateMessageLayout
            message.url = components.url
            controller.message = message
            
            controller.recipients = []
            controller.messageComposeDelegate = self
            
            self.present(controller, animated: true, completion: nil)
        }
    }
    


}
