//
//  BobbleViewController.swift
//  bobble
//
//  Created by Mikalangelo Wessel on 8/13/20.
//  Copyright © 2020 Mikalangelo Wessel. All rights reserved.
//

import UIKit
import bobbleFramework
import myBobblesFramework

protocol viewBobble {
    func viewBobble(bobble: Bobble)
    func modalDismissed()
}

class BobbleViewController: UIViewController, viewBobble {
    
    @IBOutlet var bobbleTableView: UITableView!
    var bobbles = [Bobble]()
    var myWonBobbles = [myBobbles]()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        NotificationCenter.default.addObserver(self, selector:#selector(reloadTableViewFromBackground), name: UIApplication.willEnterForegroundNotification, object: nil)
        // Do any additional setup after loading the view.
        bobbleTableView.delegate = self
        bobbleTableView.dataSource = self
        if let savedBobbles = loadBobbles() {
            bobbles += savedBobbles
        }
        
        if let wonBobbles = loadMyBobbles() {
            myWonBobbles += wonBobbles
        }
        
        self.bobbleTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bobbles = []
        myWonBobbles = []
        if let savedBobbles = loadBobbles() {
            bobbles += savedBobbles
        }
        
        if let wonBobbles = loadMyBobbles() {
            myWonBobbles += wonBobbles
        }
        
        self.bobbleTableView.reloadData()
    }
    
    @objc private func reloadTableViewFromBackground() {
        bobbles = []
        myWonBobbles = []
        
        if let savedBobbles = loadBobbles() {
            bobbles += savedBobbles
        }
        
        if let wonBobbles = loadMyBobbles() {
            myWonBobbles += wonBobbles
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
    
    func viewBobble(bobble: Bobble) {
        return
    }
    
    func modalDismissed() {
        myWonBobbles = []
        if let wonBobbles = loadMyBobbles() {
            myWonBobbles += wonBobbles
        }
        self.bobbleTableView.reloadData()
    }
}

extension BobbleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myWonBobbles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "BobbleTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BobbleTableViewCell  else {
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
        
//        cell.bobbleImageView.image = UIImage(named: bobble.image)
//        cell.bobbleNameLabel.text = bobble.name
//        cell.bobbleRarityLabel.text = String(bobble.number)
//        cell.bobbleRarityOutOfLabel.text = String(bobble.outOf)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        guard let bobbleDetailVC = storyboard?.instantiateViewController(withIdentifier: "BobbleDetailViewController")
        as? BobbleDetailViewController else {
            assertionFailure("No view controller ID BobbleDetailViewController in storyboard")
            return
        }

        bobbleDetailVC.delegate = self

        let wonBobble = myWonBobbles[indexPath.row]
        var selectedBobble: Bobble?
        for bob in bobbles {
            if(bob.id == wonBobble.id) {
                selectedBobble = bob
            }
        }
        bobbleDetailVC.bobble = selectedBobble

        // present the view controller modally without animation
        self.present(bobbleDetailVC, animated: false, completion: nil)
    }
}

