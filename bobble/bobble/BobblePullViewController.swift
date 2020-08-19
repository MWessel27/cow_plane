//
//  SecondViewController.swift
//  bobble
//
//  Created by Mikalangelo Wessel on 8/13/20.
//  Copyright © 2020 Mikalangelo Wessel. All rights reserved.
//

import UIKit
import os.log
import bobbleFramework
import myBobblesFramework

class BobblePullViewController: UIViewController {
    
    @IBOutlet var pullBobbleButton: UIButton!
    
    var bobbles = [Bobble]()
    var bobble: Bobble?
    var myWonBobbles = [myBobbles]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let savedBobbles = loadBobbles() {
            bobbles += savedBobbles
        }
        
        if let wonBobbles = loadMyBobbles() {
            myWonBobbles += wonBobbles
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bobbles = []
        myWonBobbles = []
        
        // Do any additional setup after loading the view.
        if let savedBobbles = loadBobbles() {
            bobbles += savedBobbles
        }
        
        if let wonBobbles = loadMyBobbles() {
            myWonBobbles += wonBobbles
        }
    }
    
    private func loadBobbles() -> [Bobble]? {
        let ArchiveURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.mikalanthony.bobble")?.appendingPathComponent("bobbles")
        return NSKeyedUnarchiver.unarchiveObject(withFile: ArchiveURL!.path) as? [Bobble]
    }
    
    private func loadMyBobbles() -> [myBobbles]? {
        let ArchiveURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.mikalanthony.bobble")?.appendingPathComponent("myBobbles")
        return NSKeyedUnarchiver.unarchiveObject(withFile: ArchiveURL!.path) as? [myBobbles]
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
    
//    func addBobble(bobble: Bobble) {
//        bobbles.append(bobble)
//        saveBobbles()
//    }
    
    func addBobble(id: Int) {
        var count = 0
        for bobble in bobbles {
            if(id == bobble.id) {
                let wonBobble = myBobbles(id: id)!
                myWonBobbles.append(wonBobble)
                break
            }
            count += 1
        }
        
        guard let bobbleDetailVC = storyboard?.instantiateViewController(withIdentifier: "BobbleDetailViewController")
          as? BobbleDetailViewController else {
              assertionFailure("No view controller ID BobbleDetailViewController in storyboard")
              return
          }
          
//        bobbleDetailVC.delegate = self

        let selectedBobble = bobbles[count]
        bobbleDetailVC.bobble = selectedBobble
            
        // present the view controller modally without animation
        self.present(bobbleDetailVC, animated: false, completion: nil)
        saveMyBobbles()
    }

    @IBAction func pullBobbleButtonTapped(_ sender: Any) {
//        if(bobbles.isEmpty) {
//            print("Bobbles empty, creating bobble")
//            bobble = Bobble(id: 1, probability: ".test", image: "boxy", name: "boxy", number: 1, outOf: 500, bobbleDescription: "The epic legend of boxy the magical box...")
//            addBobble(bobble: bobble!)
//        } else {
//            print("Bobbles not empty, exiting")
//            return
//        }
        var probabilityDoubles = [(Int, Double)]()
        var count = 0
        for bobble in bobbles {
            if(bobble.probability == ".ultra") {
                probabilityDoubles.append((bobble.id, 0.04))
//                probabilityDoubles.append(0.04)
            } else if(bobble.probability == ".rare") {
                probabilityDoubles.append((bobble.id, 0.08))
//                probabilityDoubles.append(0.08)
            } else if(bobble.probability == ".moderate") {
                probabilityDoubles.append((bobble.id, 0.16))
//                probabilityDoubles.append(0.16)
            } else if(bobble.probability == ".average") {
                probabilityDoubles.append((bobble.id, 0.29))
//                probabilityDoubles.append(0.29)
            } else {
                probabilityDoubles.append((bobble.id, 0.41))
//                probabilityDoubles.append(0.41)
            }
            count += 1
        }
        addBobble(id: randomNumber(probabilities: probabilityDoubles))
    }
    
    func randomNumber(probabilities: [(Int, Double)]) -> Int {
        var sum = 0.0
        for prob in probabilities {
            sum += prob.1
        }
//        print(String(sum))
//        return 0
//        // Sum of all probabilities (so that we don't have to require that the sum is 1.0):
//        let sum = probabilities.reduce(0, +)
        // Random number in the range 0.0 <= rnd < sum :
        let rnd = Double.random(in: 0.0 ..< sum)
        // Find the first interval of accumulated probabilities into which `rnd` falls:
        var accum = 0.0
        for (i, p) in probabilities.enumerated() {
            accum += p.1
            if rnd < accum {
                return p.0
            }
        }
        // This point might be reached due to floating point inaccuracies:
        return (probabilities.count - 1)
    }
}

