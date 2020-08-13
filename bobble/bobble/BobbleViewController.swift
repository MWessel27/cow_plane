//
//  BobbleViewController.swift
//  bobble
//
//  Created by Mikalangelo Wessel on 8/13/20.
//  Copyright © 2020 Mikalangelo Wessel. All rights reserved.
//

import UIKit

protocol viewBobble {
    func viewBobble(bobble: Bobble)
}

class BobbleViewController: UIViewController, viewBobble {
    
    @IBOutlet var bobbleTableView: UITableView!
    var bobbles = [Bobble]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bobbleTableView.delegate = self
        bobbleTableView.dataSource = self
        if let savedBobbles = loadBobbles() {
            bobbles += savedBobbles
        }
        
        self.bobbleTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let savedBobbles = loadBobbles() {
            bobbles += savedBobbles
        }
        
        self.bobbleTableView.reloadData()
    }
    
    private func loadBobbles() -> [Bobble]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Bobble.ArchiveURL.path) as? [Bobble]
    }
    
    func viewBobble(bobble: Bobble) {
        return
    }
}

extension BobbleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bobbles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "BobbleTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BobbleTableViewCell  else {
            fatalError("The dequeued cell is not an instance of BobbleTableViewCell.")
        }
        
        let bobble = bobbles[indexPath.row]
        
        cell.bobbleImageView.image = UIImage(named: bobble.image)
        cell.bobbleNameLabel.text = bobble.name
        cell.bobbleRarityLabel.text = String(bobble.number)
        cell.bobbleRarityOutOfLabel.text = String(bobble.outOf)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            guard let bobbleDetailVC = storyboard?.instantiateViewController(withIdentifier: "BobbleDetailViewController")
            as? BobbleDetailViewController else {
                assertionFailure("No view controller ID BobbleDetailViewController in storyboard")
                return
            }
            
            bobbleDetailVC.delegate = self

            let selectedBobble = bobbles[indexPath.row]
            bobbleDetailVC.bobble = selectedBobble
              
              // present the view controller modally without animation
              self.present(bobbleDetailVC, animated: false, completion: nil)
    }
}

