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
import BobblePullTokenFramework

class BobblePullViewController: UIViewController {
    
    @IBOutlet var pullBobbleButton: UIButton!
    @IBOutlet var pullTokenCountLabel: UILabel!
    @IBOutlet var addTestTokensButton: UIButton!
    
    
    var bobbles = [Bobble]()
    var bobble: Bobble?
    var myWonBobbles = [myBobbles]()
    var bobblePullTokens = [BobblePullTokens]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let savedBobbles = loadBobbles() {
            bobbles += savedBobbles
        }
        
        if let wonBobbles = loadMyBobbles() {
            myWonBobbles += wonBobbles
        }
        
        if let pullTokens = loadMyPullTokens() {
            bobblePullTokens += pullTokens
        }
        
        pullTokenCountLabel.text = String(bobblePullTokens[0].bobblePullTokenCount)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bobbles = []
        myWonBobbles = []
        bobblePullTokens = []
        
        // Do any additional setup after loading the view.
        if let savedBobbles = loadBobbles() {
            bobbles += savedBobbles
        }
        
        if let wonBobbles = loadMyBobbles() {
            myWonBobbles += wonBobbles
        }
        
        if let pullTokens = loadMyPullTokens() {
            bobblePullTokens += pullTokens
        }
        
        pullTokenCountLabel.text = String(bobblePullTokens[0].bobblePullTokenCount)
    }
    
    private func loadBobbles() -> [Bobble]? {
        let ArchiveURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.mikalanthony.bobble")?.appendingPathComponent("bobbles")
        return NSKeyedUnarchiver.unarchiveObject(withFile: ArchiveURL!.path) as? [Bobble]
    }
    
    private func loadMyBobbles() -> [myBobbles]? {
        let ArchiveURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.mikalanthony.bobble")?.appendingPathComponent("myBobbles")
        return NSKeyedUnarchiver.unarchiveObject(withFile: ArchiveURL!.path) as? [myBobbles]
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

    private func saveMyBobbles() {
        let ArchiveURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.mikalanthony.bobble")?.appendingPathComponent("myBobbles")
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(myWonBobbles, toFile: ArchiveURL!.path)
        if isSuccessfulSave {
            os_log("Bobbles successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save Bobbles...", log: OSLog.default, type: .error)
        }
    }
    
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
    
    func outOfPullTokens() {
        let alert = UIAlertController(title: "Out of bobble tokens!", message: "Sorry, you're all out of bobble tokens. Try sending one to your friends or trying again tomorrow.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
              switch action.style{
              case .default:
                    print("default")

              case .cancel:
                    print("cancel")

              case .destructive:
                    print("destructive")

        }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addTestTokensButtonTapped(_ sender: Any) {
        bobblePullTokens[0].bobblePullTokenCount += 5
        savePullTokens()
        pullTokenCountLabel.text = String(bobblePullTokens[0].bobblePullTokenCount)
    }
    

    @IBAction func pullBobbleButtonTapped(_ sender: Any) {
        
        if(bobblePullTokens[0].bobblePullTokenCount > 0) {
            var probabilityDoubles = [(Int, Double)]()
            var count = 0
            for bobble in bobbles {
                if(bobble.probability == ".ultra") {
                    probabilityDoubles.append((bobble.id, 0.04))
                } else if(bobble.probability == ".rare") {
                    probabilityDoubles.append((bobble.id, 0.08))
                } else if(bobble.probability == ".moderate") {
                    probabilityDoubles.append((bobble.id, 0.16))
                } else if(bobble.probability == ".average") {
                    probabilityDoubles.append((bobble.id, 0.29))
                } else {
                    probabilityDoubles.append((bobble.id, 0.41))
                }
                count += 1
            }
            addBobble(id: randomNumber(probabilities: probabilityDoubles))
            bobblePullTokens[0].bobblePullTokenCount -= 1
            pullTokenCountLabel.text = String(bobblePullTokens[0].bobblePullTokenCount)
            savePullTokens()
        } else {
            outOfPullTokens()
        }
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

