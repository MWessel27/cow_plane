//
//  SecondViewController.swift
//  bobble
//
//  Created by Mikalangelo Wessel on 8/13/20.
//  Copyright © 2020 Mikalangelo Wessel. All rights reserved.
//

import UIKit
import os.log

class BobblePullViewController: UIViewController {
    
    @IBOutlet var pullBobbleButton: UIButton!
    
    var bobbles = [Bobble]()
    var bobble: Bobble?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let savedBobbles = loadBobbles() {
            bobbles += savedBobbles
        }
    }
    
    private func loadBobbles() -> [Bobble]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Bobble.ArchiveURL.path) as? [Bobble]
    }

    private func saveBobbles() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(bobbles, toFile: Bobble.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Bobbles successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save Bobbles...", log: OSLog.default, type: .error)
        }
    }
    
    func addBobble(bobble: Bobble) {
        bobbles.append(bobble)
        saveBobbles()
    }

    @IBAction func pullBobbleButtonTapped(_ sender: Any) {
        if(bobbles.isEmpty) {
            print("Bobbles empty, creating bobble")
            bobble = Bobble(image: "boxy", name: "boxy", number: 1, outOf: 500, bobbleDescription: "The epic legend of boxy the magical box...")
            addBobble(bobble: bobble!)
        } else {
            print("Bobbles not empty, exiting")
            return
        }
    }
}

