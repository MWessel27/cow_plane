//
//  MessagesViewController.swift
//  bobbleiMessageExtension
//
//  Created by Mikalangelo Wessel on 8/17/20.
//  Copyright © 2020 Mikalangelo Wessel. All rights reserved.
//

import UIKit
import Messages
import bobbleFramework
import myBobblesFramework
import bobbleTransactionLogFramework
import os.log

class MessagesViewController: MSMessagesAppViewController {
    
    var bobbles = [Bobble]()
    var myWonBobbles = [myBobbles]()
    var transactionLogIds = [bobbleTransactionLog]()
    var firstOpenExpanded = true
    
    @IBOutlet var bobbleTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        bobbleTableView.delegate = self
        bobbleTableView.dataSource = self
        
        if let savedBobbles = loadBobbles() {
            bobbles += savedBobbles
        }
        if let wonBobbles = loadMyBobbles() {
            myWonBobbles += wonBobbles
        }
        
        if let transactionLog = loadMyTransactionLog() {
            transactionLogIds += transactionLog
        }
        
        self.bobbleTableView.reloadData()
    }
    
    private func loadBobbles() -> [Bobble]? {
        let ArchiveURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.mikalanthony.bobble")?.appendingPathComponent("bobbles")
        return NSKeyedUnarchiver.unarchiveObject(withFile: ArchiveURL!.path) as? [Bobble]
    }
    
    private func loadMyBobbles() -> [myBobbles]? {
        let ArchiveURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.mikalanthony.bobble")?.appendingPathComponent("myBobbles")
        return NSKeyedUnarchiver.unarchiveObject(withFile: ArchiveURL!.path) as? [myBobbles]
    }
    
    private func loadMyTransactionLog() -> [bobbleTransactionLog]? {
        let ArchiveURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.mikalanthony.bobble")?.appendingPathComponent("transactionLog")
        return NSKeyedUnarchiver.unarchiveObject(withFile: ArchiveURL!.path) as? [bobbleTransactionLog]
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
    
    // MARK: - Conversation Handling
    override func willSelect(_ message: MSMessage, conversation: MSConversation) {
        if let selectedMessage = conversation.selectedMessage {
            if conversation.localParticipantIdentifier == selectedMessage.senderParticipantIdentifier {
                // you sent this iMessage
            } else {
                // you recieved this iMessage
                let queryItems = URLComponents(string: selectedMessage.url!.absoluteString)?.queryItems
                let idParam = queryItems?.filter({$0.name == "id"}).first
                let transactionLogID = queryItems?.filter({$0.name == "transactionID"}).first
                print(idParam?.value)
                print(transactionLogID?.value)
                let transactionLogIDString = String((transactionLogID?.value)!)
                let transactionLogIDInt = Int(transactionLogIDString)
                
                transactionLogIds = []
                if let transactionLog = loadMyTransactionLog() {
                    transactionLogIds += transactionLog
                }
                
                var validTransaction = true
                for transaction in transactionLogIds {
                    if(transaction.transactionId == transactionLogIDInt) {
                        validTransaction = false
                    }
                }
                
                if(validTransaction) {
                    let bobbleId = Int((idParam!.value!))
                    let url = URL(string: "bobble://\(bobbleId!)")
                    print(url?.absoluteString)

                    self.extensionContext?.open(url!, completionHandler: { (success: Bool) in
                             
                    })
                    guard let newTransactionLog = bobbleTransactionLog(transactionId: transactionLogIDInt ?? 0) else { return }
                    transactionLogIds.append(newTransactionLog)
                    saveMyTransactionLog()
                }
            }
        }
    }
    
    override func didSelect(_ message: MSMessage, conversation: MSConversation) {
        if let selectedMessage = conversation.selectedMessage {
            if conversation.localParticipantIdentifier == selectedMessage.senderParticipantIdentifier {
                // you sent this iMessage
            } else {
                // you recieved this iMessage
                let queryItems = URLComponents(string: selectedMessage.url!.absoluteString)?.queryItems
                let idParam = queryItems?.filter({$0.name == "id"}).first
                let transactionLogID = queryItems?.filter({$0.name == "transactionID"}).first
                print(idParam?.value)
                print(transactionLogID?.value)
                let transactionLogIDString = String((transactionLogID?.value)!)
                let transactionLogIDInt = Int(transactionLogIDString)
                
                transactionLogIds = []
                if let transactionLog = loadMyTransactionLog() {
                    transactionLogIds += transactionLog
                }
                
                var validTransaction = true
                for transaction in transactionLogIds {
                    if(transaction.transactionId == transactionLogIDInt) {
                        validTransaction = false
                    }
                }
                
                if(validTransaction) {
                    let bobbleId = Int((idParam!.value!))
                    let url = URL(string: "bobble://\(bobbleId!)")
                    print(url?.absoluteString)

                    self.extensionContext?.open(url!, completionHandler: { (success: Bool) in
                             
                    })
                    guard let newTransactionLog = bobbleTransactionLog(transactionId: transactionLogIDInt ?? 0) else { return }
                    transactionLogIds.append(newTransactionLog)
                    saveMyTransactionLog()
                }
            }
        }
    }
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
        
        if let selectedMessage = conversation.selectedMessage {
            if conversation.localParticipantIdentifier == selectedMessage.senderParticipantIdentifier {
                // you sent this iMessage
            } else {
                // you recieved this iMessage
                let queryItems = URLComponents(string: selectedMessage.url!.absoluteString)?.queryItems
                let idParam = queryItems?.filter({$0.name == "id"}).first
                let transactionLogID = queryItems?.filter({$0.name == "transactionID"}).first
                print(idParam?.value)
                print(transactionLogID?.value)
                let transactionLogIDString = String((transactionLogID?.value)!)
                let transactionLogIDInt = Int(transactionLogIDString)
                
                transactionLogIds = []
                if let transactionLog = loadMyTransactionLog() {
                    transactionLogIds += transactionLog
                }
                
                var validTransaction = true
                for transaction in transactionLogIds {
                    if(transaction.transactionId == transactionLogIDInt) {
                        validTransaction = false
                    }
                }
                
                if(validTransaction) {
                    let bobbleId = Int((idParam!.value!))
                    let url = URL(string: "bobble://\(bobbleId!)")
                    print(url?.absoluteString)

                    self.extensionContext?.open(url!, completionHandler: { (success: Bool) in
                             
                    })
                    guard let newTransactionLog = bobbleTransactionLog(transactionId: transactionLogIDInt ?? 0) else { return }
                    transactionLogIds.append(newTransactionLog)
                    saveMyTransactionLog()
                }
            }
        }
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        if let selectedMessage = conversation.selectedMessage {
            if conversation.localParticipantIdentifier == selectedMessage.senderParticipantIdentifier {
                // you sent this iMessage
            } else {
                // you recieved this iMessage
                let queryItems = URLComponents(string: message.url!.absoluteString)?.queryItems
                let idParam = queryItems?.filter({$0.name == "id"}).first

                let bobbleId = Int((idParam!.value!))
                let url = URL(string: "bobble://\(bobbleId!)")

                self.extensionContext?.open(url!, completionHandler: { (success: Bool) in
                         
                })
            }
        }
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
        print(message.url?.absoluteString)
        let queryItems = URLComponents(string: message.url!.absoluteString)?.queryItems
        let idParam = queryItems?.filter({$0.name == "id"}).first

        print(idParam?.value)
        
        let bobbleId = Int((idParam?.value)!)
        
        var count = 0
        for bobble in myWonBobbles {
            if(bobble.id == bobbleId) {
                myWonBobbles.remove(at: count)
                break
            }
            count += 1
        }
        saveMyBobbles()
        self.bobbleTableView.reloadData()
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    
        // Use this method to prepare for the change in presentation style.
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }
    
    func composeMessage(myBobble: myBobbles, randomTransactionId: Int) -> MSMessage? {
        
        var components = URLComponents()

        let bobbleId = URLQueryItem(name: "id", value: String(myBobble.id))
        let transactionID = URLQueryItem(name: "transactionID", value: String(randomTransactionId))

        components.queryItems = [bobbleId, transactionID]
//        components.queryItems = [bobbleId]

        let message = MSMessage()

        let alternateMessageLayout = MSMessageTemplateLayout()

        alternateMessageLayout.caption = "You've been sent a bobble!"
           
        alternateMessageLayout.image = UIImage(named: "sendBobbleImage")

        alternateMessageLayout.imageTitle = "Mystery Bobble"
        
        message.layout = alternateMessageLayout
        message.summaryText = "You've Received a Mystery Bobble!"
        message.url = components.url

        return message
    }
    
    func generateRandomTransactionID() -> Int? {
        return Int.random(in: 1...1000000)
    }

}

extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myWonBobbles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "BobbleTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BobbleTableViewCellSmall  else {
            fatalError("The dequeued cell is not an instance of BobbleTableViewCell.")
        }
        
        let wonBobble = myWonBobbles[indexPath.row]
        
        for bob in bobbles {
            if(bob.id == wonBobble.id) {
                cell.bobbleImageView.image = UIImage(named: bob.image)
                cell.bobbleNameLabel.text = bob.name
                cell.bobbleRarityLabel.text = String(bob.number)
                cell.bobbleRarityOutOfLabel.text = String(bob.outOf)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let conversation = activeConversation else { fatalError("expected a conversation")}
        
        guard let message = composeMessage(myBobble: myWonBobbles[indexPath.row], randomTransactionId: generateRandomTransactionID()!) else { return }
        
        conversation.insert(message) { error in if let error = error { print(error) }}
    }
}
